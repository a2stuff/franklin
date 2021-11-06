; da65 V2.19 - Git 59c58acbe
; Created:    2021-11-02 17:43:56
; Input file: Franklin_Ace2000_ROM_U2_P2_Rev6.bin
; Page:       1


        .setcpu "65C02"
        .include "opcodes.inc"

;;; Zero Page

WNDLFT  := $20
WNDWDTH := $21
WNDTOP  := $22
WNDBTM  := $23
CH      := $24
CV      := $25
BASL    := $28
BASH    := $29
BAS2L   := $2A
BAS2H   := $2B
INVFLG  := $32
A1L     := $3C
A1H     := $3D
A2L     := $3E
A2H     := $3F
A4L     := $42
A4H     := $43
RNDL    := $4E
RNDH    := $4F

;;; Page 3 Vectors

XFERVEC := $3ED

;;; Screen Holes

SAVEA   := $4F8
SAVEX   := $578
SAVEY   := $478

OLDCH   := $47B
MODE    := $4FB
        ;; Bit 7 = Escape Mode
        ;; Bit 6 = MouseText active
        ;; Bit 5 = ??? set when "normal"
        ;; Bit 4 = ??? set when "normal"
        ;; Bit 3 = ??? unused ???
        ;; Bit 2 = ??? unused ???
        ;; Bit 1 = ??? used for ???
        ;; Bit 0 = ??? used for ???
M_ESC   = %10000000
M_MOUSE = %01000000
M_NORMAL= %00110000

OURCH   := $57B
OURCV   := $5FB
CHAR    := $67B                 ; Unused
XCOORD  := $6FB
TEMP1   := $77B                 ; Unused
OLDBASL := $77B
TEMP2   := $7FB
OLDBASH := $7FB

;;; I/O Soft Switches

KBD     := $C000
CLR80COL:= $C000
SET80COL:= $C001
RDMAINRAM := $C002
RDCARDRAM := $C003
WRMAINRAM := $C004
WRCARDRAM := $C005
ALTZPOFF:= $C008
ALTZPON := $C009
CLR80VID:= $C00C
SET80VID:= $C00D
CLRALTCHAR := $C00E
SETALTCHAR := $C00F
KBDSTRB := $C010
RDLCBNK2:= $C011
RDLCRAM := $C012
RDRAMRD := $C013
RDRAMWRT:= $C014
RD80COL := $C018
RDTEXT  := $C01A
ALTCHARSET := $C01E
RD80VID := $C01F
TXTPAGE1:= $C054
TXTPAGE2:= $C055
ROMIN   := $C081
ROMIN2  := $C082
LCBANK2 := $C083
LCBANK1 := $C08B

;;; Documented Firmware Entry Points

C3KeyIn := $C305
C3COut1 := $C307
AUXMOVE := $C311
XFER    := $C314

CLRROM  := $CFFF

;;; Monitor ROM

BELLB   := $FBE2
SETWND  := $FB4B
SETKBD  := $FE89
SETVID  := $FE93
MON_VTAB:= $FC22
CLREOP  := $FC42
HOME    := $FC58
CLREOL  := $FC9C


;;; ============================================================

        .org    $C300

        ;; Init
LC300:  bit     SETV            ; V = init
        bra     LC33A

        ;; Input
        .assert * = C3KeyIn, error, "Entry point mismatch"
LC305:  sec
        .byte   OPC_BCC         ; never taken; skip next byte

        ;; Output
        .assert * = C3COut1, error, "Entry point mismatch"
LC307:  clc
        clv
        bra     LC33A

        ;; Signature bytes
        .byte   $01, $88

        ;; Pascal 1.1 Firmware Protocol Table
        .byte   <JPINIT
        .byte   <JPREAD
        .byte   <JPWRITE
        .byte   <JPSTAT

        ;; AUXMOVE
        .assert * = AUXMOVE, error, "Entry point mismatch"
        jmp     JumpAuxMove

        ;; XFER
        .assert * = XFER, error, "Entry point mismatch"
        php
        bit     CLRROM
        plp
        jmp     DoXfer

;;; ============================================================
;;; Pascal Entry Points

JPINIT: bit     CLRROM
        jmp     PascalInit

JPREAD: bit     CLRROM
        jmp     PascalRead

JPWRITE:bit     CLRROM
        jmp     PascalWrite

JPSTAT: bit     CLRROM
        jmp     PascalStatus

JumpAuxMove:
        bit     CLRROM
        jmp     DoAuxMove

;;; ============================================================
;;; Main Entry Points

LC33A:  sta     CLRROM
        sta     SAVEA
        stx     SAVEX
        sty     SAVEY
        pha
        bvc     LC35B

        lda     #<LC305
        sta     $38
        ldx     #>LC305
        stx     $39
        lda     #$07
        sta     $36
        stx     $37
        jsr     LC800
        clc
LC35B:  php
        bit     RD80VID
        bpl     LC36D
        lsr     WNDWDTH
        asl     WNDWDTH
        sta     SET80COL
        lda     OURCH
        sta     CH
LC36D:  plp
        pla
        bcs     LC376
        jsr     LC8B1
        bra     LC3B7

LC376:  ldx     SAVEX
        beq     LC38B
        dex
        lda     $0678
        cmp     #$88            ; left?
        beq     LC38B
        cmp     $0200,x
        bne     LC3AF
        sta     $0200,x
LC38B:  jsr     LC877
        cmp     #$9B            ; escape?
        beq     EscapeMode
        cmp     #$8D            ; return?
        bne     LC39B
        pha
        jsr     DoClearEOL
        pla
LC39B:  cmp     #$95            ; right?
        bne     LC3AA
        jsr     LCEBE
        ora     #$80
        cmp     #$A0            ; non-control char
        bcs     LC3AA
        ora     #$40
LC3AA:  sta     $0678
        bra     LC3B5

LC3AF:  jsr     LC850
        stz     $0678
LC3B5:  bra     LC3BA

LC3B7:  lda     SAVEA
LC3BA:  ldx     SAVEX
        ldy     CH
        sty     OURCH
        ldy     SAVEY
SETV:   rts                     ; has V flag set

;;; ============================================================
;;; Escape Mode

EscapeMode:
        lda     #M_ESC
        tsb     MODE
        jsr     LC850
        jsr     LC933
        cmp     #$98            ; ctrl-x (clear)
        beq     LC3AA
        lda     MODE            ; still in escape mode?
        bmi     EscapeMode
        bra     LC38B

;;; ============================================================

        ;; ???
        bit     CLRROM
        jmp     LCEE7

;;; ============================================================

        brk
        brk
        brk
        brk
        brk
        brk

;;; ============================================================

        ;; ???
        bit     CLRROM
        jmp     LCE18

        bit     CLRROM
        jmp     LCDF7

        bit     CLRROM
        jmp     LCD09

        bit     CLRROM
        jmp     LCD35

;;; ==================================================

        .assert * = $C400, error, "Mismatch"
.scope
LF813           := $F813        ; Not an Apple II entry point
LF981           := $F981        ; Not an Apple II entry point
LFA37           := $FA37        ; Not an Apple II entry point
LFA52           := $FA52        ; Not an Apple II entry point
LFC45           := $FC45        ; Not an Apple II entry point
LFEEB           := $FEEB        ; Not an Apple II entry point

        ldx     #$00
        eor     #$20
        beq     LC419
        and     #$9F
        beq     LC41B
        asl     a
        eor     #$12
        beq     LC41A
        and     #$1A
        eor     #$02
        beq     LC41B
        and     #$10
        bne     LC41A
LC419:  inx
LC41A:  inx
LC41B:  stx     $2F
        jmp     LF813

        lda     KBD
        eor     #$93
        bne     LC439
        lda     KBDSTRB
LC42A:  jsr     LFA37
        lda     KBD
        bpl     LC42A
        eor     #$83
        beq     LC439
        sta     KBDSTRB
LC439:  jmp     LF813

        lda     $2E
        eor     #$FF
        and     ($26),y
        sta     ($26),y
        lda     $2E
        and     $30
        ora     ($26),y
        sta     ($26),y
        jmp     LF813

LC44F:  ldx     #$3C
        jsr     LFC45
        beq     LC463
        jsr     LC469
        jsr     LFA52
        ldx     #$42
        jsr     LFA52
        bra     LC44F

LC463:  jsr     LC469
        jmp     LF813

LC469:  lda     ($00,x)
        sta     ($06,x)
        rts

        and     #$0F
        asl     a
        tax
        lda     LC47E,x
        pha
        lda     LC47E+1,x
        tax
        pla
        jmp     LF813

        ;; Jump Table (target address-1)
LC47E:  .byte   $F0
        sbc     $C100,x
        brk
        .byte   $C2
        brk
        .byte   $C3
        brk
        cpy     $00
        cmp     $00
        dec     $00
        smb4    $1B
        sbc     a:$A9,x
        stz     A2L
        stz     A2H
        stz     $2C

LC498:  ora     A2L
        sta     A2L
        lda     $0200,y
        iny
        jsr     LFEEB
        bmi     LC4B2
        dec     $2C
        ldx     #$04
LC4A9:  asl     A2L
LC4AB:  rol     A2H
        dex
        bne     LC4A9
        bra     LC498

LC4B2:  jmp     LF813

        lsr     a
        phx
        php
        ldx     #$26
        jsr     LF981
        plp
        php
        lda     #$00
        adc     #$00
        tax
        lda     LC4CE,x
        sta     $2E
        plp
        plx
LC4CB:  jmp     LF813

        ;; Data table
LC4CE:  bbr0    $F0,LC4AB
        and     #$0F
        tax
        lda     $C4DD,x
        sta     $30
        plx
        jmp     LF813
        brk
        ora     ($22),y
        .byte   $33
        .byte   $44
        eor     $66,x
        rmb7    $88
        sta     $BBAA,y
        cpy     $EEDD
        .byte   $FF
        tya
        ldy     $C4FD,x
        beq     * + (8)
        cmp     $C000,y
        inx
        bra     $C4EE
        tay
        jmp     LF813
        eor     ($54)
        lsr     $00,x
        lsr     $50,x
        .byte   $53
        brk
        .byte   $9B
        trb     $88FA
        ora     #$FA
        tya
        adc     ($FD,x)
        sta     $21,x
        plx
        sta     $FA16
        brk
        sta     $FC3A
        txa
        adc     $FC
        smb0    $E1
        .byte   $FB
        dey
        .byte   $42
        plx
        brk
        eor     #$F5
        .byte   $FC
        lsr     a
        .byte   $5B
        plx
        .byte   $4B
        sbc     $FB,x
        eor     $FCBC
        brk
        sta     $FEBE
        ldy     #$C9
        inc     $AAAE,x
        sbc     $47BA,x
        sbc     $12BC,x
        inc     $80C7,x
        sed
        dec     $FE8C
        .byte   $82
        bbs7    $DF,LC4CB
        .byte   $02
        cpx     #$99
        smb7    $03
        bcc     $C574
        sbc     a:$00,x
.endscope

;;; ============================================================

        .res $C800 - *, 0

;;; ============================================================

LC800:  lda     #M_NORMAL
        sta     MODE
        jsr     LCBBD
        jsr     DoSETWND
        jmp     DoHomeAndClear

LC80E:  ldy     #$00
        ldx     #$00
LC812:  cpy     WNDWDTH
        bcs     LC820
        jsr     LCEC0
        sta     $0200,x
        inx
        iny
        bra     LC812

LC820:  dey
        sty     CH
        stx     SAVEX
        lda     #$8D
rts1:   rts

Do40Col:
        bit     RD80VID
        php
        jsr     LCBB6
        jsr     LCADA
        jsr     DoSETWND
        plp
        bpl     rts1
        jmp     LCC4E

        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

        jsr     LCB95
LC850:  jsr     LCBC7
LC853:  inc     RNDL
        bne     :+
        inc     RNDH
:
        jsr     LCD09
        bcc     LC853
        jsr     LCD35
        cmp     #$06
        bcc     LC86E
        and     #$7F
        sta     CHAR
        ora     #$80
        bra     LC871

LC86E:  sta     CHAR
LC871:  pha
        jsr     LCBDE
        pla
rts2:   rts

LC877:  jsr     LC850
        cmp     #$00
        beq     LC89F
        cmp     #$02
        beq     LC80E
        cmp     #$05
        bne     rts2
        ldy     CH
LC888:  iny
        cpy     WNDWDTH
        beq     LC897
        jsr     LCEC0
        dey
        jsr     LCECB
        iny
        bra     LC888

LC897:  dey
LC898:  lda     #$A0
        jsr     LCECB
        bra     LC877

LC89F:  ldy     WNDWDTH
        dey
LC8A2:  cpy     CH
        beq     LC898
        dey
        jsr     LCEC0
        iny
        jsr     LCECB
        dey
        bra     LC8A2

LC8B1:  sta     CHAR
LC8B4:  jsr     LC992
        lda     MODE
        and     #$03            ; test low 3 bits
        beq     LC8C1
        jmp     LCA11

LC8C1:  lda     CHAR
        and     #$7F
        cmp     #$20
        bcc     DoCtrlCharOut
        ldy     CH
        cpy     WNDWDTH
        bcc     LC8D3
        jsr     DoReturn
LC8D3:  lda     CHAR            ; char to be printed
        bit     INVFLG
        bmi     LC8F0
        and     #$7F
        bit     MODE
        bvs     LC8F0           ; test bit 6 (MouseText active)
        bit     ALTCHARSET
        bpl     LC8F0
        cmp     #$40
        bcc     LC8F0
        cmp     #$60
        bcs     LC8F0
        and     #$1F
LC8F0:  jsr     LCBF9
        jmp     DoForwardSpace

DoNothing:
        rts

;;; ============================================================
;;; Output control character handling

        ;; Input is char, < $20
DoCtrlCharOut:
        sec
        sbc     #$07
        bcc     DoNothing
        asl     a
        tax
        jmp     (jt1,x)

jt1:
        .addr   DoBell          ; $07 Ctrl-G Bell
        .addr   DoBackspace     ; $08 Ctrl-H Backspace
        .addr   DoNothing       ; $09 Ctrl-I
        .addr   DoLineFeed      ; $0A Ctrl-J Line feed
        .addr   DoClearEOS      ; $0B Ctrl-K Clear EOS
        .addr   DoHomeAndClear  ; $0C Ctrl-L Home and clear
        .addr   DoReturn        ; $0D Ctrl-M Return
        .addr   DoNormal        ; $0E Ctrl-N Normal
        .addr   DoInverse       ; $0F Ctrl-O Inverse
        .addr   DoNothing       ; $10 Ctrl-P
        .addr   Do40Col         ; $11 Ctrl-Q 40-column
        .addr   Do80Col         ; $12 Ctrl-R 80-column
        .addr   DoNothing       ; $13 Ctrl-S
        .addr   DoNothing       ; $14 Ctrl-T
        .addr   DoQuit          ; $15 Ctrl-U Quit
        .addr   DoScroll        ; $16 Ctrl-V Scroll
        .addr   DoScrollUp      ; $17 Ctrl-W Scroll-up
        .addr   DoDisableMouseText ; $18 Ctrl-X Disable MouseText
        .addr   DoHome          ; $19 Ctrl-Y Home
        .addr   DoClearLine     ; $1A Ctrl-Z Clear line
        .addr   DoEnableMouseText ; $1B Ctrl-[ Enable MouseText
        .addr   DoForwardSpace  ; $1C Ctrl-\ Forward space
        .addr   DoClearEOL      ; $1D Ctrl-] Clear EOL
        .addr   LC9F8           ; $1E Ctrl-^ ???
        .addr   DoUp            ; $1F Ctrl-_ Up

;;; ============================================================
;;; GetLn handling
;;; For Escape key sequences

LC933:  pha
        lda     #M_ESC
        trb     MODE            ; clear high bit
        pla
        and     #$7F
        cmp     #'a'
        bcc     LC946
        cmp     #'z'+1
        bcs     LC946
        and     #$DF            ; convert to uppercase

        ;; Scan table for match
LC946:  ldx     #$00
LC948:  ldy     code_table,x
        beq     DoNothing
        cmp     code_table,x
        beq     LC955
        inx
        bra     LC948

LC955:  txa
        asl     a
        tax
        jmp     (jt2,x)


        ;; Character match table
code_table:
        .byte   '@'             ; Escape @ - clear, home & exit mode
        .byte   'A'             ; Escape A - right & exit mode
        .byte   'B'             ; Escape B - left & exit mode
        .byte   'C'             ; Escape C - down & exit mode
        .byte   'D'             ; Escape D - up & exit mode
        .byte   'E'             ; Escape E - clear EOL & exit mode
        .byte   'F'             ; Escape F - clear EOS & exit mode
        .byte   'I'             ; Escape I - up
        .byte   'J'             ; Escape J - left
        .byte   'K'             ; Escape K - right
        .byte   'M'             ; Escape M - down
        .byte   $0b             ; Escape up - up
        .byte   $0a             ; Escape down - down
        .byte   $08             ; Escape left - left
        .byte   $15             ; Escape right - right
        .byte   '4'             ; Escape 4 - 40 col mode
        .byte   '8'             ; Escape 8 - 80 col mode
        .byte   $11             ; Escape Ctrl+Q - deactivate

        .byte   $00             ; sentinel


        ;; Jump table
jt2:
        .addr   DoHomeAndClear  ; Escape @ - clear, home & exit mode
        .addr   DoForwardSpace  ; Escape A - right & exit mode
        .addr   DoBackspace     ; Escape B - left & exit mode
        .addr   DoLineFeed      ; Escape C - down & exit mode
        .addr   DoUp            ; Escape D - up & exit mode
        .addr   DoClearEOL      ; Escape E - clear EOL & exit mode
        .addr   DoClearEOS      ; Escape F - clear EOS & exit mode
        .addr   DoUpRemain      ; Escape I - up
        .addr   DoLeftRemain    ; Escape J - left
        .addr   DoRightRemain   ; Escape K - right
        .addr   DoDownRemain    ; Escape M - down
        .addr   DoUpRemain      ; Escape up - up
        .addr   DoDownRemain    ; Escape down - down
        .addr   DoLeftRemain    ; Escape left - left
        .addr   DoRightRemain   ; Escape right - right
        .addr   Do40Col         ; Escape 4 - 40 col mode
        .addr   Do80Col         ; Escape 8 - 80 col mode
        .addr   DoQuit          ; Escape Ctrl+Q - deactivate

;;; ============================================================

LC992:
        lda     KBD
        cmp     #$93            ; Ctrl-S
        bne     rts3
        bit     KBDSTRB
:       lda     KBD
        bpl     :-
        cmp     #$83            ; Ctrl-C
        beq     rts3
        bit     KBDSTRB
rts3:   rts

;;; ============================================================

        ;; Unused???
        nop
        jmp     LCB60

;;; ============================================================

DoUpRemain:
        jsr     DoUp
        bra     Remain

DoDownRemain:
        jsr     DoLineFeed
        bra     Remain

DoRightRemain:
        jsr     DoForwardSpace
        bra     Remain

DoLeftRemain:
        jsr     DoBackspace
Remain: lda     #M_ESC          ; stay in Escape Mode
        jmp     SetModeBits

DoInverse:
        ldy     #$3F
        bra     LC9CA

DoNormal:
        ldy     #$FF
LC9CA:  sty     INVFLG
rts4:   rts

Do80Col:
        bit     RD80VID
        php
        jsr     LCBBD
        jsr     LCADA
        jsr     DoSETWND
        plp
        bmi     rts4
        jmp     LCBFE

DoQuit:
        jsr     Do40Col
        jsr     DoSETVID
        jsr     DoSETKBD
        lda     #23
        ldx     #0
        jsr     LCA80

        lda     #$FF
        sta     MODE            ; set all mode bits (???)

        lda     #$98
        rts

;;; ============================================================
;;; Adusting MODE Bits

LC9F8:  lda     #$FC            ; clear mode bits %xxxxxx00
        jsr     PreserveModeBits
        lda     #$32            ; set mode bits   %xx11xx1x
        bra     SetModeBits

DoDisableMouseText:
        lda     #M_MOUSE        ; clear bit BUG: Should be ~M_MOUSE
PreserveModeBits:
        and     MODE
        bra     StoreMode

DoEnableMouseText:
        lda     #M_MOUSE

SetModeBits:
        ora     MODE
StoreMode:
        sta     MODE
        rts

;;; ============================================================

LCA11:  lda     CHAR            ; character to read/print
        sec
        sbc     #$20
        and     #$7F
        pha
        dec     MODE            ; clear low bit???
        lda     MODE
        and     #$03            ; test low 2 bits
        bne     LCA36
        pla
        cmp     #$18            ; +$20 is $38 = '8' ???
        bcs     LCA2C
        jsr     LCA82
LCA2C:  lda     $05F8
        cmp     WNDWDTH
        bcs     :+
        sta     CH
:       rts

LCA36:  pla
        sta     $05F8
        rts

;;; ============================================================

DoForwardSpace:
        inc     CH
        lda     CH
        cmp     WNDWDTH
        bcs     DoReturn
        rts

;;; ============================================================

DoBackspace:
        lda     CH
        beq     :+
        dec     CH
rts5:   rts

:       lda     CV
        beq     rts5
        lda     WNDWDTH
        dec     a
        sta     CH

;;; ============================================================

DoUp:
        lda     CV
        beq     rts5
        dec     CV
        bra     LCA84

;;; ============================================================

DoReturn:
        stz     CH
        ;; fall through

;;; ============================================================

DoLineFeed:
        lda     CV
        cmp     #23
        bcs     DoScrollUp
        inc     CV
        bra     LCA84

;;; ============================================================

DoHome:
        lda     WNDTOP
        ldx     #$00
        bra     LCA80

;;; ============================================================

DoClearLine:
        lda     CH
        pha
        stz     CH
        jsr     DoClearEOL
        pla
        sta     CH
        rts

;;; ============================================================

LCA7A:  lda     $06F8
        ldx     $0778
LCA80:  stx     CH
LCA82:  sta     CV
LCA84:  jmp     DoMON_VTAB

;;; ============================================================

DoScrollUp:
        lda     CH
        pha
        jsr     DoHome
LCA8D:  ldy     BASH
        sty     BAS2H
        ldy     BASL
        sty     BAS2L
        lda     WNDBTM
        beq     LCACF
        dec     a
        cmp     CV
        beq     LCACF
        bcc     LCACF
        inc     CV
        jsr     LCA84
        ldy     WNDWDTH
        dey
        bit     RD80VID
        bmi     LCAB6
LCAAD:  lda     (BASL),y
        sta     (BAS2L),y
        dey
        bpl     LCAAD
        bra     LCA8D

LCAB6:  tya
        lsr     a
        tay
LCAB9:  bit     TXTPAGE1
        lda     (BASL),y
        sta     (BAS2L),y
        bit     TXTPAGE2
        lda     (BASL),y
        sta     (BAS2L),y
        dey
        bpl     LCAB9
        bit     TXTPAGE1
        bra     LCA8D

LCACF:  stz     CH
        jsr     DoClearEOL
        plx
        lda     CV
        jmp     LCA80

LCADA:  lda     CV
        sta     $06F8
        lda     CH
        sta     $0778
        rts

;;; ============================================================

;;; Load X,Y with address of a routine -1 (for `ROMCall`)
.macro LDXY addr
        ldx     #.hibyte(addr-1)
        ldy     #.lobyte(addr-1)
.endmacro

;;; ============================================================

DoBell:
        LDXY    BELLB
        jmp     ROMCall

;;; ============================================================

DoScroll:
        jsr     LCADA
        lda     WNDBTM
        dec     a
        dec     a
        sta     $05F8
LCAF6:  lda     $05F8
        jsr     LCA82
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
        lda     $05F8
        inc     a
        jsr     LCA82
        ldy     WNDWDTH
        dey
LCB0E:  phy
        bit     TXTPAGE1
        bit     RD80VID
        bpl     LCB1F
        tya
        lsr     a
        tay
        bcs     LCB1F
        bit     TXTPAGE2
LCB1F:  lda     (BAS2L),y
        sta     (BASL),y
        ply
        dey
        bpl     LCB0E
        bit     TXTPAGE1
        lda     $05F8
        cmp     WNDTOP
        beq     LCB36
        dec     $05F8
        bra     LCAF6

LCB36:  lda     #$00
        jsr     LCA82
        jsr     DoClearLine
        bit     TXTPAGE1
        jmp     LCA7A

;;; ============================================================

PascalInit:
        jsr     LC800
LCB47:  jsr     LCBC7
LCB4A:  ldx     CH
        stx     OURCH
        ldx     #$00
        rts

;;; ============================================================

PascalRead:
        jsr     LCB95
        jsr     LC850
        lda     CHAR
        bra     LCB4A

;;; ============================================================

PascalWrite:
        sta     CHAR
LCB60:  jsr     LCB95
        jsr     LCBDE
        lda     CHAR
        ora     #$80
        sta     CHAR
        and     #$7F
        cmp     #$15            ; right?
        beq     LCB4A
        cmp     #$0D            ; return?
        beq     LCB7D
        jsr     LC8B4
        bra     LCB47

LCB7D:  stz     CH
        bra     LCB47

;;; ============================================================

PascalStatus:
        cmp     #$00
        beq     LCB8E
        cmp     #$01
        bne     LCB91
        jsr     LCD09
        bra     LCB4A

LCB8E:  sec
        bra     LCB4A

LCB91:  ldx     #$03
        clc
        rts

;;; ============================================================

LCB95:  pha
        lda     OLDBASL
        sta     BASL
        lda     OLDBASH
        sta     BASH
        stz     WNDTOP
        stz     WNDLFT
        lda     #80
        sta     WNDWDTH
        lda     #24
        sta     WNDBTM
        lda     OURCH
        sta     CH
        pla
        rts

        ;; ???
        sta     CLRALTCHAR
LCBB6:  sta     CLR80COL
        sta     CLR80VID
        rts

LCBBD:  sta     SET80COL
        sta     SET80VID
        sta     SETALTCHAR
        rts

LCBC7:  lda     MODE            ; all mode bits set?
        cmp     #$FF
        beq     LCBEA
        and     #M_ESC          ; escape mode?
        beq     LCBEA
        jsr     LCEBE
        sta     OLDCH
        and     #$80
        eor     #$AB
        bra     LCBF9

LCBDE:  lda     MODE            ; test high bit
        and     #M_ESC          ; escape mode?
        beq     LCBEA
        lda     OLDCH
        bra     LCBF9

LCBEA:  jsr     LCEBE
        eor     #$80
        cmp     #$40
        bcc     LCBF9
        cmp     #$60
        bcs     LCBF9
        and     #$1F
LCBF9:  ldy     CH
        jmp     LCECB

LCBFE:  php
        sei
        lda     WNDTOP
        sta     $05F8
LCC05:  lda     $05F8
        jsr     LCA82
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
        ldy     #$00
LCC15:  bit     TXTPAGE1
        lda     (BAS2L)
        bit     TXTPAGE2
        sta     (BASL),y
        bit     TXTPAGE1
        inc     BAS2L
        lda     (BAS2L)
        sta     (BASL),y
        iny
        inc     BAS2L
        cpy     #$14
        bcc     LCC15
        lda     #$A0
LCC31:  bit     TXTPAGE2
        sta     (BASL),y
        bit     TXTPAGE1
        sta     (BASL),y
        iny
        cpy     #$28
        bcc     LCC31
        inc     $05F8
        lda     $05F8           ; vertical position
        cmp     #24
        bcc     LCC05
LCC4A:  plp
        jmp     LCA7A

LCC4E:  php
        sei
        sta     SET80COL
        lda     WNDTOP
        sta     $05F8
LCC58:  lda     $05F8
        jsr     LCA82
        ldy     #$13
        bit     TXTPAGE1
LCC63:  lda     (BASL),y
        pha
        dey
        bpl     LCC63
        ldy     #$00
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
LCC73:  bit     TXTPAGE2
        lda     (BASL),y
        bit     TXTPAGE1
        sta     (BAS2L)
        inc     BAS2L
        pla
        sta     (BAS2L)
        inc     BAS2L
        iny
        cpy     #$14
        bcc     LCC73
        inc     $05F8           ; vertical position
        lda     $05F8
        cmp     #24
        bcc     LCC58
        sta     CLR80COL
        bra     LCC4A

;;; ============================================================
;;; XFER

DoXfer:
        pha
        lda     XFERVEC
        pha
        lda     XFERVEC+1
        pha
        sta     RDMAINRAM
        sta     WRMAINRAM
        bcc     :+
        sta     RDCARDRAM
        sta     WRCARDRAM
:       pla
        sta     XFERVEC+1
        pla
        sta     XFERVEC
        pla
        sta     ALTZPOFF
        bvc     :+
        sta     ALTZPON
:       jmp     (XFERVEC)

;;; ============================================================

DoAuxMove:
        pha
        bit     RDRAMRD
        php
        bit     RDRAMWRT
        php
        sta     WRMAINRAM
        sta     RDCARDRAM
        bcc     LCCDA
        sta     RDMAINRAM
        sta     WRCARDRAM
LCCDA:  lda     (A1L)
        sta     (A4L)
        inc     A4L
        bne     LCCE4
        inc     A4H
LCCE4:  lda     A1L
        cmp     A2L
        lda     A1H
        sbc     A2H
        inc     A1L
        bne     LCCF2
        inc     A1H
LCCF2:  bcc     LCCDA
        sta     WRCARDRAM
        plp
        bmi     LCCFD
        sta     WRMAINRAM
LCCFD:  sta     RDCARDRAM
        plp
        bmi     LCD06
        sta     RDMAINRAM
LCD06:  pla
        sec
        rts

LCD09:  bit     $0579
        bmi     LCD17
LCD0E:  bit     KBD
        bmi     LCD15
        clc
        rts

LCD15:  sec
        rts

LCD17:  jsr     LCDB3
        beq     LCD21
LCD1C:  stz     $0579
        bra     LCD0E

LCD21:  phx
        ldx     $0479
        jsr     LCE1F
        lda     $0200,x
        jsr     LCE2E
        plx
        cmp     #$00
        beq     LCD1C
        bra     LCD15

LCD35:  bit     $0579
        bmi     LCD90
        lda     KBD
        bit     KBDSTRB
        bit     $C027           ; ???
        bpl     LCD4C
LCD45:  cmp     #$06
        bcc     LCD4B
        ora     #$80
LCD4B:  rts

LCD4C:  and     #$7F
        cmp     #$01
        bne     LCD56
        lda     #$1A
        bra     LCD45

LCD56:  cmp     #$03
        bne     LCD5E
        lda     #$0C
        bra     LCD45

LCD5E:  cmp     #$04
        bne     LCD66
        lda     #$19
        bra     LCD45

LCD66:  cmp     #$06
        bne     LCD6E
        lda     #$2C
        bra     LCD7E

LCD6E:  cmp     #$1F
        bne     LCD76
        lda     #$2D
        bra     LCD7E

LCD76:  cmp     #$20            ; space?
        bcc     LCD45
        cmp     #$2C            ; comma?
        bcs     LCD45
LCD7E:  pha
        jsr     LCDB3
        beq     LCD87
        pla
        bra     LCD45

LCD87:  lda     #$FF
        sta     $0579
        pla
        jsr     LCDC9
LCD90:  jsr     LCDB3
        beq     LCD9C
LCD95:  stz     $0579
        lda     #$A0
        bra     LCD45

LCD9C:  phx
        ldx     $0479
        jsr     LCE1F
        lda     $0200,x
        jsr     LCE2E
        plx
        inc     $0479
        cmp     #$00
        beq     LCD95
        bra     LCD45

LCDB3:  jsr     LCE1F
        lda     #$00
        phx
        tax
        clc
LCDBB:  adc     $0200,x
        inx
        bne     LCDBB
        plx
        jsr     LCE2E
        cmp     $04F9
        rts

LCDC9:  phx
        phy
        jsr     LCE1F
        sec
        sbc     #$20
        ldy     #$00
        tax
        beq     LCDE2
LCDD6:  lda     $0200,y
        beq     LCDDE
        iny
        bra     LCDD6

LCDDE:  iny
LCDDF:  dex
        bne     LCDD6
LCDE2:  jsr     LCE2E
        sty     $0479
        ply
        plx
        rts

        ;; ???
        .byte   $52, $55, $4e, $0d, $00
        .byte   $4c, $49, $53, $54, $0d, $00, $ff

;;; ============================================================

LCDF7:  sta     WRCARDRAM
        lda     #$00
        tax
LCDFD:  sta     $0200,x
        inx
        cpx     #$0C
        bcc     LCDFD
LCE05:  lda     LCDDF,x
        cmp     #$FF
        beq     LCE12
        sta     $0200,x
        inx
        bra     LCE05

LCE12:  sta     WRMAINRAM
        stz     $0579
LCE18:  jsr     LCDB3
        sta     $04F9
        rts

LCE1F:  pha
        lda     RDRAMRD
        sta     RDMAINRAM
        sta     $07F8
        sta     RDCARDRAM
        pla
        rts

LCE2E:  pha
        sta     RDMAINRAM
        lda     $07F8
        bpl     LCE3A
        sta     RDCARDRAM
LCE3A:  pla
        rts

;;; ============================================================

DoSETWND:
        lda     #0              ; set cursor to row 0
        bit     RDTEXT          ; unless graphics mode
        bmi     :+
        lda     #20             ; then use row 20
:       LDXY    SETWND
        bra     ROMCall

;;; ============================================================

DoSETKBD:
        LDXY    SETKBD
        bra     ROMCall

;;; ============================================================

DoSETVID:
        LDXY    SETVID
        bra     ROMCall

;;; ============================================================

DoMON_VTAB:
        LDXY    MON_VTAB
        bra     ROMCall

;;; ============================================================

DoClearEOS:
        LDXY    CLREOP
        bra     ROMCall

;;; ============================================================

DoHomeAndClear:
        LDXY    HOME
        bra     ROMCall

;;; ============================================================

DoClearEOL:
        LDXY    CLREOL

;;; ============================================================

;;; A = character, X,Y = ROM address-1 (return value to push to stack)
ROMCall:
        sta     TEMP2
        bit     RDLCRAM
        php
        bit     RDLCBNK2
        php
        lda     #$CE
        pha
        lda     #$86
        pha
        phx
        phy
        bit     ROMIN2
        lda     TEMP2
        rts

;;; ============================================================

        ;; ???
        plp
        bpl     LCE9D
        plp
        bpl     LCE95
        bit     LCBANK2
        bit     LCBANK2
        bra     LCEAE

LCE95:  bit     ROMIN
        bit     ROMIN
        bra     LCEAE

LCE9D:  plp
        bpl     LCEA8
        bit     LCBANK1
        bit     LCBANK1
        bra     LCEAE

LCEA8:  bit     $C089           ; ???
        bit     $C089           ; ???
LCEAE:  lda     BASL
        sta     OLDBASL
        lda     BASH
        sta     OLDBASH
        lda     CH
        sta     OURCH
        rts

LCEBE:  ldy     CH
LCEC0:  phy
        jsr     LCED5
        lda     (BASL),y
LCEC6:  ply
        bit     TXTPAGE1
        rts

LCECB:  phy
        pha
        jsr     LCED5
        pla
        sta     (BASL),y
        bra     LCEC6

LCED5:  bit     RD80VID
        bpl     LCEDF
        tya
        lsr     a
        tay
        bcc     LCEE3
LCEDF:  bit     TXTPAGE1
        rts

LCEE3:  bit     TXTPAGE2
        rts

;;; ============================================================
;;; AUXMOVE implementation

LCEE7:  bit     RD80COL
        php
        sta     CLR80COL
        bit     RDRAMRD
        php
        bit     RDRAMWRT
        php
        phx
        plx
        beq     LCEFD
        jmp     LCF83

LCEFD:  bcc     LCF35
        sta     RDMAINRAM
        sta     WRCARDRAM
        lda     A4L
        ldx     A4H
        sta     ALTZPON
        sta     A4L
        stx     A4H
        sta     ALTZPOFF
LCF13:  lda     (A1L)
        sta     ALTZPON
        sta     (A4L)
        inc     A4L
        bne     LCF20
        inc     A4H
LCF20:  sta     ALTZPOFF
        lda     A1L
        cmp     A2L
        lda     A1H
        sbc     A2H
        inc     A1L
        bne     LCF31
        inc     A1H
LCF31:  bcc     LCF13
        bra     LCF67

LCF35:  sta     RDCARDRAM
        sta     WRMAINRAM
        lda     A1L
        ldx     A1H
        sta     ALTZPON
        sta     A1L
        stx     A1H
LCF46:  sta     ALTZPON
        lda     (A1L)
        ldx     A1L
        ldy     A1H
        inc     A1L
        bne     LCF55
        inc     A1H
LCF55:  sta     ALTZPOFF
        sta     (A4L)
        inc     A4L
        bne     LCF60
        inc     A4H
LCF60:  cpx     A2L
        tya
        sbc     A2H
        bcc     LCF46
LCF67:  sta     ALTZPOFF
        sta     WRCARDRAM
        plp
        bmi     LCF73
        sta     WRMAINRAM
LCF73:  sta     RDCARDRAM
        plp
        bmi     LCF7C
        sta     RDMAINRAM
LCF7C:  plp
        bpl     LCF82
        sta     SET80COL
LCF82:  rts

LCF83:  bcc     LCFB7
        sta     RDMAINRAM
        sta     WRCARDRAM
        lda     A4L
        ldy     A4H
        sta     ALTZPON
        sta     A4L
        sty     A4H
        sta     ALTZPOFF
        ldy     #$00
:       lda     (A1L),y
        sta     ALTZPON
        sta     (A4L),y
        sta     ALTZPOFF
        iny
        bne     :-
        inc     A1H
        sta     ALTZPON
        inc     A4H
        sta     ALTZPOFF
        dex
        bne     :-
        bra     LCFE4

LCFB7:  sta     RDCARDRAM
        sta     WRMAINRAM
        lda     A1L
        ldy     A1H
        sta     ALTZPON
        sta     A1L
        sty     A1H
        ldy     #$00
:       sta     ALTZPON
        lda     (A1L),y
        sta     ALTZPOFF
        sta     (A4L),y
        iny
        bne     :-
        inc     A4H
        sta     ALTZPON
        inc     A1H
        sta     ALTZPOFF
        dex
        bne     :-
LCFE4:  jmp     LCF67

;;; ============================================================

        .res    $D000 - *, 0
