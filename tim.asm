;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Linux)
;--------------------------------------------------------
	.module tim
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _delay_1_sec
	.globl _delay_1_ms
	.globl _delay_ms
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	tim.c: 4: void delay_1_sec(void){
;	-----------------------------------------
;	 function delay_1_sec
;	-----------------------------------------
_delay_1_sec:
;	tim.c: 5: uint8_t uif_flag = 0;
	clrw	x
;	tim.c: 6: TIM2_CR1 = TIM2_CR1 & 0xFE;
	bres	0x5300, #0
;	tim.c: 7: TIM2_PSCR = 8; // 16 MHz / 256
	mov	0x530e+0, #0x08
;	tim.c: 8: TIM2_ARRH = 0xF4;
	mov	0x530f+0, #0xf4
;	tim.c: 9: TIM2_ARRL = 0x24;
	mov	0x5310+0, #0x24
;	tim.c: 10: TIM2_SR1 = TIM2_SR1 & (0b11111110);
	bres	0x5304, #0
;	tim.c: 11: TIM2_CR1 = TIM2_CR1 | (0b00000001);
	bset	0x5300, #0
;	tim.c: 12: while(!(uif_flag)){
00101$:
	ld	a, xl
	tnz	a
	jreq	00120$
	ret
00120$:
;	tim.c: 13: uif_flag = TIM2_SR1 & (0b00000001);
	ld	a, 0x5304
	and	a, #0x01
	ld	xl, a
	jra	00101$
;	tim.c: 15: }
	ret
;	tim.c: 17: void delay_1_ms(void){
;	-----------------------------------------
;	 function delay_1_ms
;	-----------------------------------------
_delay_1_ms:
;	tim.c: 18: uint8_t uif_flag = 0;
	clrw	x
;	tim.c: 19: TIM2_CR1 = TIM2_CR1 & 0xFE;
	bres	0x5300, #0
;	tim.c: 20: TIM2_PSCR = 1; 
	mov	0x530e+0, #0x01
;	tim.c: 21: TIM2_ARRH = 0x1F;
	mov	0x530f+0, #0x1f
;	tim.c: 22: TIM2_ARRL = 0x40;
	mov	0x5310+0, #0x40
;	tim.c: 23: TIM2_SR1 &= ~0x01;
	bres	0x5304, #0
;	tim.c: 24: TIM2_SR1 = TIM2_SR1 & (0b11111110);
	bres	0x5304, #0
;	tim.c: 25: TIM2_CR1 = TIM2_CR1 | (0b00000001);
	bset	0x5300, #0
;	tim.c: 26: while(!(uif_flag)){
00101$:
	ld	a, xl
	tnz	a
	jreq	00120$
	ret
00120$:
;	tim.c: 27: uif_flag = TIM2_SR1 & (0b00000001);
	ld	a, 0x5304
	and	a, #0x01
	ld	xl, a
	jra	00101$
;	tim.c: 29: }
	ret
;	tim.c: 31: void delay_ms(int ms){
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	pushw	x
;	tim.c: 33: for (i = 0; i < ms; i++){
	clrw	x
00103$:
	cpw	x, (0x01, sp)
	jrsge	00105$
;	tim.c: 34: delay_1_ms();
	pushw	x
	call	_delay_1_ms
	popw	x
;	tim.c: 33: for (i = 0; i < ms; i++){
	incw	x
	jra	00103$
00105$:
;	tim.c: 36: }
	addw	sp, #2
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
