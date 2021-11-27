;;; ============================================================
;;; Franklin ACE 2X00 ROM V6.0 Disassembly
;;;
;;; First $1000 bytes of U2 ROM (usually banked in $C000-$CFFF)
;;;
;;; Build with CC65's ca65 assembler
;;; ============================================================

        .setcpu "65C02"
        .include "opcodes.inc"
        .feature string_escapes

;;; ============================================================
;;; Patches

;;; Set to 1 to include fixes for:
;;; * CH not working to set horizontal cursor position.
;;; * MouseText mode failing to exist on $18 output.
;;; * MouseText displaying if $40-$5F sent to COUT.
INCLUDE_PATCHES = 0

;;; ============================================================
;;; Equates

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
CSWL    := $36
CSWH    := $37
KSWL    := $38
KSWH    := $39
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

SAVECV  := $6F8
SAVECH  := $778

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
M_INACTIVE = $FF                ; When firmware is inactive

OURCH   := $57B
OURCV   := $5FB
CHAR    := $67B
XCOORD  := $6FB
TEMP1   := $77B                 ; Unused
OLDBASL := $77B
TEMP2   := $7FB
OLDBASH := $7FB

FKEYPTR := $479                 ; Holds offset from Aux $200 to FKEY def

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
LINEFEED:= $FC66
CLREOL  := $FC9C
CANCEL  := $FD62
MON_INPRT := $FE8D
REGZ    := $FEBF
USR     := $FECA

;;; Franklin ACE 2X00-specific softswitches

BankU1In        := $C079        ; Map U1 into $A000-$BFFF
BankU1Out       := $C078        ; Map U1 out, and RAM back in to $A000-$BFFF

;;; ============================================================
;;; U2 $0000 - Mapped to Page $C1 - Parallel Port Firmware
;;; ============================================================

        .org    $C100

.scope offset00_pageC1

        bra     @l5
        bra     @l1
        nop
        pha
        pla
@l1:    pha
        pla
        clc
        clv
@l2:    pha
        phx
        phy
        sta     $0679
        sta     CLRROM
        sta     BankU1In
        bvc     @l3
        ldx     #<@l1
        stx     $36
        ldx     #>@l1
        stx     $37
        jsr     $B000           ; Entry point in U1
@l3:    jsr     $B02C           ; Entry point in U1
        sta     BankU1Out
        ply
        plx
        pla
@l4:    rts

@l5:    bit     @l4
        bra     @l2

        .res    $C1D0 - *, 0

        .byte   $ff, $ff, $00, $00, $ff, $ff, $00, $00
        .byte   $ff, $ff, $00, $00, $ff, $ff, $00, $00
        .byte   $ff, $ff, $00, $00, $ff, $ff, $00, $00
        .byte   $ff, $ff, $00, $00, $ff, $ff, $00, $00
        .byte   $ff, $ff, $00, $00, $ff, $ff, $00, $00
        .byte   $ff, $ff, $00, $00, $ff, $ff, $00, $00
.endscope

;;; ============================================================
;;; U2 $0100 - Mapped to ??? - ???
;;; ============================================================

        .org    $0100

.scope offset01
@l1:    lda     $24
        pha
        lda     $22
        sta     $25
        stz     $24
        jsr     MON_VTAB
@l2:    jsr     $FA37           ; ???
        ldy     $29
        sty     $2B
        ldy     $28
        sty     $2A
        lda     $23
        beq     @l7
        dec     a
        cmp     $25
        beq     @l7
        bcc     @l7
        inc     $25
        jsr     MON_VTAB
        ldy     $21
        dey
        bit     RD80VID
@l3:    bmi     @l5
@l4:    lda     ($28),y
        sta     ($2A),y
        dey
        bpl     @l4
        bra     @l2
@l5:    tya
        lsr     a
        tay
@l6:    bit     TXTPAGE1
        lda     ($28),y
        sta     ($2A),y
        bit     TXTPAGE2
        lda     ($28),y
        sta     ($2A),y
        dey
        bpl     @l6
        bit     TXTPAGE1
        bra     @l2
@l7:    stz     $24
        jsr     CLREOL
        plx
        stx     $24
        jmp     MON_VTAB
.endscope

;;; ============================================================
;;; U2 $0200 - Empty
;;; ============================================================

        .res $0300 - *, 0

;;; ============================================================
;;; U2 $0300 - Mapped to Page $C3 - Enhanced 80 Column Firmware
;;; ============================================================

        .org $C300

        ;; Init
LC300:  bit     SETV            ; V = init
        bra     MainEntry

        ;; Input
        .assert * = C3KeyIn, error, "Entry point mismatch"
LC305:  sec
        .byte   OPC_BCC         ; never taken; skip next byte

        ;; Output
        .assert * = C3COut1, error, "Entry point mismatch"
LC307:  clc
        clv
        bra     MainEntry

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

MainEntry:
        sta     CLRROM
        sta     SAVEA
        stx     SAVEX
        sty     SAVEY
        pha
        bvc     l1

        ;; Init firmware
        lda     #<LC305
        sta     KSWL
        ldx     #>LC305
        stx     KSWH
        lda     #<LC307
        sta     CSWL
        stx     CSWH
        jsr     LC800
        clc

l1:     php
        bit     RD80VID
        bpl     l2
        lsr     WNDWDTH
        asl     WNDWDTH
        sta     SET80COL

        ;; NOTE: In ACE 500 ROM, the below is patched to
        ;; address the CH/OURCH issue.
.if !INCLUDE_PATCHES
        lda     OURCH
.else
        jsr     Patch1
.endif
        sta     CH

l2:     plp
        pla
        bcs     l3              ; input or output?

        ;; Output
        jsr     OutputChar
        bra     l9

        ;; Input
l3:     ldx     SAVEX
        beq     l4
        dex
        lda     $0678
        cmp     #$88            ; left?
        beq     l4
        cmp     $0200,x
        bne     l7
        sta     $0200,x
l4:     jsr     LC877
        cmp     #$9B            ; escape?
        beq     EscapeMode
        cmp     #$8D            ; return?
        bne     l5
        pha
        jsr     DoClearEOL
        pla
l5:     cmp     #$95            ; right?
        bne     l6
        jsr     LCEBE
        ora     #$80
        cmp     #$A0            ; non-control char
        bcs     l6
        ora     #$40
l6:     sta     $0678
        bra     l8

l7:     jsr     LC850
        stz     $0678
l8:     bra     l10

l9:     lda     SAVEA
l10:    ldx     SAVEX
        ldy     CH
.if !INCLUDE_PATCHES
        sty     OURCH
.else
        jsr     Patch2
.endif
        ldy     SAVEY
SETV:   rts                     ; has V flag set

;;; ============================================================
;;; Escape Mode

EscapeMode:
        lda     #M_ESC
        tsb     MODE
        jsr     LC850
        jsr     ProcessEscapeModeKey
        cmp     #$98            ; ctrl-x (clear)
        beq     l6
        lda     MODE            ; still in escape mode?
        bmi     EscapeMode
        bra     l4

;;; ============================================================

        .assert * = $C3DC, error, "Potential entry point moved"
        ;; ???
        bit     CLRROM
        jmp     UnknownEP1

;;; ============================================================

        brk
        brk
        brk
        brk
        brk
        brk

;;; ============================================================
;;; Entry points called by Monitor ROM

        .assert * = $C3E8, error, "Entry point moved"

        ;; Called by U3 ROM ($F37A)
        bit     CLRROM
        jmp     UnknownEP2

        ;; Called by U3 ROM ($F809)
        bit     CLRROM
        jmp     InitFKEYDefinitions

        ;; Called by U3 ROM ($F9B7)
        bit     CLRROM
        jmp     UnknownEP4

        ;; Called by U3 ROM ($FA9E)
        bit     CLRROM
        jmp     HandleSpecialKeys

;;; ==================================================
;;; U2 $0400 - Mapped to Page $C4 - ???
;;; ==================================================

        .assert * = $C400, error, "Mismatch"
.scope
LF813           := $F813        ; Not an Apple II entry point
LF981           := $F981        ; Not an Apple II entry point
LFA37           := $FA37        ; Not an Apple II entry point
LFA52           := $FA52        ; Not an Apple II entry point
LFC45           := $FC45        ; Not an Apple II entry point
LFEEB           := $FEEB        ; Not an Apple II entry point

        ;; Called from $F88C
LC400:
        ldx     #$00
        eor     #$20
        beq     @l1
        and     #$9F
        beq     @l3
        asl     a
        eor     #$12
        beq     @l2
        and     #$1A
        eor     #$02
        beq     @l3
        and     #$10
        bne     @l2
@l1:    inx
@l2:    inx
@l3:    stx     $2F
        jmp     LF813

;;; ============================================================

        ;; Called from $F8C5
LC420:
        lda     KBD
        eor     #$93
        bne     @l2
        lda     KBDSTRB
@l1:    jsr     LFA37
        lda     KBD
        bpl     @l1
        eor     #$83
        beq     @l2
        sta     KBDSTRB
@l2:    jmp     LF813

;;; ============================================================

        ;; Called from $F957
LC43:
        lda     $2E
        eor     #$FF
        and     ($26),y
        sta     ($26),y
        lda     $2E
        and     $30
        ora     ($26),y
        sta     ($26),y
        jmp     LF813

;;; ============================================================

        ;; Called from $FE4B
LC44F:
        ldx     #$3C
        jsr     LFC45
        beq     @l1
        jsr     @l2
        jsr     LFA52
        ldx     #$42
        jsr     LFA52
        bra     LC44F

@l1:    jsr     @l2
        jmp     LF813

@l2:    lda     ($00,x)
        sta     ($06,x)
        rts

;;; ============================================================

        ;; Called from $FEAA
LC46E:
        and     #$0F
        asl     a
        tax
        lda     @l1,x
        pha
        lda     @l1+1,x
        tax
        pla
        jmp     LF813

        ;; Jump Table (target address-1 ???)
@l1:
        .addr   $FDF0
        .addr   $C100
        .addr   $C200
        .addr   $C300
        .addr   $C400
        .addr   $C500
        .addr   $C600
        .addr   $C700
        .addr   $FD1B

;;; ============================================================

        ;; Called from $FFA7
LC490:
        lda     #$00
        stz     A2L
        stz     A2H
        stz     $2C

@l1:    ora     A2L
        sta     A2L
        lda     $0200,y
        iny
        jsr     LFEEB
        bmi     @l4
        dec     $2C
        ldx     #$04
@l2:    asl     A2L

@l3:    rol     A2H
        dex
        bne     @l2
        bra     @l1

@l4:    jmp     LF813

;;; ============================================================

        ;; Called from $F847
lC4B5:
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
LC4CE:  .byte   $0F, $F0

;;; ============================================================

        ;; Called from $F854
LC4D0:
        phx
        and     #$0F
        tax
        lda     @table,x
        sta     $30
        plx
        jmp     LF813

@table:
        .byte   $00, $11, $22, $33, $44, $55, $66, $77
        .byte   $88, $99, $AA, $BB, $CC, $DD, $EE, $FF

;;; ============================================================

        ;; Called from $FC00
LC4ED:
        tya
@l1:    ldy     $C4FD,x
        beq     @l2
        cmp     $C000,y
        inx
        bra     @l1
@l2:    tay
        jmp     LF813

        ;; Display mode softswitch table
@swtable:

        .byte   $52, $54, $56, $00 ; Full-screen, Page1, LoRes
        .byte   $56, $50, $53, $00 ; LoRes, Graphics, Split-screen

        ;; Dispatch table for RTS dispatch?

.macro TABLE_ENTRY char, addr
        .byte   char, .lobyte(addr-1), .hibyte(addr-1)
.endmacro

@table:
        TABLE_ENTRY $9b, $FA1D  ; ^[ aka <ESC>
        TABLE_ENTRY $88, $FA0A  ; ^H aka <-
        TABLE_ENTRY $98, CANCEL ; ^X
        TABLE_ENTRY $95, $FA22  ; ^U aka ->
        TABLE_ENTRY $8d, $FA17  ; ^M aka <RETURN>
        .byte   $00
        TABLE_ENTRY $8d, $FC3B  ; ^M aka <RETURN>
        TABLE_ENTRY $8a, LINEFEED ; ^J aka “down”
        TABLE_ENTRY $87, BELLB  ; ^G aka BELL
        TABLE_ENTRY $88, $FA43  ; ^H aka <-
        .byte   $00
        TABLE_ENTRY $49, $FCF6  ; I
        TABLE_ENTRY $4a, $FA5C  ; J
        TABLE_ENTRY $4b, $FBF6  ; K
        TABLE_ENTRY $4d, $FCBD  ; M
        .byte   $00
        TABLE_ENTRY $8d, REGZ   ; ^M aka <RETURN>
        TABLE_ENTRY $a0, USR    ; Space
        TABLE_ENTRY $ae, $FDAB  ; .
        TABLE_ENTRY $ba, $FD48  ; :
        TABLE_ENTRY $bc, $FE13  ; <
        TABLE_ENTRY $c7, $F881  ; G
        TABLE_ENTRY $ce, MON_INPRT ; N
        TABLE_ENTRY $82, $E000  ; ^B
        TABLE_ENTRY $83, $E003  ; ^C
        TABLE_ENTRY $99, $03F8  ; ^Y
        TABLE_ENTRY $90, $FD26  ; ^P
.endscope

;;; ============================================================

        .res    $C800 - *, 0

;;; ============================================================
;;; U2 $0800 - Pages $C8-$CF - Enhanced 80 Column Firmware
;;; ============================================================

LC800:  lda     #M_NORMAL
        sta     MODE
        jsr     Enable80Col
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
        jsr     Disable80Col
        jsr     SaveCHCV
        jsr     DoSETWND
        plp
        bpl     rts1
        jmp     LCC4E

;;; ============================================================

.if !INCLUDE_PATCHES
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
.else
Patch4:
        lda     CHAR            ; char to be printed
        bit     INVFLG
        bmi     :+              ; normal
        and     #$7F            ; clear high bit
:       and     #$FF            ; set N flag
        rts
.endif

;;; ============================================================

        .res    $C84D - *, 0

;;; ============================================================

        ;; ???
        jsr     InitTextWindow
LC850:  jsr     LCBC7
LC853:  inc     RNDL
        bne     :+
        inc     RNDH
:
        jsr     UnknownEP4
        bcc     LC853
        jsr     HandleSpecialKeys
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

;;; ============================================================

LC877:  jsr     LC850
        cmp     #$00
        beq     @l4
        cmp     #$02
        beq     LC80E
        cmp     #$05
        bne     rts2
        ldy     CH
@l1:    iny
        cpy     WNDWDTH
        beq     @l2
        jsr     LCEC0
        dey
        jsr     LCECB
        iny
        bra     @l1

@l2:    dey
@l3:    lda     #$A0
        jsr     LCECB
        bra     LC877

@l4:    ldy     WNDWDTH
        dey
@l5:    cpy     CH
        beq     @l3
        dey
        jsr     LCEC0
        iny
        jsr     LCECB
        dey
        bra     @l5

;;; ============================================================

OutputChar:
        sta     CHAR
LC8B4:  jsr     CheckPauseListing
        lda     MODE
        and     #$03            ; test low 2 bits (why???)
        beq     @l1
        jmp     LCA11

@l1:    lda     CHAR
        and     #$7F
        cmp     #$20
        bcc     DoCtrlCharOut
        ldy     CH
        cpy     WNDWDTH
        bcc     @l2
        jsr     DoReturn

        ;; If MouseText is not active, make sure to map inverse
        ;; uppercase range to the control character range.

@l2:
.if !INCLUDE_PATCHES
        lda     CHAR            ; char to be printed
        bit     INVFLG          ; inverse?
.else
        jsr     Patch4          ; sets N flag if inverse char
        nop
        nop
.endif
        bmi     @l3             ; no, so not MT, just print it

        and     #$7F

        bit     MODE            ; MT active? (bit 6 = M_MOUSE)
        bvs     @l3             ; yes, so skip correction

        bit     ALTCHARSET      ; also skip correction if
        bpl     @l3             ; alt charset is disabled

        ;; If within "@ABC...XYZ[\]^_" range, map to $00-$1F
        ;; so it shows as inverse uppercase, not MouseText.
        cmp     #'@'
        bcc     :+
        cmp     #'_'+1
        bcs     :+
        and     #$1F
:

@l3:    jsr     LCBF9
        jmp     DoForwardSpace

;;; ============================================================

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
        jmp     (@jt,x)

@jt:
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
        .addr   DoCtrlCaret     ; $1E Ctrl-^ ???
        .addr   DoUp            ; $1F Ctrl-_ Up

;;; ============================================================
;;; For Escape key sequences

ProcessEscapeModeKey:
        pha
        lda     #M_ESC
        trb     MODE
        pla
        and     #$7F
        cmp     #'a'
        bcc     @l1
        cmp     #'z'+1
        bcs     @l1
        and     #$DF            ; convert to uppercase

        ;; Scan table for match
@l1:    ldx     #$00
@l2:    ldy     @code_table,x
        beq     DoNothing
        cmp     @code_table,x
        beq     @l3
        inx
        bra     @l2

@l3:    txa
        asl     a
        tax
        jmp     (@jt,x)

@code_table:
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

@jt:
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

CheckPauseListing:
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
        ;; fall through

Remain: lda     #M_ESC          ; stay in Escape Mode
        jmp     SetModeBits

;;; ============================================================

DoInverse:
        ldy     #$3F
        bra     LC9CA

DoNormal:
        ldy     #$FF
LC9CA:  sty     INVFLG
rts4:   rts

;;; ============================================================

Do80Col:
        bit     RD80VID
        php
        jsr     Enable80Col
        jsr     SaveCHCV
        jsr     DoSETWND
        plp
        bmi     rts4
        jmp     LCBFE

;;; ============================================================

DoQuit:
        jsr     Do40Col
        jsr     DoSETVID
        jsr     DoSETKBD
        lda     #23
        ldx     #0
        jsr     SetCHCV

        lda     #M_INACTIVE
        sta     MODE            ; set all mode bits (???)

        lda     #$98            ; Ctrl-X ???
        rts

;;; ============================================================
;;; Adusting MODE Bits

DoCtrlCaret:
        lda     #$FC            ; clear mode bits %xxxxxx00
        jsr     PreserveModeBits
        lda     #$32            ; set mode bits   %xx11xx1x
        bra     SetModeBits

DoDisableMouseText:
.if !INCLUDE_PATCHES
        lda     #M_MOUSE            ; BUG! Should be ~M_MOUSE
.else
        lda     #.lobyte(~M_MOUSE)
.endif

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
        bne     @l2
        pla
        cmp     #$18            ; +$20 is $38 = '8' ???
        bcs     @l1
        jsr     SetCV
@l1:    lda     $05F8
        cmp     WNDWDTH
        bcs     :+
        sta     CH
:       rts

@l2:    pla
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
        bra     JumpMON_VTAB

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
        bra     JumpMON_VTAB

;;; ============================================================

DoHome:
        lda     WNDTOP
        ldx     #$00
        bra     SetCHCV

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

RestoreCHCV:
        lda     SAVECV
        ldx     SAVECH

SetCHCV:
        stx     CH
SetCV:
        sta     CV
JumpMON_VTAB:
        jmp     DoMON_VTAB

;;; ============================================================

DoScrollUp:
        lda     CH
        pha
        jsr     DoHome
@l1:    ldy     BASH
        sty     BAS2H
        ldy     BASL
        sty     BAS2L
        lda     WNDBTM
        beq     @l5
        dec     a
        cmp     CV
        beq     @l5
        bcc     @l5
        inc     CV
        jsr     JumpMON_VTAB
        ldy     WNDWDTH
        dey
        bit     RD80VID
        bmi     @l3
@l2:    lda     (BASL),y
        sta     (BAS2L),y
        dey
        bpl     @l2
        bra     @l1

@l3:    tya
        lsr     a
        tay
@l4:    bit     TXTPAGE1
        lda     (BASL),y
        sta     (BAS2L),y
        bit     TXTPAGE2
        lda     (BASL),y
        sta     (BAS2L),y
        dey
        bpl     @l4
        bit     TXTPAGE1
        bra     @l1

@l5:    stz     CH
        jsr     DoClearEOL
        plx
        lda     CV
        jmp     SetCHCV

;;; ============================================================

SaveCHCV:
        lda     CV
        sta     SAVECV
        lda     CH
        sta     SAVECH
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
        jsr     SaveCHCV
        lda     WNDBTM
        dec     a
        dec     a
        sta     $05F8
@l1:    lda     $05F8
        jsr     SetCV
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
        lda     $05F8
        inc     a
        jsr     SetCV
        ldy     WNDWDTH
        dey
@l2:    phy
        bit     TXTPAGE1
        bit     RD80VID
        bpl     @l3
        tya
        lsr     a
        tay
        bcs     @l3
        bit     TXTPAGE2
@l3:    lda     (BAS2L),y
        sta     (BASL),y
        ply
        dey
        bpl     @l2
        bit     TXTPAGE1
        lda     $05F8
        cmp     WNDTOP
        beq     @l4
        dec     $05F8
        bra     @l1

@l4:    lda     #$00
        jsr     SetCV
        jsr     DoClearLine
        bit     TXTPAGE1
        jmp     RestoreCHCV

;;; ============================================================

PascalInit:
        jsr     LC800
LCB47:  jsr     LCBC7
LCB4A:  ldx     CH
.if !INCLUDE_PATCHES
        stx     OURCH
.else
        jsr     Patch3
.endif
        ldx     #$00
        rts

;;; ============================================================

PascalRead:
        jsr     InitTextWindow
        jsr     LC850
        lda     CHAR
        bra     LCB4A

;;; ============================================================

PascalWrite:
        sta     CHAR
LCB60:  jsr     InitTextWindow
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
        beq     @l1
        cmp     #$01
        bne     @l2
        jsr     UnknownEP4
        bra     LCB4A

@l1:    sec
        bra     LCB4A

@l2:    ldx     #$03
        clc
        rts

;;; ============================================================

InitTextWindow:
        pha
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
.if !INCLUDE_PATCHES
        lda     OURCH
.else
        jsr     Patch1
.endif
        sta     CH
        pla
        rts

;;; ==================================================

        ;; ???
        sta     CLRALTCHAR
Disable80Col:
        sta     CLR80COL
        sta     CLR80VID
        rts

Enable80Col:
        sta     SET80COL
        sta     SET80VID
        sta     SETALTCHAR
        rts

;;; ============================================================

LCBC7:  lda     MODE            ; all mode bits set?
        cmp     #M_INACTIVE
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

        ;; If within "@ABC...XYZ[\]^_" range, map to $00-$1F
        ;; so it shows as inverse uppercase, not MouseText.
        cmp     #'@'
        bcc     :+
        cmp     #'_'+1
        bcs     :+
        and     #$1F
:

LCBF9:  ldy     CH
        jmp     LCECB

LCBFE:  php
        sei
        lda     WNDTOP
        sta     $05F8
LCC05:  lda     $05F8
        jsr     SetCV
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
        jmp     RestoreCHCV

LCC4E:  php
        sei
        sta     SET80COL
        lda     WNDTOP
        sta     $05F8
LCC58:  lda     $05F8
        jsr     SetCV
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

;;; ============================================================
;;; Unknown Monitor ROM Routine

UnknownEP4:
        bit     $0579
        bmi     @l3
@l1:    bit     KBD
        bmi     @l2
        clc
        rts

@l2:    sec
        rts

@l3:    jsr     LCDB3
        beq     @l5
@l4:    stz     $0579
        bra     @l1

@l5:    phx
        ldx     FKEYPTR
        jsr     ReadAuxRAM
        lda     $0200,x
        jsr     ReadPreviousRAM
        plx
        cmp     #$00
        beq     @l4
        bra     @l2

;;; ============================================================
;;; Handle special keys (F1-12, RUN, LIST, etc)

HandleSpecialKeys:
        bit     $0579
        bmi     @l11
        lda     KBD
        bit     KBDSTRB
        bit     $C027           ; high bit clear for special keys
        bpl     @l3
@l1:    cmp     #$06
        bcc     @l2
        ora     #$80
@l2:    rts

        ;; Deal with special keys
@l3:    and     #$7F
        cmp     #$01            ; CLRL
        bne     @l4
        lda     #$1A
        bra     @l1

@l4:    cmp     #$03            ; CLRS
        bne     @l5
        lda     #$0C
        bra     @l1

@l5:    cmp     #$04            ; HOME
        bne     @l6
        lda     #$19
        bra     @l1

        ;; "Macro" keys
@l6:    cmp     #$06            ; RUN
        bne     @l7
        lda     #$2C            ; Like F13
        bra     @l9

@l7:    cmp     #$1F            ; LIST
        bne     @l8
        lda     #$2D            ; Like F14
        bra     @l9

@l8:    cmp     #$20            ; F1
        bcc     @l1
        cmp     #$2C            ; F12+1
        bcs     @l1

@l9:    pha                     ; Handle Fkeys
        jsr     LCDB3
        beq     @l10
        pla
        bra     @l1

@l10:   lda     #$FF
        sta     $0579
        pla
        jsr     FindFKEYDefnOffset
@l11:   jsr     LCDB3
        beq     @l13
@l12:   stz     $0579
        lda     #$A0
        bra     @l1

@l13:   phx
        ldx     FKEYPTR
        jsr     ReadAuxRAM
        lda     $0200,x
        jsr     ReadPreviousRAM
        plx
        inc     FKEYPTR
        cmp     #$00
        beq     @l12
        bra     @l1

;;; ============================================================

LCDB3:  jsr     ReadAuxRAM
        lda     #$00
        phx
        tax
        clc
@l1:    adc     $0200,x
        inx
        bne     @l1
        plx
        jsr     ReadPreviousRAM
        cmp     $04F9
        rts

;;; ============================================================
;;; Given FKEY in A ($20...$2D), get definition offset
;;; (from Aux $200) into FKEYPTR

FindFKEYDefnOffset:
        phx
        phy
        jsr     ReadAuxRAM
        sec
        sbc     #$20            ; Map F1 to $00, etc
        ldy     #$00
        tax
        beq     @l3
@l1:    lda     $0200,y
        beq     @l2
        iny
        bra     @l1

@l2:    iny
        dex
        bne     @l1
@l3:    jsr     ReadPreviousRAM
        sty     FKEYPTR
        ply
        plx
        rts

;;; ============================================================
;;; Initialize FKEY definitions

;;; Copied to Aux $200 by `InitFKEYDefinitions`
SpecialStrings:
        .byte   "RUN\r", 0
        .byte   "LIST\r", 0
        .byte   $ff

InitFKEYDefinitions:
        sta     WRCARDRAM
        lda     #$00
        tax

        ;; F1...F12 are initially 0 length, so 12 $00 bytes
@l1:    sta     $0200,x
        inx
        cpx     #12
        bcc     @l1

        ;; RUN and LIST are like F13 and F14, so they're next.
@l2:    lda     SpecialStrings - 12,x
        cmp     #$FF
        beq     @l3
        sta     $0200,x
        inx
        bra     @l2

@l3:    sta     WRMAINRAM
        stz     $0579
        ;; fall through

;;; ============================================================
;;; Unknown Monitor ROM Routine

UnknownEP2:
        jsr     LCDB3
        sta     $04F9
        rts

;;; ============================================================

;;; Read from Aux (saving previous state)

ReadAuxRAM:
        pha
        lda     RDRAMRD
        sta     RDMAINRAM
        sta     $07F8
        sta     RDCARDRAM
        pla
        rts

;;; Restore previous read bank state

ReadPreviousRAM:
        pha
        sta     RDMAINRAM
        lda     $07F8
        bpl     @l1
        sta     RDCARDRAM
@l1:    pla
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
        ;; fall through

;;; ============================================================

;;; A = character, X,Y = ROM address-1 (return value to push to stack)
ROMCall:
        sta     TEMP2
        bit     RDLCRAM
        php
        bit     RDLCBNK2
        php
        lda     #.hibyte(ROMCallReturn-1)
        pha
        lda     #.lobyte(ROMCallReturn-1)
        pha
        phx
        phy
        bit     ROMIN2
        lda     TEMP2
        rts

ROMCallReturn:
        plp
        bpl     @l2
        plp
        bpl     @l1
        bit     LCBANK2
        bit     LCBANK2
        bra     @l4

@l1:    bit     ROMIN
        bit     ROMIN
        bra     @l4

@l2:    plp
        bpl     @l3
        bit     LCBANK1
        bit     LCBANK1
        bra     @l4

@l3:    bit     $C089           ; ???
        bit     $C089           ; ???
@l4:    lda     BASL
        sta     OLDBASL
        lda     BASH
        sta     OLDBASH
        lda     CH
        sta     OURCH
        rts

;;; ============================================================

LCEBE:  ldy     CH
LCEC0:  phy
        jsr     LCED5
        lda     (BASL),y
LCEC6:  ply
        bit     TXTPAGE1
        rts

;;; ============================================================

LCECB:
        phy
        pha
        jsr     LCED5
        pla
        sta     (BASL),y
        bra     LCEC6

;;; ============================================================

LCED5:
        bit     RD80VID
        bpl     @l1
        tya
        lsr     a
        tay
        bcc     @l2
@l1:    bit     TXTPAGE1
        rts

@l2:    bit     TXTPAGE2
        rts

;;; ============================================================
;;; ???

UnknownEP1:
        bit     RD80COL
        php
        sta     CLR80COL
        bit     RDRAMRD
        php
        bit     RDRAMWRT
        php
        phx
        plx
        beq     @l1
        jmp     @l13

@l1:    bcc     @l5
        sta     RDMAINRAM
        sta     WRCARDRAM
        lda     A4L
        ldx     A4H
        sta     ALTZPON
        sta     A4L
        stx     A4H
        sta     ALTZPOFF
@l2:    lda     (A1L)
        sta     ALTZPON
        sta     (A4L)
        inc     A4L
        bne     @l3
        inc     A4H
@l3:    sta     ALTZPOFF
        lda     A1L
        cmp     A2L
        lda     A1H
        sbc     A2H
        inc     A1L
        bne     @l4
        inc     A1H
@l4:    bcc     @l2
        bra     @l9

@l5:    sta     RDCARDRAM
        sta     WRMAINRAM
        lda     A1L
        ldx     A1H
        sta     ALTZPON
        sta     A1L
        stx     A1H
@l6:    sta     ALTZPON
        lda     (A1L)
        ldx     A1L
        ldy     A1H
        inc     A1L
        bne     @l7
        inc     A1H
@l7:    sta     ALTZPOFF
        sta     (A4L)
        inc     A4L
        bne     @l8
        inc     A4H
@l8:    cpx     A2L
        tya
        sbc     A2H
        bcc     @l6
@l9:    sta     ALTZPOFF
        sta     WRCARDRAM
        plp
        bmi     @l10
        sta     WRMAINRAM
@l10:   sta     RDCARDRAM
        plp
        bmi     @l11
        sta     RDMAINRAM
@l11:   plp
        bpl     @l12
        sta     SET80COL
@l12:   rts

@l13:   bcc     @l14
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
        bra     @l15

@l14:   sta     RDCARDRAM
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
@l15:   jmp     @l9

;;; ============================================================

        .assert * = $CFE7, error, "Something changed size"

;;; ============================================================

.if INCLUDE_PATCHES

Patch1:
        lda     CH
        cmp     XCOORD
        bne     :+
        lda     OURCH
:       rts

Patch2:
        sty     OURCH
        sty     XCOORD
        rts

Patch3:
        stx     OURCH
        stx     XCOORD
        rts

.endif

;;; ============================================================

        .res    $D000 - *, 0

;;; ============================================================

        .assert * = $D000, error, "Length changed"
