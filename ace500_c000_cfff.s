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

;;; Set to 1 to include preliminary fixes for:
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
L03F0   := $3F0                 ; ???
L03FE   := $3FE                 ; ???

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
RDCXROM := $C015
RDALTZP := $C016
RDC3ROM := $C017
RD80COL := $C018
RDVBL   := $C019
RDTEXT  := $C01A
RDPAGE2 := $C01C
ALTCHARSET := $C01E
RD80VID := $C01F
TXTPAGE1:= $C054
TXTPAGE2:= $C055
RD63    := $C063
PTRIG   := $C070
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
VTABZ   := $FC24
CLREOP  := $FC42
HOME    := $FC58
CLREOL  := $FC9C
CLREOLZ := $FC9E
COUT    := $FDED
COUT1   := $FDF0
MON_SAVE:= $FF4A

;;; ============================================================

        .org    $C000

;;; ============================================================
;;; Page $C0 - Unused (garbage data?)
;;; ============================================================

        .res    $100, 0

;;; ============================================================
;;; Page $C1 - Parallel Port Firmware
;;; ============================================================

.scope pageC1

LC100:  bra     LC111
LC102:  bra     LC107

LC104:  nop
        sec                     ; $Cn05 = $38 Pascal 1.1 sig
        nop
LC107:  clc                     ; $Cn07 = $18 Pascal 1.1 sig
        clv
        bra     LC114

        ;; Signature bytes
        .byte   $01             ; Pascal 1.1 signature
        .byte   $31             ; $31 = Super Serial Card (!)

        ;; Pascal 1.1 Firmware Protocol Table
        .byte   .lobyte(LC12B)
        .byte   .lobyte(LC133)
        .byte   .lobyte(LC136)
        .byte   .lobyte(LC13E)

LC111:  bit     LC135
LC114:  jsr     LC1D6
        pha
        phx
        phy
        sta     $0679
        bvc     LC122
        jsr     $C806
LC122:  jsr     $C83C
        ply
        plx
        pla
LC128:  jmp     $C5FA

LC12B:  jsr     LC1D6
        jsr     $C897
        bra     LC128

LC133:  ldx     #$03
LC135:  rts

LC136:  jsr     LC1D6
        jsr     $C89D
        bra     LC128

LC13E:  jsr     LC1D6
        jsr     $C8A5
        bra     LC128
LC146:  lda     #$00
        bit     RDALTZP
        bpl     LC14F
        ora     #$80
LC14F:  bit     RDRAMRD
        bpl     LC156
        ora     #$40
LC156:  bit     RDRAMWRT
        bpl     LC15D
        ora     #$20
LC15D:  bit     RDLCBNK2
        bpl     LC164
        ora     #$10
LC164:  bit     RDLCRAM
        bpl     LC16B
        ora     #$08
LC16B:  bit     RD80COL
        bpl     LC177
        bit     RDPAGE2
        bpl     LC177
        ora     #$04
LC177:  rts

LC178:  phx
        asl     a
        asl     a
        bcc     LC180
        sta     RDCARDRAM
LC180:  asl     a
        bcc     LC186
        sta     WRCARDRAM
LC186:  asl     a
        bcc     LC193
        asl     a
        bcc     LC18F
        ldx     #$03
        .byte   $2C
LC18F:  ldx     #$01
        bra     LC19B
LC193:  asl     a
        bcc     LC199
        ldx     #$0B
        .byte   $2C
LC199:  ldx     #$09
LC19B:  bit     $C080,x
        bit     $C080,x
        asl     a
        bcc     LC1A7
        sta     TXTPAGE2
LC1A7:  plx
        rts

LC1A9:  bit     #$04
        beq     LC1B0
        sta     TXTPAGE1
LC1B0:  sta     RDMAINRAM
        sta     WRMAINRAM
        bit     ROMIN
        rts

        brk
        brk
        brk
        brk
        brk
        brk
        brk
LC1C1:  brk
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
        jsr     LC128
        jsr     COUT1
LC1D6:  php
        sei
        pha
        lda     #$C1
        sta     $07F8
        sta     $C0BA
        sta     $C0B8
        sta     CLRROM
        pla
        plp
        rts

        brk
        brk
        brk
        brk
        brk
        brk
        brk
        brk

LC1F2:  plx
        bit     CLRROM
        rti

LC1F7:  jmp     LC146

LC1FA:  jmp     LC178

LC1FD:  jmp     LC1A9
.endscope

;;; ============================================================
;;; Page $C2 - Serial Port Firmware
;;; ============================================================

.scope pageC2
        bit     $C5A7
        bra     LC211

        sec                     ; $Cn05 = $38 Pascal 1.1 sig
        .byte   OPC_BCC         ; never taken

        clc                     ; $Cn07 = $18 Pascal 1.1 sig
        clv
        bra     LC211

        ;; Signature bytes
        .byte   $01             ; Pascal 1.1 signature
        .byte   $31             ; $31 = Super Serial Card

        ;; Pascal 1.1 Firmware Protocol Table
        .byte   .lobyte(LC214)
        .byte   .lobyte(LC217)
        .byte   .lobyte(LC21A)
        .byte   .lobyte(LC21D)

LC211:  jmp     $C500

LC214:  jmp     $C51F

LC217:  jmp     $C528

LC21A:  jmp     $C530

LC21D:  jmp     $C538

        ;; ???
LC220:  lda     $077C
        and     #$F1
        sta     $077C
        sec
        lda     RDVBL
        bmi     @l2
        sta     PTRIG
        lda     #$08
        tsb     $077C
        clc
        bit     $067C
        bpl     @l1
        lda     #$20
        tsb     $077C
        lda     $07FC
        and     #$02
        beq     @l1
        tsb     $077C
        stz     $067C
@l1:    bit     RD63
        bmi     @l2
        lda     #$04
        tsb     $077C
@l2:    lda     RDCXROM
        ora     RDC3ROM
        bmi     @l3
        jmp     @l12

@l3:    sta     $067C
        lda     RDCXROM
        sta     $C048           ; ???
        bpl     @l7
        txa
        bpl     @l5
        lda     $067D
        cmp     $047C
        bne     @l4
        lda     $077D
        cmp     $057C
        beq     @l11
@l4:    inc     $047C
        bne     @l11
        inc     $057C
        bra     @l11
@l5:    lda     $047D
        cmp     $047C
        bne     @l6
        lda     $057D
        cmp     $057C
        beq     @l11
@l6:    sec
        lda     $047C
        sbc     #$01
        sta     $047C
        lda     $057C
        sbc     #$00
        sta     $057C
        bra     @l11
@l7:    tya
        bmi     @l9
        lda     $06FD
        cmp     $04FC
        bne     @l8
        lda     $07FD
        cmp     $05FC
        beq     @l11
@l8:    inc     $04FC
        bne     @l11
        inc     $05FC
        bra     @l11
@l9:    lda     $04FD
        cmp     $04FC
        bne     @l10
        lda     $05FD
        cmp     $05FC
        beq     @l11
@l10:   sec
        lda     $04FC
        sbc     #$01
        sta     $04FC
        lda     $05FC
        sbc     #$00
        sta     $05FC
@l11:   clc
@l12:   bcs     @l13
        lda     $077C
        and     $07FC
        beq     @l13
        sec
@l13:   rts

        ;; ???

        ldx     $EB
        lda     $0342,x
        .byte   $8D
        .byte   $12
.endscope

;;; ============================================================
;;; Page $C3 - Enhanced 80 Column Firmware
;;; ============================================================

        ;; Init
LC300:  bit     SETV            ; V = init
        bra     MainEntry

        ;; Input
        .assert * = C3KeyIn, error, "Entry point mismatch"
LC305:  sec                     ; $Cn05 = $38 Pascal 1.1 sig
        .byte   OPC_BCC         ; never taken; skip next byte

        ;; Output
        .assert * = C3COut1, error, "Entry point mismatch"
LC307:  clc                     ; $Cn07 = $18 Pascal 1.1 sig
        clv
        bra     MainEntry

        ;; Signature bytes
        .byte   $01             ; Pascal 1.1 signature
        .byte   $88             ; $88 = 80 Column Card

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
        jsr     pageC5_DoBankC5
        jmp     $CC03           ; ???

;;; ============================================================
;;; Pascal Entry Points


JPINIT: jsr     ClearROM
        jsr     PascalInit
LC320:  jmp     pageC5_DoBankC5

JPREAD: jsr     ClearROM
        jsr     PascalRead
        bra     LC320

JPWRITE:jsr     ClearROM
        jsr     PascalWrite
        bra     LC320

JPSTAT: jsr     ClearROM
        jsr     PascalStatus
        bra     LC320

JumpAuxMove:
        jsr     pageC5_DoBankC5
        jmp     $CC06

;;; ============================================================
;;; Main Entry Points

MainEntry:
        jsr     ClearROM
        sta     SAVEA
        stx     SAVEX
        sty     SAVEY
        pha
        bvc     l1

        ;; Init
        jsr     LC806
        clc

l1:     php
        jsr     LC9B4
        plp
        pla
        bcc     l7              ; Input or output?

        ;; Input
        ldx     SAVEX
        beq     l2
        dex
        lda     $0678
        cmp     #$88            ; left?
        beq     l2
        cmp     $0200,x
        bne     l5
        sta     $0200,x

l2:     jsr     LC96F
        cmp     #$9B            ; escape?
        beq     EscapeMode
        cmp     #$8D            ; return?
        bne     l3
        pha
        jsr     DoClearEOL
        pla
l3:     cmp     #$95            ; right?
        bne     l4
        ldy     CH
        jsr     LC9A8
l4:     sta     $0678
        bra     l6
l5:     jsr     LC822
        stz     $0678
l6:     bra     l8

        ;; Output
l7:     jsr     OutputChar
        lda     SAVEA

l8:     ldx     SAVEX
        ldy     CH
        sty     OURCH
        sty     XCOORD
        ldy     SAVEY
        jmp     pageC5_DoBankC5

;;; ============================================================
;;; Escape Mode

EscapeMode:
        lda     #M_ESC
        tsb     MODE
        jsr     LC822
        jsr     ProcessEscapeModeKey
        cmp     #$98
        beq     l4
        lda     MODE
        bmi     EscapeMode
        bra     l2

;;; ============================================================

ClearROM:
        php
        sei
        pha
        sta     $C0BA           ; ???
        sta     CLRROM
        lda     #$C3
        sta     $07F8
        pla
        plp
SETV:   rts

;;; ============================================================

        brk
        brk
        brk
        brk
        brk
        brk
        brk
        jsr     pageC5_DoBankC5
        jmp     $CC00

LC3E2:  plx
        bit     CLRROM
        rti

        brk
        jsr     ClearROM
        jmp     LCE0D

        jsr     ClearROM
        jmp     InitFKEYDefinitions

LC3F4:  jsr     ClearROM
        jmp     LCCB2

LC3FA:  jsr     ClearROM
        jmp     LCCF5

;;; ============================================================
;;; Page $C4 - Mouse Card Firmware
;;; ============================================================

.scope pageC4

        bit     SETV
        bra     Init

        sec
        .byte   OPC_BCC         ; never taken; skip next byte

        clc
        clv
        bra     Init

        ;; Signature bytes
        .byte   $01, $20        ; $20 = Mouse

        ;; Pascal 1.1 Firmware Protocol Table
        .byte   .lobyte(PascalEP)
        .byte   .lobyte(PascalEP)
        .byte   .lobyte(PascalEP)
        .byte   .lobyte(PascalEP)

        .byte   $00             ; "optional routines follow"

        ;; Mouse routine entry points
        .byte   .lobyte(SetMouse)
        .byte   .lobyte(ServeMouse)
        .byte   .lobyte(ReadMouse)
        .byte   .lobyte(ClearMouse)
        .byte   .lobyte(PosMouse)
        .byte   .lobyte(ClampMouse)
        .byte   .lobyte(HomeMouse)
        .byte   .lobyte(InitMouse)

        ;; ???
        .byte   .lobyte(PascalEP)
        .byte   .lobyte(LC45F)

Init:   jsr     pageC5_DoBankC5
        bvc     @l1
        jsr     $C806
@l1:    bcc     @l2
        jmp     $C838

@l2:    jmp     LC825

PascalEP:
        ldx     #$03
SETV:   rts

SetMouse:
        jsr     pageC5_DoBankC5
        jmp     $C8D4

ServeMouse:
        jsr     pageC5_DoBankC5
        jmp     $C916

ReadMouse:
        jsr     pageC5_DoBankC5
        jmp     $C922

ClearMouse:
        jsr     pageC5_DoBankC5
        jmp     $C958

PosMouse:
        jsr     pageC5_DoBankC5
        jmp     $C967

ClampMouse:
        jsr     pageC5_DoBankC5
        jmp     $C969

HomeMouse:
        jsr     pageC5_DoBankC5
        jmp     $C93E

InitMouse:
        jsr     pageC5_DoBankC5
        jmp     $C8AC

LC45F:  ldx     $C066           ; ???
        ldy     $C067
        jmp     $C220

LC468:  jsr     pageC5_DoBankC5
        jmp     $C9A0

        .res    $C4A0 - *, 0

        ;; ???
LC4A0:  cld
        phx
        phy
        pha
        ldx     $C066
        ldy     $C067
        lda     $C0BC
        pha
        sta     $C0B9
        jmp     LC700

        ;; ???
        pla
        bpl     LC4BE
        sta     ALTZPON
        ldx     $0101
        txs
LC4BE:  ldx     $07FF
        pla
        jsr     $C1FA
        pla
        bmi     LC4CB
        sta     $C0B8
LC4CB:  sta     $C0BA
        stx     $07F8
        pla
        ply
        cpx     #$C1
        beq     LC4E4
        cpx     #$C3
        beq     LC4E7
        cpx     #$C5
        beq     LC4EA
        plx
        sta     $C0BB
        rti

LC4E4:  jmp     $C1F2

LC4E7:  jmp     LC3E2

LC4EA:  jmp     pageC5_LC5F5

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

LC4F8:  jmp     LC468


        .byte   $D6             ; $CnFB = $D6 mouse signature
        .byte   $00

        jmp     InitMouse
.endscope

;;; ============================================================
;;; Page $C5
;;; ============================================================

.scope pageC5

LC500:  jsr     BankC5
        sta     $067A
        phx
        phy
        pha
        bvc     LC50E
        jsr     $C806
LC50E:  bcc     LC516
        jsr     $C908
        plx
        bra     LC51A
LC516:  jsr     $C83B
        pla
LC51A:  ply
        plx
        jmp     BankC8

        jsr     BankC5
        jsr     $C8C7
        jmp     BankC8

        jsr     BankC5
        jsr     $C8CD
        bra     BankC8

        jsr     BankC5
        jsr     $C8D2
        bra     BankC8

        jsr     BankC5
        jsr     $C8DA
        bra     BankC8

        jsr     BankC8
        ora     #$80
        jsr     COUT1
        bra     BankC5

        jsr     BankC8
        ora     #$80
        jsr     COUT
        bra     BankC5

        jsr     BankC8
        jsr     LC3F4
        bra     BankC5

        jsr     BankC8
        jsr     LC3FA
        and     #$7F
        bra     BankC5

        jsr     BankC8
        jsr     CLREOLZ
        bra     BankC5

        jsr     BankC8
        jsr     HOME
        bra     BankC5

        jsr     BankC8
        jsr     LC300
        bra     BankC5

        jsr     BankC8
        jsr     pageC4::LC4F8
        bra     BankC5

        jsr     BankC8
        jsr     pageC7_LC7FD
        bra     BankC5

        jsr     BankC8
        jsr     VTABZ
        ;; Fall through

;;; ============================================================

;;; Hypothesis: This banks in a special "C5" C800-CFFF

BankC5: php
        sei
        pha
        lda     #$C5
        sta     $07F8
        sta     $C0BA
        sta     $C0B8
        sta     CLRROM
        pla
        plp
        rts

;;; ============================================================

;;; Hypothesis: This banks in a special "C8" C800-CFFF

BankC8: php
        sei
        pha
        lda     #$C8
        sta     $07F8
        sta     $C0BB
        sta     $C0B9
        pla
        plp
        rts

;;; ============================================================

        jsr     BankC8
LC5BC:  bit     $C1C1
        bmi     LC5BC
        sta     $C090
        bra     BankC5

LC5C6:  jsr     BankC5
        jsr     $C9A5
        bra     BankC8

        .res    $C5F5 - *, 0

LC5F5:  plx
        bit     CLRROM
        rti

;;; ============================================================

DoBankC5:
        jmp     BankC8

;;; ============================================================

        jmp     LC5C6
.endscope
pageC5_DoBankC5 := pageC5::DoBankC5
pageC5_LC5F5 := pageC5::LC5F5

;;; ============================================================
;;; Page $C6 - Disk II Firmware
;;; ============================================================

.scope pageC6
        bit     $20             ; $Cn01 = $20 ProDOS device sig
        cpy     $00             ; $Cn03 = $00 ProDOS device sig
        ldx     #$03            ; $Cn05 = $03 ProDOS device sig

        asl     A1L
        jsr     pageC5::DoBankC5
        ldy     #$69
LC60D:  lda     $CF26,y
        sta     $036C,y
        dey
        bpl     LC60D
        ldx     #$60
LC618:  inc     BAS2H
        cpx     BAS2H
        bne     LC618
        jsr     $CEA6
LC621:  dec     $41
        bne     LC621
LC625:  dec     A1H
        bne     LC625
LC629:  dec     $26
        bne     LC629
LC62D:  dec     $27
        lda     $27
        cmp     #$08
        bne     LC62D

        .res    $C65C - *, ::OPC_NOP

        pha

        nop
        nop
        nop
        nop
        nop
        nop

        bra     LC683

        .res    $C683 - *, ::OPC_NOP

LC683:  pla
LC684:  jsr     pageC5::DoBankC5
        jsr     $CE00
        bra     LC6EA


        .res    $C6A6 - *, 0

        ldy     #$56            ; ???
        sty     A1L
        sec
        clv
        jmp     $CE51

        .res    $C6EA - *, ::OPC_NOP

LC6EA:  nop
        lda     A1H
        inc     a
        sta     A1H
        inc     $27
        cmp     $0800
        bcc     LC684
        ldy     #$00
        ldx     BAS2H
        jmp     $0801

        .byte   $DE
        .byte   $00             ; $00 = Disk II, 16-Sector
.endscope

;;; ============================================================
;;; Page $C7 - ???
;;; ============================================================

LC700:
.scope pageC7

LC700:  jsr     $C1F7
        pha
        jsr     $C1FD
        lda     $07F8
        sta     $07FF
        phx
        tsx
        txa
        clc
        adc     #$07
        tax
        lda     $0100,x
        plx
        and     #$10
        bne     LC747
        jsr     $C220
        bcc     LC744
        jsr     LC784
        bcc     LC744
        pla
        pha
        bpl     LC739
        txa
        tsx
        stx     $0101
        ldx     $0100
        txs
        tax
        sta     ALTZPOFF
        lda     #$80
LC739:  pha
        lda     #$C4
        pha
        lda     #$B4
        pha
        php
        jmp     (L03FE)

LC744:  jmp     pageC4::LC4BE

LC747:  pla
        sta     $44
        pla
        bpl     LC751
        lda     #$01
        tsb     $44
LC751:  pla
        ply
        plx
        plp
        jsr     MON_SAVE
        pla
        sta     $3A
        ply
        sty     $3B
        bit     RDALTZP
        bpl     LC781
        tsx
        stx     $0101
        ldx     $0100
        txs
        sta     ALTZPOFF
        sta     $3A
        sty     $3B
        ldx     #$05
LC774:  sta     ALTZPON
        lda     $44,x
        sta     ALTZPOFF
        sta     $44,x
        dex
        bpl     LC774
LC781:  jmp     (L03F0)

;;; ============================================================

LC784:  sec
        lda     $C0AA           ; ???
        tax
        and     #$0C
        eor     #$04
        beq     LC7E4
        lda     $C0A9           ; ???

LC792:  sta     $04FA
        ora     #$00
        bpl     LC7E4
        and     #$08
        beq     LC7BD
        txa
        and     #$03
        eor     #$01
        bne     LC7BD
        lda     $04FF
        eor     #$C2
        bne     LC7E4
        lda     $C0A8           ; ???
        ldx     $057F
        jsr     LC7E5
        bpl     LC7B8
        ldx     #$00
LC7B8:  stx     $057F
        bra     LC7E3

LC7BD:
        bit     $04FA
        bvc     LC7E3
        bit     $05FA
        bvs     LC7E4
        bpl     LC7E3
        lda     KBD
        bit     $C0B4           ; Softswitch for Fkeys ???
        bmi     :+              ; leave high bit set for later
        and     #$7F
:       bit     KBDSTRB
        ldx     $05FF
        jsr     LC7E5
        bne     :+
        ldx     #$80
:       stx     $05FF
LC7E3:  clc
LC7E4:  rts

LC7E5:  sta     WRCARDRAM
        sta     $0800,x
        sta     WRMAINRAM
        inx
        rts

;;; ============================================================

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

LC7FD:  jmp     LC792

.endscope
pageC7_LC7FD := pageC7::LC7FD

;;; ============================================================

        .res    $C800 - *, 0

;;; ============================================================
;;; Pages $C8-$CF - Enhanced 80 Column Firmware
;;; ============================================================

LC800:  .byte   $C3
        eor     $AA,x
        jmp     $C4A0           ; bad disasm?

LC806:  lda     #<LC305
        sta     KSWL
        ldx     #>LC305
        stx     KSWH
        lda     #<LC307
        sta     CSWL
        stx     CSWH
LC814:  lda     #M_NORMAL
        sta     MODE
        jsr     Enable80Col
        jsr     DoSETWND
        jmp     DoHomeAndClear

;;; ============================================================

LC822:  jsr     LCBE1
LC825:  inc     RNDL
        bne     LC82B
        inc     RNDH
LC82B:  jsr     LCCB8
        bcc     LC825
        jsr     LCCFB
        cmp     #$06
        bcc     LC840
        and     #$7F
        sta     CHAR
        ora     #$80
        bra     LC843

LC840:  sta     CHAR
LC843:  pha
        jsr     LCBF8
        pla
        rts

;;; ============================================================

OutputChar:
        sta     CHAR
LC84C:  jsr     CheckPauseListing
        lda     MODE
        and     #$03            ; test low 2 bits (why???)
        beq     @l1
        jmp     LCA2F

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

@l3:    jsr     LCC13
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
        bne     @l3
        bit     KBDSTRB
@l1:    lda     KBD
        bpl     @l1
        cmp     #$83            ; Ctrl-C
        beq     @l3
        .byte   $2C
@l2:    bpl     $C900
@l3:    rts

;;; ============================================================

LC941:  ldy     #$00
        ldx     #$00
@l1:    cpy     WNDWDTH
        bcs     @l2
        jsr     LC9A8
        sta     $0200,x
        inx
        iny
        bra     @l1
@l2:    dey
        sty     CH
        stx     SAVEX
        lda     #$8D            ; return
LC95B:  rts

;;; ============================================================

Do40Col:
        bit     RD80VID
        php
        jsr     Disable80Col
        jsr     LCAFA
        jsr     DoSETWND
        plp
        bpl     LC95B
        jmp     LCC68

;;; ============================================================

LC96F:  jsr     LC822
        cmp     #$00
        beq     @l4
        cmp     #$02
        beq     LC941
        cmp     #$05
        bne     LC95B
        ldy     CH
@l1:    iny
        cpy     WNDWDTH
        beq     @l2
        jsr     LC9A8
        dey
        jsr     LCEC8
        iny
        bra     @l1

@l2:    dey
@l3:    lda     #$A0
        jsr     LCEC8
        bra     LC96F

@l4:    ldy     WNDWDTH
@l5:    dey
        cpy     CH
        beq     @l3
        dey
        jsr     LC9A8
        iny
        jsr     LCEC8
        bra     @l5

;;; ============================================================

LC9A8:  jsr     LCEBD
        ora     #$80
        cmp     #$A0
        bcs     @l1
        ora     #$40
@l1:    rts

;;; ============================================================

LC9B4:  bit     RD80VID
        bpl     LC9CC
        lsr     WNDWDTH
        asl     WNDWDTH
        sta     SET80COL

        ;; This is CH fix described in source fragment below!
LC9C0:  lda     CH              ; HAVE THEY CHANGED COL?
        cmp     XCOORD
        bne     LC9CA           ; YES - USE THEIRS
        lda     OURCH           ; ELSE USE OURS (THEY MIGHT HAVE
                                ; CHANGED THIS TOO)
LC9CA:  sta     CH
LC9CC:  rts

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

Remain: lda     #$80
        bra     SetModeBits

;;; ============================================================

DoInverse:
        ldy     #$3F
        .byte   OPC_BIT_abs     ; skip next instruction
DoNormal:
        ldy     #$FF
        sty     INVFLG
LC9EA:  rts

;;; ============================================================

Do80Col:
        bit     RD80VID
        php
        jsr     Enable80Col
        jsr     LCAFA
        jsr     DoSETWND
        plp
        bmi     LC9EA
        jmp     LCC18

;;; ============================================================

DoQuit:
        jsr     Do40Col
        jsr     DoSETVID
        jsr     DoSETKBD
        lda     #23
        ldx     #0
        jsr     LCAA1

        lda     #M_INACTIVE
        sta     MODE

        lda     #$98
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

LCA2F:  lda     CHAR
        sec
        sbc     #$20
        and     #$7F
        pha
        dec     MODE
        lda     MODE
        and     #$03
        bne     @l2
        pla
        cmp     #$18
        bcs     @l1
        jsr     LCAA3
@l1:    lda     $05F8
        cmp     WNDWDTH
        bcs     :+
        sta     CH
:       rts

@l2:    pla
        sta     $05F8
        rts

;;; ============================================================

DoBackspace:
        lda     CH
        beq     LCA60
        dec     CH
LCA5F:  rts

;;; ============================================================

LCA60:  lda     CV
        beq     LCA5F
        lda     WNDWDTH
        dec     a
        sta     CH

DoUp:   lda     CV
        beq     LCA5F
        dec     CV
        bra     LCAA5

;;; ============================================================

DoForwardSpace:
        inc     CH
        lda     CH
        cmp     WNDWDTH
        bcc     LCA5F
        ;; fall through

;;; ============================================================

DoReturn:
        stz     CH
        ;; fall through

;;; ============================================================

DoLineFeed:
        lda     CV
        cmp     #$FF
        beq     @l1
        cmp     #$17
        bcs     DoScrollUp
@l1:    inc     CV
        bra     LCAA5

;;; ============================================================

DoHome:
        lda     WNDTOP
        ldx     #$00
        bra     LCAA1

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

LCA9B:  lda     $06F8
        ldx     $0778
LCAA1:  stx     CH
LCAA3:  sta     CV
LCAA5:  jmp     DoMON_VTAB

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
        jsr     LCAA5
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
        bra     LCAA1

LCAFA:  lda     CV
        sta     $06F8
        lda     CH
        sta     $0778
        rts

;;; ============================================================

DoScroll:
        jsr     LCAFA
        lda     WNDBTM
        dec     a
        dec     a
        sta     $05F8
LCB0F:  lda     $05F8
        jsr     LCAA3
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
        lda     $05F8
        inc     a
        jsr     LCAA3
        ldy     WNDWDTH
        dey
LCB27:  phy
        bit     TXTPAGE1
        bit     RD80VID
        bpl     LCB38
        tya
        lsr     a
        tay
        bcs     LCB38
        bit     TXTPAGE2
LCB38:  lda     (BAS2L),y
        sta     (BASL),y
        ply
        dey
        bpl     LCB27
        bit     TXTPAGE1
        lda     $05F8
        cmp     WNDTOP
        beq     LCB4F
        dec     $05F8
        bra     LCB0F
LCB4F:  lda     #$00
        jsr     LCAA3
        jsr     DoClearLine
        bit     TXTPAGE1
        jmp     LCA9B

;;; ============================================================

PascalInit:
        jsr     LC814
LCB60:  jsr     LCBE1
LCB63:  ldx     CH
        stx     OURCH
        stx     XCOORD
        ldx     #$00
        rts

;;; ============================================================

PascalRead:
        jsr     InitTextWindow
        jsr     LC822
        lda     CHAR
        bra     LCB63

;;; ============================================================

PascalWrite:
        sta     CHAR
        jsr     InitTextWindow
        jsr     LCBF8
        lda     CHAR
        ora     #$80
        sta     CHAR
        and     #$7F
        cmp     #$15
        beq     LCB63
        cmp     #$0D
        beq     @l1
        jsr     LC84C
        bra     LCB60
@l1:    stz     CH
        bra     LCB60

;;; ============================================================

PascalStatus:
        cmp     #$00
        beq     @l1
        cmp     #$01
        bne     @l2
        jsr     LCCB8
        bra     LCB63
@l1:    sec
        bra     LCB63
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
        jsr     LC9C0
        pla
        rts

;;; ============================================================

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

LCBE1:  lda     MODE
        cmp     #M_INACTIVE
        beq     LCC04
        and     #M_ESC
        beq     LCC04
        jsr     LCEBB
        sta     OLDCH
        and     #$80
        eor     #$AB
        bra     LCC13

;;; ============================================================

LCBF8:  lda     MODE
        and     #M_ESC
        beq     LCC04
        lda     OLDCH
        bra     LCC13
LCC04:  jsr     LCEBB
        eor     #$80

        ;; If within "@ABC...XYZ[\]^_" range, map to $00-$1F
        ;; so it shows as inverse uppercase, not MouseText.
        cmp     #'@'
        bcc     :+
        cmp     #'_'+1
        bcs     :+
        and     #$1F
:

LCC13:  ldy     CH
        jmp     LCEC8

LCC18:  php
        sei
        lda     WNDTOP
        sta     $05F8
LCC1F:  lda     $05F8
        jsr     LCAA3
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
        ldy     #$00
LCC2F:  bit     TXTPAGE1
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
        bcc     LCC2F
        lda     #$A0
LCC4B:  bit     TXTPAGE2
        sta     (BASL),y
        bit     TXTPAGE1
        sta     (BASL),y
        iny
        cpy     #$28
        bcc     LCC4B
        inc     $05F8
        lda     $05F8
        cmp     #$18
        bcc     LCC1F
LCC64:  plp
        jmp     LCA9B

LCC68:  php
        sei
        sta     SET80COL
        lda     WNDTOP
        sta     $05F8
LCC72:  lda     $05F8
        jsr     LCAA3
        ldy     #$13
        bit     TXTPAGE1
LCC7D:  lda     (BASL),y
        pha
        dey
        bpl     LCC7D
        ldy     #$00
        lda     BASL
        sta     BAS2L
        lda     BASH
        sta     BAS2H
LCC8D:  bit     TXTPAGE2
        lda     (BASL),y
        bit     TXTPAGE1
        sta     (BAS2L)
        inc     BAS2L
        pla
        sta     (BAS2L)
        inc     BAS2L
        iny
        cpy     #$14
        bcc     LCC8D
        inc     $05F8
        lda     $05F8
        cmp     #$18
        bcc     LCC72
        sta     CLR80COL
        bra     LCC64
LCCB2:  jsr     LCCB8
        jmp     pageC5::DoBankC5           ; bad disasm or ...?

LCCB8:  bit     $0579
        bmi     LCCD7
LCCBD:  bit     $05FA
        bvs     LCCCE
        bpl     LCCCE
        lda     $05FF
        cmp     $06FF
        beq     LCCD3
        bra     LCCD5
LCCCE:  bit     KBD
        bmi     LCCD5
LCCD3:  clc
        rts

LCCD5:  sec
        rts

LCCD7:  jsr     LCDA8
        beq     LCCE1
LCCDC:  stz     $0579
        bra     LCCBD
LCCE1:  phx
        ldx     FKEYPTR
        jsr     ReadAuxRAM
        lda     $0200,x
        jsr     ReadPreviousRAM
        plx
        cmp     #$00
        beq     LCCDC
        bra     LCCD5
LCCF5:  jsr     LCCFB
        jmp     pageC5::DoBankC5

LCCFB:  bit     $0579
        bpl     LCD03
        jmp     LCD85

LCD03:  bit     $05FA
        bvs     HandleSpecialKeys
        bpl     HandleSpecialKeys
        phx
        ldx     $06FF
        bit     RDRAMRD
        php
        sta     RDCARDRAM
        lda     $0800,x
        plp
        bmi     LCD1E
        sta     RDMAINRAM
LCD1E:  inx
        bne     LCD23
        ldx     #$80
LCD23:  stx     $06FF
        plx
        pha
        pla
        php
        ora     #$80
        plp
        bra     LCD38

;;; ============================================================

HandleSpecialKeys:
        lda     KBD
        bit     KBDSTRB
        bit     $C0B4           ; Softswitch for Fkeys???
LCD38:  bpl     LCD41
LCD3A:  cmp     #$06
        bcc     LCD40
        ora     #$80
LCD40:  rts

        ;; Deal with special keys
LCD41:  and     #$7F
        cmp     #$01            ; CLRL
        bne     LCD4B
        lda     #$1A
        bra     LCD3A

LCD4B:  cmp     #$03            ; CLRS
        bne     LCD53
        lda     #$0C
        bra     LCD3A

LCD53:  cmp     #$04            ; HOME
        bne     LCD5B
        lda     #$19
        bra     LCD3A

        ;; "Macro" keys
LCD5B:  cmp     #$06            ; RUN
        bne     LCD63
        lda     #$2C            ; Like F13
        bra     LCD73

LCD63:  cmp     #$1F            ; LIST
        bne     LCD6B
        lda     #$2D            ; Like F4
        bra     LCD73

LCD6B:  cmp     #$20            ; F1
        bcc     LCD3A
        cmp     #$2C            ; F12+1
        bcs     LCD3A

LCD73:  pha                     ; Handle Fkeys
        jsr     LCDA8
        beq     LCD7C
        pla
        bra     LCD3A

LCD7C:  lda     #$FF
        sta     $0579
        pla
        jsr     FindFKEYDefnOffset
LCD85:  jsr     LCDA8
        beq     LCD91
LCD8A:  stz     $0579
        lda     #$A0
        bra     LCD3A

LCD91:  phx
        ldx     FKEYPTR
        jsr     ReadAuxRAM
        lda     $0200,x
        jsr     ReadPreviousRAM
        plx
        inc     FKEYPTR
        cmp     #$00
        beq     LCD8A
        bra     LCD3A

;;; ============================================================

LCDA8:  jsr     ReadAuxRAM
        lda     #$00
        phx
        tax
        clc
LCDB0:  adc     $0200,x
        inx
        bne     LCDB0
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
        beq     @l4
@l1:    lda     $0200,y
        beq     @l2
        iny
        bra     @l1

@l2:    iny
@l3:    dex
        bne     @l1
@l4:    jsr     ReadPreviousRAM
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
        .byte   $FF

InitFKEYDefinitions:
        sta     WRCARDRAM
        lda     #$00
        tax
@l1:    sta     $0200,x
        inx
        cpx     #$0C
        bcc     @l1
@l2:    lda     SpecialStrings - 12,x
        cmp     #$FF
        beq     @l3
        sta     $0200,x
        inx
        bra     @l2

@l3:    sta     WRMAINRAM
        stz     $0579
        ;; fall through

LCE0D:  jsr     LCDA8
        sta     $04F9
        jmp     pageC5::DoBankC5

;;; ============================================================

;;; Read from Aux (saving previous state)

ReadAuxRAM:
        pha
        lda     RDRAMRD
        sta     RDMAINRAM
        sta     OURCV
        sta     RDCARDRAM
        pla
        rts

;;; Restore previous read bank state

ReadPreviousRAM:
        pha
        sta     RDMAINRAM
        lda     OURCV
        bpl     @l1
        sta     RDCARDRAM
@l1:    pla
        rts

;;; ============================================================

;;; Load X,Y with address of a routine -1 (for `ROMCall`)
.macro LDXY addr
        ldx     #.hibyte(addr-1)
        ldy     #.lobyte(addr-1)
.endmacro

;;; ============================================================

DoSETWND:
        lda     #0              ; set cursor to row 0
        bit     RDTEXT          ; unless graphics mode
        bmi     :+
        lda     #20             ; then use row 20
:       LDXY    SETWND
        bra     ROMCall

;;; ============================================================

DoBell:
        LDXY    BELLB
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

LCEBB:  ldy     CH
LCEBD:  phy
        jsr     LCED2
        lda     (BASL),y
LCEC3:  ply
        bit     TXTPAGE1
        rts

;;; ============================================================

LCEC8:
        phy
        pha
        jsr     LCED2
        pla
        sta     (BASL),y
        bra     LCEC3

;;; ============================================================

LCED2:
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

.if !INCLUDE_PATCHES
        .byte   "EN\r"
        .byte   "\tASL\tWIDTH\r"
        .byte   "\tSTA\tON80ST\tMAKE SURE 80 STORE IS ENABLED\r"
        .byte   "\r"
        .byte   ";CHANGED THIS 9/15/86 FOR HABA MERGE AND MOUSE WRITE:\r"
        .byte   "\r"
        .byte   "FIXCOL\tLDA\tCOL\tHAVE THEY CHANGED COL ?\r"
        .byte   "\tCMP\tOLDCOL\r"
        .byte   "\tBNE\t.2\tYES - USE THEIRS\r"
        .byte   "\tLDA\tAPPLECOL\tELSE USE OURS (THEY MIGHT HAVE\r"
        .byte   ";\t\t\t   CHANGED THIS TOO)\r"
        .byte   ".2\tSTA\tCOL\r"
        .byte   "\r"
        .byte   ".END\tRTS\r"
        .byte   "\r"
        .byte   "\x1F"
        .byte   "\r;E"
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

        .res    $D000 - *, 0

;;; ============================================================

        .assert * = $D000, error, "Length changed"
