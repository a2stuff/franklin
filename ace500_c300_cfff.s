; da65 V2.19 - Git 59c58acbe
; Created:    2021-11-04 15:14:09
; Input file: c300_cfff
; Page:       1

        .org $C300
        .setcpu "65C02"

L03F0           := $03F0
L03FE           := $03FE
L0801           := $0801
L2020           := $2020
L3F20           := $3F20
L4144           := $4144
L4148           := $4148
L4445           := $4445
L4843           := $4843
L4854           := $4854
L494D           := $494D
L4E41           := $4E41
L4E45           := $4E45
L4F43           := $4F43
L4F46           := $4F46
L4F4D           := $4F4D
L4F54           := $4F54
L5349           := $5349
L5355           := $5355
L5428           := $5428
L5709           := $5709
LC1F2           := $C1F2
LC1F7           := $C1F7
LC1FA           := $C1FA
LC1FD           := $C1FD
LC220           := $C220
LD00C           := $D00C
LFC24           := $FC24
LFC58           := $FC58
LFC9E           := $FC9E
LFDED           := $FDED
LFDF0           := $FDF0
LFF4A           := $FF4A
LC300:  bit     LC3D4
        bra     LC341
        sec
        bcc     LC320
        clv
        bra     LC341
        ora     ($88,x)
        inc     a
        .byte   $23
        .byte   $2B
        .byte   $33
        jmp     LC33B

        jsr     LC5FA
        jmp     LCC03

        jsr     LC3C4
        jsr     LCB5D
LC320:  jmp     LC5FA

        jsr     LC3C4
        jsr     LCB6E
        bra     LC320
        jsr     LC3C4
        jsr     LCB79
        bra     LC320
        jsr     LC3C4
        jsr     LCB9D
        bra     LC320
LC33B:  jsr     LC5FA
        jmp     LCC06

LC341:  jsr     LC3C4
        sta     $04F8
        stx     $0578
        sty     $0478
        pha
        bvc     LC354
        jsr     LC806
        clc
LC354:  php
        jsr     LC9B4
        plp
        pla
        bcc     LC397
        ldx     $0578
        beq     LC371
        dex
        lda     $0678
        cmp     #$88
        beq     LC371
        cmp     $0200,x
        bne     LC38F
        sta     $0200,x
LC371:  jsr     LC96F
        cmp     #$9B
        beq     LC3AE
        cmp     #$8D
        bne     LC381
        pha
        jsr     LCE66
        pla
LC381:  cmp     #$95
        bne     LC38A
        ldy     $24
        jsr     LC9A8
LC38A:  sta     $0678
        bra     LC395
LC38F:  jsr     LC822
        stz     $0678
LC395:  bra     LC39D
LC397:  jsr     LC849
        lda     $04F8
LC39D:  ldx     $0578
        ldy     $24
        sty     $057B
        sty     $06FB
        ldy     $0478
        jmp     LC5FA

LC3AE:  lda     #$80
        tsb     $04FB
        jsr     LC822
        jsr     LC8CB
        cmp     #$98
        beq     LC38A
        lda     $04FB
        bmi     LC3AE
        bra     LC371
LC3C4:  php
        sei
        pha
        sta     $C0BA
        sta     LCFFF
        lda     #$C3
        sta     $07F8
        pla
        plp
LC3D4:  rts

        brk
        brk
        brk
        brk
        brk
        brk
        brk
        jsr     LC5FA
        jmp     LCC00

LC3E2:  plx
        bit     LCFFF
        rti

        brk
        jsr     LC3C4
        jmp     LCE0D

        jsr     LC3C4
        jmp     LCDEC

LC3F4:  jsr     LC3C4
        jmp     LCCB2

LC3FA:  jsr     LC3C4
        jmp     LCCF5

        bit     LC42E
        bra     LC41C
        sec
        bcc     LC420
        clv
        bra     LC41C
        ora     ($20,x)
        bit     $2C2C
        bit     $2F00
        and     $3B,x
        eor     ($47,x)
        eor     $5953
        .byte   $2C
        .byte   $5F
LC41C:  jsr     LC5FA
        .byte   $50
LC420:  .byte   $03
        jsr     LC806
        bcc     LC429
        jmp     LC838

LC429:  jmp     LC825

        ldx     #$03
LC42E:  rts

        jsr     LC5FA
        jmp     LC8D4

        jsr     LC5FA
        jmp     LC916

        jsr     LC5FA
        jmp     LC922

        jsr     LC5FA
        jmp     LC958

        jsr     LC5FA
        jmp     LC967

        jsr     LC5FA
        jmp     LC969

        jsr     LC5FA
        jmp     LC93E

LC459:  jsr     LC5FA
        jmp     LC8AC

        ldx     $C066
        ldy     $C067
        jmp     LC220

LC468:  jsr     LC5FA
        jmp     LC9A0

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

        pla
        bpl     LC4BE
        sta     $C009
        ldx     $0101
        txs
LC4BE:  ldx     $07FF
        pla
        jsr     LC1FA
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

LC4E4:  jmp     LC1F2

LC4E7:  jmp     LC3E2

LC4EA:  jmp     LC5F5

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

        dec     $00,x
        jmp     LC459

        jsr     LC594
        sta     $067A
        phx
        phy
        pha
        bvc     LC50E
        jsr     LC806
LC50E:  bcc     LC516
        jsr     LC908
        plx
        bra     LC51A
LC516:  jsr     LC83B
        pla
LC51A:  ply
        plx
        jmp     LC5A8

        jsr     LC594
        jsr     LC8C7
        jmp     LC5A8

        jsr     LC594
        jsr     LC8CD
        bra     LC5A8
        jsr     LC594
        jsr     LC8D2
        bra     LC5A8
        jsr     LC594
        jsr     LC8DA
        bra     LC5A8
        jsr     LC5A8
        ora     #$80
        jsr     LFDF0
        bra     LC594
        jsr     LC5A8
        ora     #$80
        jsr     LFDED
        bra     LC594
        jsr     LC5A8
        jsr     LC3F4
        bra     LC594
        jsr     LC5A8
        jsr     LC3FA
        and     #$7F
        bra     LC594
        jsr     LC5A8
        jsr     LFC9E
        bra     LC594
        jsr     LC5A8
        jsr     LFC58
        bra     LC594
        jsr     LC5A8
        jsr     LC300
        bra     LC594
        jsr     LC5A8
        jsr     LC4F8
        bra     LC594
        jsr     LC5A8
        jsr     LC7FD
        bra     LC594
        jsr     LC5A8
        jsr     LFC24
LC594:  php
        sei
        pha
        lda     #$C5
        sta     $07F8
        sta     $C0BA
        sta     $C0B8
        sta     LCFFF
        pla
        plp
        rts

LC5A8:  php
        sei
        pha
        lda     #$C8
        sta     $07F8
        sta     $C0BB
        sta     $C0B9
        pla
        plp
        rts

        jsr     LC5A8
LC5BC:  bit     $C1C1
        bmi     LC5BC
        sta     $C090
        bra     LC594
LC5C6:  jsr     LC594
        jsr     LC9A5
        bra     LC5A8
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
        brk
LC5F5:  plx
        bit     LCFFF
        rti

LC5FA:  jmp     LC5A8

        jmp     LC5C6

        bit     $20
        cpy     $00
        ldx     #$03
        asl     $3C
        jsr     LC5FA
        ldy     #$69
LC60D:  lda     LCF26,y
        sta     $036C,y
        dey
        bpl     LC60D
        ldx     #$60
LC618:  inc     $2B
        cpx     $2B
        bne     LC618
        jsr     LCEA6
LC621:  dec     $41
        bne     LC621
LC625:  dec     $3D
        bne     LC625
LC629:  dec     $26
        bne     LC629
LC62D:  dec     $27
        lda     $27
        cmp     #$08
        bne     LC62D
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
        nop
        nop
        nop
        nop
        nop
        pha
        nop
        nop
        nop
        nop
        nop
        nop
        bra     LC683
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
LC683:  pla
LC684:  jsr     LC5FA
        jsr     LCE00
        bra     LC6EA
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
        brk
        brk
        brk
        brk
        brk
        brk
        brk
        ldy     #$56
        sty     $3C
        sec
        clv
        jmp     LCE51

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
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
LC6EA:  nop
        lda     $3D
        inc     a
        sta     $3D
        inc     $27
        cmp     $0800
        bcc     LC684
        ldy     #$00
        ldx     $2B
        jmp     L0801

        .byte   $DE
        brk
LC700:  jsr     LC1F7
        pha
        jsr     LC1FD
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
        jsr     LC220
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
        sta     $C008
        lda     #$80
LC739:  pha
        lda     #$C4
        pha
        lda     #$B4
        pha
        php
        jmp     (L03FE)

LC744:  jmp     LC4BE

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
        jsr     LFF4A
        pla
        sta     $3A
        ply
        sty     $3B
        bit     $C016
        bpl     LC781
        tsx
        stx     $0101
        ldx     $0100
        txs
        sta     $C008
        sta     $3A
        sty     $3B
        ldx     #$05
LC774:  sta     $C009
        lda     $44,x
        sta     $C008
        sta     $44,x
        dex
        bpl     LC774
LC781:  jmp     (L03F0)

LC784:  sec
        lda     $C0AA
        tax
        and     #$0C
        eor     #$04
        beq     LC7E4
        lda     $C0A9
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
        lda     $C0A8
        ldx     $057F
        jsr     LC7E5
        bpl     LC7B8
        ldx     #$00
LC7B8:  stx     $057F
        bra     LC7E3
LC7BD:  .byte   $2C
        plx
LC7BF:  tsb     $50
        and     ($2C,x)
        plx
        ora     $70
        ora     $1A10,x
        lda     $C000
        bit     $C0B4
        bmi     LC7D3
        and     #$7F
LC7D3:  bit     $C010
        ldx     $05FF
        jsr     LC7E5
        bne     LC7E0
        ldx     #$80
LC7E0:  stx     $05FF
LC7E3:  clc
LC7E4:  rts

LC7E5:  sta     $C005
        sta     $0800,x
        sta     $C004
        inx
        rts

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

        .byte   $C3
        eor     $AA,x
        jmp     LC4A0

LC806:  lda     #$05
        sta     $38
        ldx     #$C3
        stx     $39
        lda     #$07
        sta     $36
        stx     $37
LC814:  lda     #$30
        sta     $04FB
        jsr     LCBD7
        jsr     LCE33
        jmp     LCE60

LC822:  jsr     LCBE1
LC825:  inc     $4E
        bne     LC82B
        inc     $4F
LC82B:  jsr     LCCB8
        bcc     LC825
        jsr     LCCFB
        cmp     #$06
        bcc     LC840
        .byte   $29
LC838:  bbr7    $8D,LC8B6
LC83B:  asl     $09
        bra     LC7BF
        .byte   $03
LC840:  sta     $067B
        pha
        jsr     LCBF8
LC847:  pla
        rts

LC849:  sta     $067B
LC84C:  jsr     LC92A
        lda     $04FB
        and     #$03
        beq     LC859
        jmp     LCA2F

LC859:  lda     $067B
        and     #$7F
        cmp     #$20
        bcc     LC88F
        ldy     $24
        cpy     $21
        bcc     LC86B
        jsr     LCA79
LC86B:  lda     $067B
        bit     $32
        bmi     LC888
        and     #$7F
        bit     $04FB
        bvs     LC888
        bit     $C01E
        bpl     LC888
        cmp     #$40
        bcc     LC888
        cmp     #$60
        bcs     LC888
        and     #$1F
LC888:  jsr     LCC13
        jmp     LCA71

LC88E:  rts

LC88F:  sec
        sbc     #$07
        bcc     LC88E
        asl     a
        tax
        jmp     (LC899,x)
LC899:  .byte   $42
        dec     LCA59
        stx     $7BC8
        dex
        phy
        dec     LCE60
        adc     $E6CA,y
        cmp     #$E3
        cmp     #$8E
LC8AC:  iny
        .byte   $5C
        cmp     #$EB
        cmp     #$8E
        iny
        stx     $FEC8
LC8B6:  cmp     #$05
        wai
        tay
        dex
        bbr1    $CA,LC847
        dex
        bbs0    $CA,LC8E8
        dex
        adc     ($CA),y
        ror     $CE
LC8C7:  asl     $CA,x
        adc     #$CA
LC8CB:  pha
        .byte   $A9
LC8CD:  bra     LC8EB
        .byte   $FB
        tsb     $68
LC8D2:  and     #$7F
LC8D4:  cmp     #$61
        bcc     LC8DE
        cmp     #$7B
LC8DA:  bcs     LC8DE
        and     #$DF
LC8DE:  ldx     #$00
LC8E0:  ldy     LC8F3,x
        beq     LC88E
        cmp     LC8F3,x
LC8E8:  beq     LC8ED
        inx
LC8EB:  bra     LC8E0
LC8ED:  txa
        asl     a
        tax
        jmp     (LC906,x)
LC8F3:  rti

        eor     ($42,x)
        .byte   $43
        .byte   $44
        eor     $46
        eor     #$4A
        .byte   $4B
        eor     $0A0B
LC900:  php
        ora     $34,x
        sec
        ora     ($00),y
LC906:  rts

        .byte   $CE
LC908:  adc     ($CA),y
        eor     $7BCA,y
        dex
        adc     #$CA
        ror     $CE
        phy
        dec     LC9CD
LC916:  .byte   $DC
        cmp     #$D7
        cmp     #$D2
        cmp     #$CD
        cmp     #$D2
        cmp     #$DC
        .byte   $C9
LC922:  smb5    $C9
        .byte   $5C
        cmp     #$EB
        cmp     #$FE
        .byte   $C9
LC92A:  lda     $C000
        cmp     #$93
        bne     LC940
        bit     $C010
LC934:  lda     $C000
        bpl     LC934
        cmp     #$83
        beq     LC940
        .byte   $2C
LC93E:  bpl     LC900
LC940:  rts

LC941:  ldy     #$00
        ldx     #$00
LC945:  cpy     $21
        bcs     LC953
        jsr     LC9A8
        sta     $0200,x
        inx
        iny
        bra     LC945
LC953:  dey
        sty     $24
        .byte   $8E
        sei
LC958:  ora     $A9
        .byte   $8D
LC95B:  rts

LC95C:  bit     $C01F
        php
        jsr     LCBD0
        jsr     LCAFA
        .byte   $20
LC967:  .byte   $33
LC968:  .byte   $CE
LC969:  plp
        bpl     LC95B
        jmp     LCC68

LC96F:  jsr     LC822
        cmp     #$00
        beq     LC997
        cmp     #$02
        beq     LC941
        cmp     #$05
        bne     LC95B
        ldy     $24
LC980:  iny
        cpy     $21
        beq     LC98F
        jsr     LC9A8
        dey
        jsr     LCEC8
        iny
        bra     LC980
LC98F:  dey
LC990:  lda     #$A0
        jsr     LCEC8
        bra     LC96F
LC997:  ldy     $21
        dey
        cpy     $24
        beq     LC990
        dey
        .byte   $20
LC9A0:  tay
        cmp     #$C8
        .byte   $20
        iny
LC9A5:  dec     $F180
LC9A8:  jsr     LCEBD
        ora     #$80
        cmp     #$A0
        bcs     LC9B3
        ora     #$40
LC9B3:  rts

LC9B4:  bit     $C01F
        bpl     LC9CC
        lsr     $21
        asl     $21
        sta     $C001
LC9C0:  lda     $24
        cmp     $06FB
        bne     LC9CA
        lda     $057B
LC9CA:  sta     $24
LC9CC:  rts

LC9CD:  jsr     LCA69
        bra     LC9DF
        jsr     LCA7B
        bra     LC9DF
        jsr     LCA71
        bra     LC9DF
        jsr     LCA59
LC9DF:  lda     #$80
        bra     LCA28
        ldy     #$3F
        bit     $FFA0
        sty     $32
LC9EA:  rts

        bit     $C01F
        php
        jsr     LCBD7
        jsr     LCAFA
        jsr     LCE33
        plp
        bmi     LC9EA
        jmp     LCC18

        jsr     LC95C
        jsr     LCE4E
        jsr     LCE48
        lda     #$17
        ldx     #$00
        jsr     LCAA1
        lda     #$FF
        sta     $04FB
        lda     #$98
        rts

        lda     #$FC
        jsr     LCA21
        lda     #$32
        bra     LCA28
        lda     #$40
LCA21:  and     $04FB
        bra     LCA2B
        lda     #$40
LCA28:  ora     $04FB
LCA2B:  sta     $04FB
        rts

LCA2F:  lda     $067B
        sec
        sbc     #$20
        and     #$7F
        pha
        dec     $04FB
        lda     $04FB
        and     #$03
        bne     LCA54
        pla
        cmp     #$18
        bcs     LCA4A
        jsr     LCAA3
LCA4A:  lda     $05F8
        cmp     $21
        bcs     LCA53
        sta     $24
LCA53:  rts

LCA54:  pla
        sta     $05F8
        rts

LCA59:  lda     $24
        beq     LCA60
        dec     $24
LCA5F:  rts

LCA60:  lda     $25
        beq     LCA5F
        lda     $21
        dec     a
        sta     $24
LCA69:  lda     $25
        beq     LCA5F
        dec     $25
        bra     LCAA5
LCA71:  inc     $24
        lda     $24
        cmp     $21
        bcc     LCA5F
LCA79:  stz     $24
LCA7B:  lda     $25
        cmp     #$FF
        beq     LCA85
        cmp     #$17
        bcs     LCAA8
LCA85:  inc     $25
        bra     LCAA5
LCA89:  lda     $22
        ldx     #$00
        bra     LCAA1
LCA8F:  lda     $24
        pha
        stz     $24
        jsr     LCE66
        pla
        sta     $24
        rts

LCA9B:  lda     $06F8
        ldx     $0778
LCAA1:  stx     $24
LCAA3:  sta     $25
LCAA5:  jmp     LCE54

LCAA8:  lda     $24
        pha
        jsr     LCA89
LCAAE:  ldy     $29
        sty     $2B
        ldy     $28
        sty     $2A
        lda     $23
        beq     LCAF0
        dec     a
        cmp     $25
        beq     LCAF0
        bcc     LCAF0
        inc     $25
        jsr     LCAA5
        ldy     $21
        dey
        bit     $C01F
        bmi     LCAD7
LCACE:  lda     ($28),y
        sta     ($2A),y
        dey
        bpl     LCACE
        bra     LCAAE
LCAD7:  tya
        lsr     a
        tay
LCADA:  bit     $C054
        lda     ($28),y
        sta     ($2A),y
        bit     $C055
        lda     ($28),y
        sta     ($2A),y
        dey
        bpl     LCADA
        bit     $C054
        bra     LCAAE
LCAF0:  stz     $24
        jsr     LCE66
        plx
        lda     $25
        bra     LCAA1
LCAFA:  lda     $25
        sta     $06F8
        lda     $24
        sta     $0778
        rts

        jsr     LCAFA
        lda     $23
        dec     a
        dec     a
        sta     $05F8
LCB0F:  lda     $05F8
        jsr     LCAA3
        lda     $28
        sta     $2A
        lda     $29
        sta     $2B
        lda     $05F8
        inc     a
        jsr     LCAA3
        ldy     $21
        dey
LCB27:  phy
        bit     $C054
        bit     $C01F
        bpl     LCB38
        tya
        lsr     a
        tay
        bcs     LCB38
        bit     $C055
LCB38:  lda     ($2A),y
        sta     ($28),y
        ply
        dey
        bpl     LCB27
        bit     $C054
        lda     $05F8
        cmp     $22
        beq     LCB4F
        dec     $05F8
        bra     LCB0F
LCB4F:  lda     #$00
        jsr     LCAA3
        jsr     LCA8F
        bit     $C054
        jmp     LCA9B

LCB5D:  jsr     LC814
LCB60:  jsr     LCBE1
LCB63:  ldx     $24
        stx     $057B
        stx     $06FB
        ldx     #$00
        rts

LCB6E:  jsr     LCBB1
        jsr     LC822
        lda     $067B
        bra     LCB63
LCB79:  sta     $067B
        jsr     LCBB1
        jsr     LCBF8
        lda     $067B
        ora     #$80
        sta     $067B
        and     #$7F
        cmp     #$15
        beq     LCB63
        cmp     #$0D
        beq     LCB99
        jsr     LC84C
        bra     LCB60
LCB99:  stz     $24
        bra     LCB60
LCB9D:  cmp     #$00
        beq     LCBAA
        cmp     #$01
        bne     LCBAD
        jsr     LCCB8
        bra     LCB63
LCBAA:  sec
        bra     LCB63
LCBAD:  ldx     #$03
        clc
        rts

LCBB1:  pha
        lda     $077B
        sta     $28
        lda     $07FB
        sta     $29
        stz     $22
        stz     $20
        lda     #$50
        sta     $21
        lda     #$18
        sta     $23
        jsr     LC9C0
        pla
        rts

        sta     $C00E
LCBD0:  sta     $C000
        sta     $C00C
        rts

LCBD7:  sta     $C001
        sta     $C00D
        sta     $C00F
        rts

LCBE1:  lda     $04FB
        cmp     #$FF
        beq     LCC04
        and     #$80
        beq     LCC04
        jsr     LCEBB
        sta     $047B
        and     #$80
        eor     #$AB
        bra     LCC13
LCBF8:  lda     $04FB
        and     #$80
        beq     LCC04
        .byte   $AD
LCC00:  .byte   $7B
        tsb     $80
LCC03:  .byte   $0F
LCC04:  .byte   $20
        .byte   $BB
LCC06:  dec     $8049
        cmp     #$40
        bcc     LCC13
        cmp     #$60
        bcs     LCC13
        and     #$1F
LCC13:  ldy     $24
        jmp     LCEC8

LCC18:  php
        sei
        lda     $22
        sta     $05F8
LCC1F:  lda     $05F8
        jsr     LCAA3
        lda     $28
        sta     $2A
        lda     $29
        sta     $2B
        ldy     #$00
LCC2F:  bit     $C054
        lda     ($2A)
        bit     $C055
        sta     ($28),y
        bit     $C054
        inc     $2A
        lda     ($2A)
        sta     ($28),y
        iny
        inc     $2A
        cpy     #$14
        bcc     LCC2F
        lda     #$A0
LCC4B:  bit     $C055
        sta     ($28),y
        bit     $C054
        sta     ($28),y
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
        sta     $C001
        lda     $22
        sta     $05F8
LCC72:  lda     $05F8
        jsr     LCAA3
        ldy     #$13
        bit     $C054
LCC7D:  lda     ($28),y
        pha
        dey
        bpl     LCC7D
        ldy     #$00
        lda     $28
        sta     $2A
        lda     $29
        sta     $2B
LCC8D:  bit     $C055
        lda     ($28),y
        bit     $C054
        sta     ($2A)
        inc     $2A
        pla
        sta     ($2A)
        inc     $2A
        iny
        cpy     #$14
        bcc     LCC8D
        inc     $05F8
        lda     $05F8
        cmp     #$18
        bcc     LCC72
        sta     $C000
        bra     LCC64
LCCB2:  jsr     LCCB8
        jmp     LC5FA

LCCB8:  bit     $0579
        bmi     LCCD7
LCCBD:  bit     $05FA
        bvs     LCCCE
        bpl     LCCCE
        lda     $05FF
        cmp     $06FF
        beq     LCCD3
        bra     LCCD5
LCCCE:  bit     $C000
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
        ldx     $0479
        jsr     LCE16
        lda     $0200,x
        jsr     LCE25
        plx
        cmp     #$00
        beq     LCCDC
        bra     LCCD5
LCCF5:  jsr     LCCFB
        jmp     LC5FA

LCCFB:  bit     $0579
        bpl     LCD03
        jmp     LCD85

LCD03:  bit     $05FA
        bvs     LCD2F
        bpl     LCD2F
        phx
        ldx     $06FF
        bit     $C013
        php
        sta     $C003
        lda     $0800,x
        plp
        bmi     LCD1E
        sta     $C002
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
LCD2F:  lda     $C000
        bit     $C010
        bit     $C0B4
LCD38:  bpl     LCD41
LCD3A:  cmp     #$06
        bcc     LCD40
        ora     #$80
LCD40:  rts

LCD41:  and     #$7F
        cmp     #$01
        bne     LCD4B
        lda     #$1A
        bra     LCD3A
LCD4B:  cmp     #$03
        bne     LCD53
        lda     #$0C
        bra     LCD3A
LCD53:  cmp     #$04
        bne     LCD5B
        lda     #$19
        bra     LCD3A
LCD5B:  cmp     #$06
        bne     LCD63
        lda     #$2C
        bra     LCD73
LCD63:  cmp     #$1F
        bne     LCD6B
        lda     #$2D
        bra     LCD73
LCD6B:  cmp     #$20
        bcc     LCD3A
        cmp     #$2C
        bcs     LCD3A
LCD73:  pha
        jsr     LCDA8
        beq     LCD7C
        pla
        bra     LCD3A
LCD7C:  lda     #$FF
        sta     $0579
        pla
        jsr     LCDBE
LCD85:  jsr     LCDA8
        beq     LCD91
LCD8A:  stz     $0579
        lda     #$A0
        bra     LCD3A
LCD91:  phx
        ldx     $0479
        jsr     LCE16
        lda     $0200,x
        jsr     LCE25
        plx
        inc     $0479
        cmp     #$00
        beq     LCD8A
        bra     LCD3A
LCDA8:  jsr     LCE16
        lda     #$00
        phx
        tax
        clc
LCDB0:  adc     $0200,x
        inx
        bne     LCDB0
        plx
        jsr     LCE25
        cmp     $04F9
        rts

LCDBE:  phx
        phy
        jsr     LCE16
        sec
        sbc     #$20
        ldy     #$00
        tax
        beq     LCDD7
LCDCB:  lda     $0200,y
        beq     LCDD3
        iny
        bra     LCDCB
LCDD3:  iny
LCDD4:  dex
        bne     LCDCB
LCDD7:  jsr     LCE25
        sty     $0479
        ply
        plx
        rts

        eor     ($55)
        lsr     a:$0D
        jmp     L5349

        .byte   $54
        ora     $FF00
LCDEC:  sta     $C005
        lda     #$00
        tax
LCDF2:  sta     $0200,x
        inx
        cpx     #$0C
        bcc     LCDF2
LCDFA:  lda     LCDD4,x
        cmp     #$FF
        .byte   $F0
LCE00:  asl     $9D
        brk
        .byte   $02
        inx
        bra     LCDFA
        sta     $C004
        stz     $0579
LCE0D:  jsr     LCDA8
        sta     $04F9
        jmp     LC5FA

LCE16:  pha
        lda     $C013
        sta     $C002
        sta     $05FB
        sta     $C003
        pla
        rts

LCE25:  pha
        sta     $C002
        lda     $05FB
        bpl     LCE31
        sta     $C003
LCE31:  pla
        rts

LCE33:  lda     #$00
        bit     $C01A
        bmi     LCE3C
        lda     #$14
LCE3C:  ldx     #$FB
        ldy     #$4A
        bra     LCE6A
        ldx     #$FB
        ldy     #$E1
        bra     LCE6A
LCE48:  ldx     #$FE
        ldy     #$88
        bra     LCE6A
LCE4E:  ldx     #$FE
        .byte   $A0
LCE51:  sta     ($80)
        .byte   $16
LCE54:  ldx     #$FC
        ldy     #$21
        bra     LCE6A
        ldx     #$FC
        ldy     #$41
        bra     LCE6A
LCE60:  ldx     #$FC
        ldy     #$57
        bra     LCE6A
LCE66:  ldx     #$FC
        ldy     #$9B
LCE6A:  sta     $07FB
        bit     $C012
        php
        bit     $C011
        php
        lda     #$CE
        pha
        lda     #$83
        pha
        phx
        phy
        bit     $C082
        lda     $07FB
        rts

        plp
        bpl     LCE9A
        plp
        bpl     LCE92
        bit     $C083
        bit     $C083
        bra     LCEAB
LCE92:  bit     $C081
        bit     $C081
        bra     LCEAB
LCE9A:  plp
        bpl     LCEA5
        bit     $C08B
        bit     $C08B
        bra     LCEAB
LCEA5:  .byte   $2C
LCEA6:  bit     #$C0
        bit     $C089
LCEAB:  lda     $28
        sta     $077B
        lda     $29
        sta     $07FB
        lda     $24
        sta     $057B
        rts

LCEBB:  ldy     $24
LCEBD:  phy
        jsr     LCED2
        lda     ($28),y
LCEC3:  ply
        bit     $C054
        rts

LCEC8:  phy
        pha
        jsr     LCED2
        pla
        sta     ($28),y
        bra     LCEC3
LCED2:  bit     $C01F
        bpl     LCEDC
        tya
        lsr     a
        tay
        bcc     LCEE0
LCEDC:  bit     $C054
        rts

LCEE0:  bit     $C055
        rts

        eor     $4E
        ora     $4109
        .byte   $53
        jmp     L5709

        eor     #$44
        .byte   $54
        pha
        ora     $5309
        .byte   $54
        eor     ($09,x)
        bbr4    $4E,LCF32
        bmi     LCF4F
        .byte   $54
        ora     #$4D
        eor     ($4B,x)
        eor     $20
        .byte   $53
        eor     $52,x
        eor     $20
        sec
        bmi     LCF2B
        .byte   $53
        .byte   $54
        bbr4    $52,LCF55
        jsr     L5349
        jsr     L4E45
        eor     ($42,x)
        jmp     L4445

        ora     $3B0D
        .byte   $43
        pha
        eor     ($4E,x)
        rmb4    $45
        .byte   $44
        .byte   $20
LCF26:  .byte   $54
        pha
        eor     #$53
        .byte   $20
LCF2B:  and     $312F,y
        and     $2F,x
        sec
        .byte   $36
LCF32:  jsr     L4F46
        eor     ($20)
        pha
        eor     ($42,x)
        eor     ($20,x)
        eor     $5245
        rmb4    $45
        jsr     L4E41
        .byte   $44
        jsr     L4F4D
        eor     $53,x
        eor     $20
        rmb5    $52
        .byte   $49
LCF4F:  .byte   $54
        eor     $3A
        ora     $460D
LCF55:  eor     #$58
        .byte   $43
        bbr4    $4C,LCF64
        jmp     L4144

        ora     #$43
        bbr4    $4C,LCF6C
        pha
LCF64:  eor     ($56,x)
        eor     $20
        .byte   $54
        pha
        eor     $59
LCF6C:  jsr     L4843
        eor     ($4E,x)
        rmb4    $45
        .byte   $44
        jsr     L4F43
        jmp     L3F20

        ora     $4309
        eor     $0950
        bbr4    $4C,LCFC7
        .byte   $43
        bbr4    $4C,LCF94
        ora     #$42
        lsr     $0945
        rol     $0932
        eor     $5345,y
        .byte   $20
        .byte   $2D
LCF94:  jsr     L5355
        eor     $20
        .byte   $54
        pha
        eor     $49
        eor     ($53)
        ora     $4C09
        .byte   $44
        eor     ($09,x)
        eor     ($50,x)
        bvc     LCFF5
        eor     $43
        bbr4    $4C,LCFB7
        eor     $4C
        .byte   $53
        eor     $20
        eor     $53,x
        eor     $20
LCFB7:  bbr4    $55,LD00C
        .byte   $53
        jsr     L5428
        pha
        eor     $59
        jsr     L494D
        rmb4    $48
        .byte   $54
LCFC7:  jsr     L4148
        lsr     $45,x
        ora     $093B
        ora     #$09
        jsr     L2020
        .byte   $43
        pha
        eor     ($4E,x)
        rmb4    $45
        .byte   $44
        jsr     L4854
        eor     #$53
        jsr     L4F54
        bbr4    $29,LCFF3
        rol     $0932
        .byte   $53
        .byte   $54
        eor     ($09,x)
        .byte   $43
        bbr4    $4C,LCFFE
        .byte   $0D
        .byte   $2E
LCFF3:  eor     $4E
LCFF5:  .byte   $44
        ora     #$52
        .byte   $54
        .byte   $53
        ora     $1F0D
        .byte   $0D
LCFFE:  .byte   $3B
LCFFF:  .byte   $45
