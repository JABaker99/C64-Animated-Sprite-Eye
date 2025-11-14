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

FRAME_STEP
        BYTE 0

COUNTER
        BYTE 0

; Description: Installs ANIMATION_ROUTINE as the system interupt request handler.
; Input: None
; Output: 
;    - $0314 is set to low byte of ANIMATION_ROUTINE
;    - $0315 is set to high byte of ANIMATION_ROUTINE
SETUP_INTERRUPT
        sei
        lda #<ANIMATION_ROUTINE
        sta $0314
        lda #>ANIMATION_ROUTINE
        sta $0315
        cli
        rts

; Description: Runs ~60 times per second and triggers animation logic.
; Input: None
; Output: None
ANIMATION_ROUTINE
        jsr UPDATE_COUNTER
        jsr UPDATE_FRAME

        jmp $EA31
        
; Description: Counts interrupts and advances FRAME_STEP every 60 ticks.
; Input: None
; Output: 
;    - COUNTER incremented each call  
;    - COUNTER reset to 0 at 60  
;    - FRAME_STEP updated (0–3 cycle)
UPDATE_COUNTER
        inc COUNTER

        lda COUNTER
        cmp #60
        bne COUNTER_DONE

        lda #0
        sta COUNTER

        inc FRAME_STEP
        lda FRAME_STEP
        and #3
        sta FRAME_STEP

; Description: Helps when couter is over and needs to jump out of UPDATE_COUNTER.
; Input: None
; Output: None
COUNTER_DONE
        rts

; Description: Chooses correct animation frame based on FRAME_STEP and updates sprite 0's pointer.
; Input: 
;    - FRAME_STEP must hold a valid value 0–3
; Output: 
;    - $07F8 is altered to a different pointer
UPDATE_FRAME
        lda FRAME_STEP
        cmp #0
        beq FRONT_FRAME
        cmp #1
        beq RIGHT_FRAME
        cmp #2
        beq FRONT_FRAME
        jmp LEFT_FRAME

; Description: Selects left-looking eye frame.
; Input: None
; Output:
;    - $07F8 has $81
LEFT_FRAME
        lda #$81
        sta $07F8
        jmp COUNTER_DONE

; Description: Selects right-looking eye frame.
; Input: None
; Output:
;    - $07F8 has $82
RIGHT_FRAME
        lda #$82
        sta $07F8
        jmp COUNTER_DONE

; Description: Selects front-looking eye frame.
; Input: None
; Output:
;    - $07F8 has $80
FRONT_FRAME
        lda #$80
        sta $07F8
        jmp COUNTER_DONE

; Description: Copies all three frames.
; Input: None
; Output:
;    - $2000 has front sprite data
;    - $2040 has left sprite data
;    - $2080 has right sprite data
COPY_SPRITE
        jsr COPY_FRONT
        jsr COPY_LEFT
        jsr COPY_RIGHT
        rts

; Description: Copies 64 bytes of front-facing eye to $2000.
; Input: 
;    - EYE_FRONT_DATA must exist.
; Output:
;    - $2000 has front sprite data added
COPY_FRONT
        ldx #0
CF_LOOP
        lda EYE_FRONT_DATA,x
        sta $2000,x
        inx
        cpx #64
        bne CF_LOOP
        rts

; Description: Copies 64 bytes of left-facing eye to $2040.
; Input: 
;    - EYE_LEFT_DATA must exist.
; Output:
;    - $2040 has left sprite data added
COPY_LEFT
        ldx #0
CL_LOOP
        lda EYE_LEFT_DATA,x
        sta $2040,x
        inx
        cpx #64
        bne CL_LOOP
        rts

; Description: Copies 64 bytes of right-facing eye to $2080.
; Input: 
;    - EYE_RIGHT_DATA must exist.
; Output:
;    - $2080 has right sprite data added
COPY_RIGHT
        ldx #0
CR_LOOP
        lda EYE_RIGHT_DATA,x
        sta $2080,x
        inx
        cpx #64
        bne CR_LOOP
        rts
; Description: Positions and enables sprite 0 and loads initial front-facing frame.
; Input: None
; Output:
;    - Sprite pointer $07F8 set to $80  
;    - $D015: sprite 0 enabled  
;    - $D000/$D010: X coordinate  
;    - $D001: Y coordinate  
;    - $D027: color updated  
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

