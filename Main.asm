; ============================================================
; Author: Jacob Baker
; Version: Fall 2025
; ============================================================

; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $33, $30, $34, $29, $00, $00, $00


*=$0900
PROGRAM_START

        jsr COPY_SPRITE
        jsr LOAD_SPRITE
        jsr SETUP_INTERRUPT
        

PROGRAM_END
        rts

COUNTER
        BYTE 0

SETUP_INTERRUPT
        sei
        lda #<ANIMATION_ROUTINE
        sta $0314
        lda #>ANIMATION_ROUTINE
        sta $0315
        cli
        rts

ANIMATION_ROUTINE
        inc COUNTER

        lda COUNTER
        sta $0400

        jmp $EA31
        
COPY_SPRITE
        jsr COPY_FRONT
        jsr COPY_LEFT
        jsr COPY_RIGHT
        rts

COPY_FRONT
        ldx #0
CF_LOOP
        lda EYE_FRONT_DATA,x
        sta $2000,x
        inx
        cpx #64
        bne CF_LOOP
        rts

COPY_LEFT
        ldx #0
CL_LOOP
        lda EYE_LEFT_DATA,x
        sta $2040,x
        inx
        cpx #64
        bne CL_LOOP
        rts

COPY_RIGHT
        ldx #0
CR_LOOP
        lda EYE_RIGHT_DATA,x
        sta $2080,x
        inx
        cpx #64
        bne CR_LOOP
        rts

LOAD_SPRITE

        lda #$80
        sta $07F8

        lda #%00000001
        sta $D015

        lda #44
        sta $D000
        lda $D010
        ora #%00000001
        sta $D010

        lda #100
        sta $D001
        lda #1
        sta $D027

        rts















EYE_FRONT_DATA
; eye_front
 BYTE $00,$7E,$00
 BYTE $03,$81,$C0
 BYTE $0C,$7E,$30
 BYTE $13,$FF,$C8
 BYTE $2F,$FF,$F4
 BYTE $2F,$FF,$F4
 BYTE $5F,$FF,$FA
 BYTE $5F,$C3,$FA
 BYTE $5F,$81,$FA
 BYTE $BF,$00,$FD
 BYTE $BF,$00,$FD
 BYTE $BF,$00,$FD
 BYTE $5F,$81,$FA
 BYTE $5F,$C3,$FA
 BYTE $5F,$FF,$FA
 BYTE $2F,$FF,$F4
 BYTE $2F,$FF,$F4
 BYTE $13,$FF,$C8
 BYTE $0C,$7E,$30
 BYTE $03,$81,$C0
 BYTE $00,$7E,$00
 BYTE $00

EYE_LEFT_DATA
; eye_left
 BYTE $00,$7E,$00
 BYTE $03,$81,$C0
 BYTE $0C,$7E,$30
 BYTE $13,$FF,$C8
 BYTE $2F,$FF,$F4
 BYTE $2F,$FF,$F4
 BYTE $5F,$FF,$FA
 BYTE $5C,$7F,$FA
 BYTE $58,$3F,$FA
 BYTE $B8,$3F,$FD
 BYTE $B8,$3F,$FD
 BYTE $B8,$3F,$FD
 BYTE $58,$3F,$FA
 BYTE $5C,$7F,$FA
 BYTE $5F,$FF,$FA
 BYTE $2F,$FF,$F4
 BYTE $2F,$FF,$F4
 BYTE $13,$FF,$C8
 BYTE $0C,$7E,$30
 BYTE $03,$81,$C0
 BYTE $00,$7E,$00
 BYTE $00

EYE_RIGHT_DATA
; eye right
 BYTE $00,$7E,$00
 BYTE $03,$81,$C0
 BYTE $0C,$7E,$30
 BYTE $13,$FF,$C8
 BYTE $2F,$FF,$F4
 BYTE $2F,$FF,$F4
 BYTE $5F,$FF,$FA
 BYTE $5F,$FE,$3A
 BYTE $5F,$FC,$1A
 BYTE $BF,$FC,$1D
 BYTE $BF,$FC,$1D
 BYTE $BF,$FC,$1D
 BYTE $5F,$FC,$1A
 BYTE $5F,$FE,$3A
 BYTE $5F,$FF,$FA
 BYTE $2F,$FF,$F4
 BYTE $2F,$FF,$F4
 BYTE $13,$FF,$C8
 BYTE $0C,$7E,$30
 BYTE $03,$81,$C0
 BYTE $00,$7E,$00
 BYTE $00

