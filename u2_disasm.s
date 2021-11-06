; da65 V2.19 - Git 59c58acbe
; Created:    2021-11-02 17:43:56
; Input file: Franklin_Ace2000_ROM_U2_P2_Rev6.bin
; Page:       1


        .setcpu "65C02"

LF813           := $F813        ; Not an Apple II entry point
LF981           := $F981        ; Not an Apple II entry point
LFA37           := $FA37        ; Not an Apple II entry point
LFA52           := $FA52        ; Not an Apple II entry point
LFC45           := $FC45        ; Not an Apple II entry point
LFEEB           := $FEEB        ; Not an Apple II entry point

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

OLDCH   := $47B
MODE    := $4FB
OURCH   := $57B
OURCV   := $5FB
CHAR    := $67B                 ; Unused
XCOORD  := $6FB
TEMP1   := $77B                 ; Unused
OLDBASL := $77B
TEMP2   := $7FB
OLDBASH := $7FB

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

BELLB   := $FBE2
SETWND  := $FB4B
SETKBD  := $FE89
SETVID  := $FE93
MON_VTAB:= $FC22
CLREOP  := $FC42
HOME    := $FC58
CLREOL  := $FC9C

AUXMOVE := $C311
XFER    := $C314

;;; ============================================================

        .org    $C300

LC300:  bit     SETV            ; V = init
        bra     LC33A

LC305:  sec
        bcc     $C320           ; never taken
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
        jmp     LC334

        ;; XFER
        .assert * = XFER, error, "Entry point mismatch"
        php
        bit     LCFFF
        plp
        jmp     LCC98

JPINIT: bit     LCFFF
        jmp     LCB44

JPREAD: bit     LCFFF
        jmp     LCB52

JPWRITE:bit     LCFFF
        jmp     LCB5D

JPSTAT: bit     LCFFF
        jmp     LCB81

LC334:  bit     LCFFF
        jmp     LCCC3

LC33A:  sta     LCFFF
        sta     $04F8
        stx     $0578
        sty     $0478
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

LC376:  ldx     $0578
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
        beq     LC3C6
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

LC3B7:  lda     $04F8
LC3BA:  ldx     $0578
        ldy     CH
        sty     OURCH
        ldy     $0478
SETV:   rts                     ; has V flag set

LC3C6:  lda     #$80
        tsb     MODE            ; set mode high bit
        jsr     LC850
        jsr     LC933
        cmp     #$98            ; ctrl-x (clear)
        beq     LC3AA
        lda     MODE            ; mode
        bmi     LC3C6           ; test high bit
        bra     LC38B

        bit     LCFFF
        jmp     LCEE7

        brk
        brk
        brk
        brk
        brk
        brk

        bit     LCFFF
        jmp     LCE18

        bit     LCFFF
        jmp     LCDF7

        bit     LCFFF
        jmp     LCD09

        bit     LCFFF
        jmp     LCD35

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
        lda     LC47F,x
        tax
        pla
        jmp     LF813

LC47E:  .byte   $F0
LC47F:  sbc     $C100,x
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
        stz     $3E
        stz     $3F
        stz     $2C
LC498:  ora     $3E
        sta     $3E
        lda     $0200,y
        iny
        jsr     LFEEB
        bmi     LC4B2
        dec     $2C
        ldx     #$04
LC4A9:  asl     $3E
LC4AB:  rol     $3F
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

LC4CE:  bbr0    $F0,LC4AB
        and     #$0F
        tax
        lda     LC4DD,x
        sta     $30
        plx
        jmp     LF813

LC4DD:  brk
        ora     ($22),y
        .byte   $33
        .byte   $44
        eor     $66,x
        rmb7    $88
        sta     $BBAA,y
        cpy     $EEDD
        .byte   $FF
        tya
LC4EE:  ldy     $C4FD,x
        beq     * + (8)
        cmp     $C000,y
        inx
        bra     LC4EE

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

;;; ============================================================

        .res $C800 - *, 0

;;; ============================================================

LC800:  lda     #$30            ; set to normal state (%00110000)
        sta     MODE            ; mode
        jsr     LCBBD
        jsr     LCE3C
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
        stx     $0578
        lda     #$8D
LC828:  rts

Do40Col:
        bit     RD80VID
        php
        jsr     LCBB6
        jsr     LCADA
        jsr     LCE3C
        plp
        bpl     LC828
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
LC853:  inc     $4E
        bne     LC859
        inc     $4F
LC859:  jsr     LCD09
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
LC876:  rts

LC877:  jsr     LC850
        cmp     #$00
        beq     LC89F
        cmp     #$02
        beq     LC80E
        cmp     #$05
        bne     LC876
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
        lda     MODE            ; mode
        and     #$03            ; test low 3 bits
        beq     LC8C1
        jmp     LCA11

LC8C1:  lda     CHAR
        and     #$7F
        cmp     #$20
        bcc     LC8F7
        ldy     CH
        cpy     WNDWDTH
        bcc     LC8D3
        jsr     DoReturn
LC8D3:  lda     CHAR            ; char to be printed
        bit     $32
        bmi     LC8F0
        and     #$7F
        bit     MODE            ; mode
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

        ;; Input is char, < $20
LC8F7:  sec
        sbc     #$07
        bcc     DoNothing
        asl     a
        tax
        jmp     (LC901,x)

        ;; Jump Table
LC901:
        .addr   DoBell          ; $07 Ctrl-G Bell
        .addr   DoBackspace     ; $08; Ctrl-H Backspace
        .addr   DoNothing       ; $09 Ctrl-I ???
        .addr   DoLineFeed      ; $0A Ctrl-J Line feed
        .addr   DoClearEOS      ; $0B Ctrl-K Clear EOS
        .addr   DoHomeAndClear  ; $0C Ctrl-L Home and clear
        .addr   DoReturn        ; $0D Ctrl-M Return
        .addr   DoNormal        ; $0E Ctrl-N Normal
        .addr   DoInverse       ; $0F Ctrl-O Inverse
        .addr   DoNothing       ; $10 Ctrl-P ???
        .addr   Do40Col         ; $11 Ctrl-Q 40-column
        .addr   Do80Col         ; $12 Ctrl-R 80-column
        .addr   DoNothing       ; $13 Ctrl-S Stop list
        .addr   DoNothing       ; $14 Ctrl-T ???
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

LC933:  pha
        lda     #$80
        trb     MODE            ; clear mode high bit
        pla
        and     #$7F
        cmp     #'a'
        bcc     LC946
        cmp     #'z'+1
        bcs     LC946
        and     #$DF            ; convert to uppercase

        ;; Scan table for match
LC946:  ldx     #$00
LC948:  ldy     LC95B,x
        beq     DoNothing
        cmp     LC95B,x
        beq     LC955
        inx
        bra     LC948

LC955:  txa
        asl     a
        tax
        jmp     (LC96E,x)


        ;; Character match table
LC95B:
        .byte   '@'
        .byte   'A'
        .byte   'B'
        .byte   'C'
        .byte   'D'
        .byte   'E'
        .byte   'F'
        .byte   'I'
        .byte   'J'
        .byte   'K'
        .byte   'M'
        .byte   $0b             ; up
        .byte   $0a             ; down
        .byte   $08             ; left
        .byte   $15             ; right
        .byte   '4'             ; 40 col
        .byte   '8'             ; 80 col
        .byte   $11             ; Ctrl+Q

        .byte   $00             ; sentinel


        ;; Jump table
LC96E:  .addr   DoHomeAndClear  ; '@'
        .addr   DoForwardSpace  ; 'A'
        .addr   DoBackspace     ; 'B'
        .addr   DoLineFeed      ; 'C'
        .addr   DoUp            ; 'D'
        .addr   DoClearEOL      ; 'E'
        .addr   DoClearEOS      ; 'F'
        .addr   LC9AD           ; 'I'
        .addr   LC9BC           ; 'J'
        .addr   LC9B7           ; 'K'
        .addr   LC9B2           ; 'M'
        .addr   LC9AD           ; up
        .addr   LC9B2           ; down
        .addr   LC9BC           ; left
        .addr   LC9B7           ; right
        .addr   Do40Col         ; 40 col
        .addr   Do80Col         ; 80 col
        .addr   DoQuit          ; Ctrl+Q

;;; ============================================================

LC992:  lda     KBD
        cmp     #$93            ; Ctrl-S
        bne     LC9A8
        bit     KBDSTRB
LC99C:  lda     KBD
        bpl     LC99C
        cmp     #$83            ; Ctrl-C
        beq     LC9A8
        bit     KBDSTRB
LC9A8:  rts

        nop
        jmp     LCB60

LC9AD:  jsr     DoUp
        bra     LC9BF

LC9B2:  jsr     DoLineFeed
        bra     LC9BF

LC9B7:  jsr     DoForwardSpace
        bra     LC9BF

LC9BC:  jsr     DoBackspace
LC9BF:  lda     #$80            ; set mode bits %1xxxxxxx
        jmp     LCA0A

DoInverse:
        ldy     #$3F
        bra     LC9CA

DoNormal:
        ldy     #$FF
LC9CA:  sty     $32
LC9CC:  rts

Do80Col:
        bit     RD80VID
        php
        jsr     LCBBD
        jsr     LCADA
        jsr     LCE3C
        plp
        bmi     LC9CC
        jmp     LCBFE

DoQuit:
        jsr     Do40Col
        jsr     LCE51
        jsr     LCE4B
        lda     #$17
        ldx     #$00
        jsr     LCA80
        lda     #$FF
        sta     MODE            ; set all mode bits (???)
        lda     #$98
        rts

LC9F8:  lda     #$FC            ; clear mode bits %xxxxxx00
        jsr     LCA03
        lda     #$32            ; set mode bits   %xx11xx1x
        bra     LCA0A

DoDisableMouseText:
        lda     #$40            ; clear mode bits %0x00000
LCA03:  and     MODE
        bra     LCA0D

DoEnableMouseText:
        lda     #$40            ; set mode bits   %x1xxxxxx - enable MT mode
LCA0A:  ora     MODE
LCA0D:  sta     MODE
        rts

LCA11:  lda     CHAR            ; character to read/print
        sec
        sbc     #$20
        and     #$7F
        pha
        dec     MODE            ; mode ... clear low bit?
        lda     MODE
        and     #$03            ; mode test low 2 bits
        bne     LCA36
        pla
        cmp     #$18            ; +$20 is $38 = '8' ???
        bcs     LCA2C
        jsr     LCA82
LCA2C:  lda     $05F8
        cmp     WNDWDTH
        bcs     LCA35
        sta     CH
LCA35:  rts

LCA36:  pla
        sta     $05F8
        rts

DoForwardSpace:
        inc     CH
        lda     CH
        cmp     WNDWDTH
        bcs     DoReturn
        rts

DoBackspace:
        lda     CH
        beq     LCA4B
        dec     CH
LCA4A:  rts

LCA4B:  lda     CV
        beq     LCA4A
        lda     WNDWDTH
        dec     a
        sta     CH

DoUp:
        lda     CV
        beq     LCA4A
        dec     CV
        bra     LCA84

DoReturn:
        stz     CH

DoLineFeed:
        lda     CV
        cmp     #$17            ; 23
        bcs     DoScrollUp
        inc     CV
        bra     LCA84

DoHome:
        lda     WNDTOP
        ldx     #$00
        bra     LCA80

DoClearLine:
        lda     CH
        pha
        stz     CH
        jsr     DoClearEOL
        pla
        sta     CH
        rts

LCA7A:  lda     $06F8
        ldx     $0778
LCA80:  stx     CH
LCA82:  sta     CV
LCA84:  jmp     LCE57

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

.macro LDXY addr
        ldx     #.hibyte(addr-1)
        ldy     #.lobyte(addr-1)
.endmacro

DoBell:
        LDXY    BELLB
        jmp     LCE6D

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

LCB44:  jsr     LC800
LCB47:  jsr     LCBC7
LCB4A:  ldx     CH
        stx     OURCH
        ldx     #$00
        rts

LCB52:  jsr     LCB95
        jsr     LC850
        lda     CHAR
        bra     LCB4A

LCB5D:  sta     CHAR
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

LCB81:  cmp     #$00
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
        and     #$80            ; test high bit
        beq     LCBEA
        jsr     LCEBE
        sta     OLDCH
        and     #$80
        eor     #$AB
        bra     LCBF9

LCBDE:  lda     MODE            ; test mode high bit
        and     #$80
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

LCC98:  pha
        lda     $03ED
        pha
        lda     $03EE
        pha
        sta     RDMAINRAM
        sta     WRMAINRAM
        bcc     LCCAF
        sta     RDCARDRAM
        sta     WRCARDRAM
LCCAF:  pla
        sta     $03EE
        pla
        sta     $03ED
        pla
        sta     ALTZPOFF
        bvc     LCCC0
        sta     ALTZPON
LCCC0:  jmp     ($03ED)

LCCC3:  pha
        bit     RDRAMRD
        php
        bit     RDRAMWRT
        php
        sta     WRMAINRAM
        sta     RDCARDRAM
        bcc     LCCDA
        sta     RDMAINRAM
        sta     WRCARDRAM
LCCDA:  lda     ($3C)
        sta     ($42)
        inc     $42
        bne     LCCE4
        inc     $43
LCCE4:  lda     $3C
        cmp     $3E
        lda     $3D
        sbc     $3F
        inc     $3C
        bne     LCCF2
        inc     $3D
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

        ;; bad disasm
        eor     ($55)
        lsr     a:$0D
        jmp     $5349
        .byte   $54
        ora     $FF00


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

LCE3C:  lda     #$00
        bit     RDTEXT
        bmi     LCE45
        lda     #$14

LCE45:  LDXY    SETWND
        bra     LCE6D

LCE4B:  LDXY    SETKBD
        bra     LCE6D

LCE51:  LDXY    SETVID
        bra     LCE6D

LCE57:  LDXY    MON_VTAB
        bra     LCE6D

DoClearEOS:
        LDXY    CLREOP
        bra     LCE6D

DoHomeAndClear:
        LDXY    HOME
        bra     LCE6D

DoClearEOL:
        LDXY    CLREOL

;;; A = character, X,Y = ROM address-1 (return value to push to stack)
LCE6D:  sta     TEMP2
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
        lda     $42
        ldx     $43
        sta     ALTZPON
        sta     $42
        stx     $43
        sta     ALTZPOFF
LCF13:  lda     ($3C)
        sta     ALTZPON
        sta     ($42)
        inc     $42
        bne     LCF20
        inc     $43
LCF20:  sta     ALTZPOFF
        lda     $3C
        cmp     $3E
        lda     $3D
        sbc     $3F
        inc     $3C
        bne     LCF31
        inc     $3D
LCF31:  bcc     LCF13
        bra     LCF67

LCF35:  sta     RDCARDRAM
        sta     WRMAINRAM
        lda     $3C
        ldx     $3D
        sta     ALTZPON
        sta     $3C
        stx     $3D
LCF46:  sta     ALTZPON
        lda     ($3C)
        ldx     $3C
        ldy     $3D
        inc     $3C
        bne     LCF55
        inc     $3D
LCF55:  sta     ALTZPOFF
        sta     ($42)
        inc     $42
        bne     LCF60
        inc     $43
LCF60:  cpx     $3E
        tya
        sbc     $3F
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
        lda     $42
        ldy     $43
        sta     ALTZPON
        sta     $42
        sty     $43
        sta     ALTZPOFF
        ldy     #$00
LCF9B:  lda     ($3C),y
        sta     ALTZPON
        sta     ($42),y
        sta     ALTZPOFF
        iny
        bne     LCF9B
        inc     $3D
        .byte   $8D
LCFAB:  ora     #$C0
        inc     $43
        sta     ALTZPOFF
        dex
        bne     LCF9B
        bra     LCFE4

LCFB7:  sta     RDCARDRAM
        sta     WRMAINRAM
        lda     $3C
        ldy     $3D
        sta     ALTZPON
        sta     $3C
        sty     $3D
        ldy     #$00
LCFCA:  sta     ALTZPON
        lda     ($3C),y
        sta     ALTZPOFF
        sta     ($42),y
        iny
        bne     LCFCA
        inc     $43
        sta     ALTZPON
LCFDC:  .byte   $E6
LCFDD:  and     $088D,x
        cpy     #$CA
        bne     LCFCA
LCFE4:  jmp     LCF67

        brk
        brk
        brk
        brk
LCFEB:  brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk
LCFFF:  brk
