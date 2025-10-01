;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Linux)
;--------------------------------------------------------
	.module main
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _get_timing
	.globl _read_pin
	.globl _tog_pin
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
; Stack segment in internal ram
;--------------------------------------------------------
	.area SSEG
__start__stack:
	.ds	1

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
; interrupt vector
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
	call	___sdcc_external_startup
	tnz	a
	jreq	__sdcc_init_data
	jp	__sdcc_program_startup
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	main.c: 4: int8_t tog_pin(char port, char x){
;	-----------------------------------------
;	 function tog_pin
;	-----------------------------------------
_tog_pin:
	push	a
;	main.c: 9: PA_CR2 &= ~x;         // disable fast mode
	push	a
	ld	a, (0x05, sp)
	cpl	a
	ld	(0x02, sp), a
	pop	a
;	main.c: 5: switch(port){
	cp	a, #0x41
	jreq	00101$
	cp	a, #0x42
	jreq	00102$
	cp	a, #0x43
	jreq	00103$
	cp	a, #0x44
	jreq	00104$
	jp	00105$
;	main.c: 6: case 'A':
00101$:
;	main.c: 7: PA_DDR |= x;          // output
	ld	a, 0x5002
	or	a, (0x04, sp)
	ld	0x5002, a
;	main.c: 8: PA_CR1 |= x;          // push-pull
	ld	a, 0x5003
	or	a, (0x04, sp)
	ld	0x5003, a
;	main.c: 9: PA_CR2 &= ~x;         // disable fast mode
	ld	a, 0x5004
	and	a, (0x01, sp)
	ld	0x5004, a
;	main.c: 10: PA_ODR ^= x;
	ld	a, 0x5000
	xor	a, (0x04, sp)
	ld	0x5000, a
;	main.c: 11: break;
	jra	00106$
;	main.c: 12: case 'B':
00102$:
;	main.c: 13: PB_DDR |= x;          // output
	ld	a, 0x5007
	or	a, (0x04, sp)
	ld	0x5007, a
;	main.c: 14: PB_CR1 |= x;          // push-pull
	ld	a, 0x5008
	or	a, (0x04, sp)
	ld	0x5008, a
;	main.c: 15: PB_CR2 &= ~x;         // disable fast mode
	ld	a, 0x5009
	and	a, (0x01, sp)
	ld	0x5009, a
;	main.c: 16: PB_ODR ^= x;
	ld	a, 0x5005
	xor	a, (0x04, sp)
	ld	0x5005, a
;	main.c: 17: break;
	jra	00106$
;	main.c: 19: case 'C':
00103$:
;	main.c: 20: PC_DDR |= x;          // output
	ld	a, 0x500c
	or	a, (0x04, sp)
	ld	0x500c, a
;	main.c: 21: PC_CR1 |= x;          // push-pull
	ld	a, 0x500d
	or	a, (0x04, sp)
	ld	0x500d, a
;	main.c: 22: PC_CR2 &= ~x;         // disable fast mode
	ld	a, 0x500e
	and	a, (0x01, sp)
	ld	0x500e, a
;	main.c: 23: PC_ODR ^= x;
	ld	a, 0x500a
	xor	a, (0x04, sp)
	ld	0x500a, a
;	main.c: 24: break;
	jra	00106$
;	main.c: 25: case 'D':
00104$:
;	main.c: 26: PD_DDR |= x;          // output
	ld	a, 0x5011
	or	a, (0x04, sp)
	ld	0x5011, a
;	main.c: 27: PD_CR1 |= x;          // push-pull
	ld	a, 0x5012
	or	a, (0x04, sp)
	ld	0x5012, a
;	main.c: 28: PD_CR2 &= ~x;         // disable fast mode
	ld	a, 0x5013
	and	a, (0x01, sp)
	ld	0x5013, a
;	main.c: 29: PD_ODR ^= x;
	ld	a, 0x500f
	xor	a, (0x04, sp)
	ld	0x500f, a
;	main.c: 30: break;
	jra	00106$
;	main.c: 31: default:
00105$:
;	main.c: 32: return -1;
	ld	a, #0xff
;	main.c: 33: }
;	main.c: 34: return 0;
	.byte 0x21
00106$:
	clr	a
00107$:
;	main.c: 35: }
	addw	sp, #1
	popw	x
	addw	sp, #1
	jp	(x)
;	main.c: 37: int8_t read_pin(char port, int x, char floating){ 
;	-----------------------------------------
;	 function read_pin
;	-----------------------------------------
_read_pin:
	sub	sp, #9
	ldw	(0x08, sp), x
;	main.c: 39: switch(port){
	cp	a, #0x41
	jrne	00182$
	push	a
	ld	a, #0x01
	ld	(0x02, sp), a
	pop	a
	.byte 0xc5
00182$:
	clr	(0x01, sp)
00183$:
	cp	a, #0x42
	jrne	00185$
	push	a
	ld	a, #0x01
	ld	(0x03, sp), a
	pop	a
	.byte 0xc5
00185$:
	clr	(0x02, sp)
00186$:
	cp	a, #0x43
	jrne	00188$
	push	a
	ld	a, #0x01
	ld	(0x04, sp), a
	pop	a
	.byte 0xc5
00188$:
	clr	(0x03, sp)
00189$:
	sub	a, #0x44
	jrne	00191$
	inc	a
	ld	(0x04, sp), a
	.byte 0xc5
00191$:
	clr	(0x04, sp)
00192$:
;	main.c: 41: PA_DDR &= ~x;          // Input 
	ld	a, (0x09, sp)
	ld	(0x05, sp), a
	cpl	a
	ld	(0x06, sp), a
;	main.c: 38: if(floating){
	tnz	(0x0c, sp)
	jrne	00193$
	jp	00114$
00193$:
;	main.c: 39: switch(port){
	tnz	(0x01, sp)
	jrne	00101$
	tnz	(0x02, sp)
	jrne	00102$
	tnz	(0x03, sp)
	jrne	00103$
	tnz	(0x04, sp)
	jreq	00197$
	jp	00104$
00197$:
	jp	00105$
;	main.c: 40: case 'A':
00101$:
;	main.c: 41: PA_DDR &= ~x;          // Input 
	ld	a, 0x5002
	ld	(0x07, sp), a
	and	a, (0x06, sp)
	ld	(0x07, sp), a
	ldw	x, #0x5002
	ld	a, (0x07, sp)
	ld	(x), a
;	main.c: 42: PA_CR1 |= ~x;          // Pull-up 
	ld	a, 0x5003
	ld	(0x07, sp), a
	or	a, (0x06, sp)
	ld	(0x07, sp), a
	ldw	x, #0x5003
	ld	a, (0x07, sp)
	ld	(x), a
;	main.c: 43: PA_CR2 &= ~x;         // No interupt 
	ld	a, 0x5004
	ld	(0x07, sp), a
	and	a, (0x06, sp)
	ld	(0x07, sp), a
	ldw	x, #0x5004
	ld	a, (0x07, sp)
	ld	(x), a
;	main.c: 44: return (PA_IDR & x); 
	ld	a, 0x5001
	ld	(0x07, sp), a
	and	a, (0x05, sp)
	jp	00116$
;	main.c: 45: case 'B':
00102$:
;	main.c: 46: PB_DDR &= ~x;          // Input 
	ld	a, 0x5007
	ld	(0x07, sp), a
	and	a, (0x06, sp)
	ld	0x5007, a
;	main.c: 47: PB_CR1 |= ~x;          // Pull-up 
	ld	a, 0x5008
	ld	(0x07, sp), a
	or	a, (0x06, sp)
	ld	0x5008, a
;	main.c: 48: PB_CR2 &= ~x;         // No interupt 
	ld	a, 0x5009
	ld	(0x07, sp), a
	and	a, (0x06, sp)
	ld	0x5009, a
;	main.c: 49: return (PB_IDR & x); 
	ld	a, 0x5006
	ld	(0x07, sp), a
	and	a, (0x05, sp)
	jp	00116$
;	main.c: 50: case 'C':
00103$:
;	main.c: 51: PC_DDR &= ~x;          // Input 
	ld	a, 0x500c
	ld	(0x07, sp), a
	and	a, (0x06, sp)
	ld	0x500c, a
;	main.c: 52: PC_CR1 |= ~x;          // Pull-up 
	ld	a, 0x500d
	ld	(0x07, sp), a
	or	a, (0x06, sp)
	ld	0x500d, a
;	main.c: 53: PC_CR2 &= ~x;         // No interupt 
	ld	a, 0x500e
	ld	(0x07, sp), a
	and	a, (0x06, sp)
	ld	0x500e, a
;	main.c: 54: return (PC_IDR & x); 
	ld	a, 0x500b
	ld	(0x07, sp), a
	and	a, (0x05, sp)
	jp	00116$
;	main.c: 56: case 'D':
00104$:
;	main.c: 57: PD_DDR &= ~x;          // Input 
	ld	a, 0x5011
	and	a, (0x06, sp)
	ld	0x5011, a
;	main.c: 58: PD_CR1 |= ~x;          // Pull-up 
	ld	a, 0x5012
	or	a, (0x06, sp)
	ld	0x5012, a
;	main.c: 59: PD_CR2 &= ~x;         // No interupt 
	ld	a, 0x5013
	and	a, (0x06, sp)
	ld	0x5013, a
;	main.c: 60: return (PD_IDR & x); 
	ld	a, 0x5010
	ld	(0x07, sp), a
	and	a, (0x05, sp)
	jp	00116$
;	main.c: 62: default:
00105$:
;	main.c: 63: return -1;
	ld	a, #0xff
	jp	00116$
;	main.c: 64: }
00114$:
;	main.c: 69: PA_CR1 |= x;          // Pull-up 
	ld	a, (0x09, sp)
	ld	(0x07, sp), a
;	main.c: 66: switch(port){
	tnz	(0x01, sp)
	jrne	00107$
	tnz	(0x02, sp)
	jrne	00108$
	tnz	(0x03, sp)
	jrne	00109$
	tnz	(0x04, sp)
	jrne	00110$
	jra	00111$
;	main.c: 67: case 'A':
00107$:
;	main.c: 68: PA_DDR &= ~x;          // Input 
	ld	a, 0x5002
	and	a, (0x06, sp)
	ld	0x5002, a
;	main.c: 69: PA_CR1 |= x;          // Pull-up 
	ld	a, 0x5003
	or	a, (0x07, sp)
	ld	0x5003, a
;	main.c: 70: PA_CR2 &= ~x;         // No interupt 
	ld	a, 0x5004
	and	a, (0x06, sp)
	ld	0x5004, a
;	main.c: 71: return (PA_IDR & x); 
	ld	a, 0x5001
	and	a, (0x05, sp)
	jra	00116$
;	main.c: 72: case 'B':
00108$:
;	main.c: 73: PB_DDR &= ~x;          // Input 
	ld	a, 0x5007
	and	a, (0x06, sp)
	ld	0x5007, a
;	main.c: 74: PB_CR1 |= x;          // Pull-up 
	ld	a, 0x5008
	or	a, (0x07, sp)
	ld	0x5008, a
;	main.c: 75: PB_CR2 &= ~x;         // No interupt 
	ld	a, 0x5009
	and	a, (0x06, sp)
	ld	0x5009, a
;	main.c: 76: return (PB_IDR & x); 
	ld	a, 0x5006
	and	a, (0x05, sp)
	jra	00116$
;	main.c: 77: case 'C':
00109$:
;	main.c: 78: PC_DDR &= ~x;          // Input 
	ld	a, 0x500c
	and	a, (0x06, sp)
	ld	0x500c, a
;	main.c: 79: PC_CR1 |= x;          // Pull-up 
	ld	a, 0x500d
	or	a, (0x07, sp)
	ld	0x500d, a
;	main.c: 80: PC_CR2 &= ~x;         // No interupt 
	ld	a, 0x500e
	and	a, (0x06, sp)
	ld	0x500e, a
;	main.c: 81: return (PC_IDR & x); 
	ld	a, 0x500b
	and	a, (0x05, sp)
	jra	00116$
;	main.c: 83: case 'D':
00110$:
;	main.c: 84: PD_DDR &= ~x;          // Input 
	ld	a, 0x5011
	and	a, (0x06, sp)
	ld	0x5011, a
;	main.c: 85: PD_CR1 |= x;          // Pull-up 
	ld	a, 0x5012
	or	a, (0x07, sp)
	ld	0x5012, a
;	main.c: 86: PD_CR2 &= ~x;         // No interupt 
	ld	a, 0x5013
	and	a, (0x06, sp)
	ld	0x5013, a
;	main.c: 87: return (PD_IDR & x); 
	ld	a, 0x5010
	and	a, (0x05, sp)
;	main.c: 89: default:
;	main.c: 90: return -1;
;	main.c: 95: return -1;
	.byte 0xc5
00111$:
	ld	a, #0xff
00116$:
;	main.c: 96: }
	addw	sp, #9
	popw	x
	addw	sp, #1
	jp	(x)
;	main.c: 99: uint8_t get_timing(void){
;	-----------------------------------------
;	 function get_timing
;	-----------------------------------------
_get_timing:
	sub	sp, #2
;	main.c: 101: uint8_t timing = 0;
	clr	(0x01, sp)
;	main.c: 102: for(int i=3; i<7; i++){
	ld	a, #0x03
	ld	(0x02, sp), a
00110$:
	ld	a, (0x02, sp)
	cp	a, #0x07
	jrnc	00108$
;	main.c: 104: input = read_pin('C', (1 << i), 0); // Check if pin is pulled low
	clrw	x
	incw	x
	ld	a, (0x02, sp)
00143$:
	sllw	x
	dec	a
	jrne	00143$
	push	#0x00
	ld	a, #0x43
	call	_read_pin
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
;	main.c: 105: if(input < 0){ // Error checking ):
	tnzw	x
	jrpl	00105$
;	main.c: 106: while(1){
00102$:
;	main.c: 107: tog_pin('B', (1 << 5));
	push	#0x20
	ld	a, #0x42
	call	_tog_pin
;	main.c: 108: delay_ms(1000);
	ldw	x, #0x03e8
	call	_delay_ms
	jra	00102$
00105$:
;	main.c: 111: if(input == 0){ // If pulled low
	tnzw	x
	jrne	00111$
;	main.c: 112: timing |= (1 << (i-3)); // Set bit on nibble
	ld	a, (0x02, sp)
	sub	a, #0x03
	ld	xl, a
	ld	a, #0x01
	push	a
	ld	a, xl
	tnz	a
	jreq	00148$
00147$:
	sll	(1, sp)
	dec	a
	jrne	00147$
00148$:
	pop	a
	or	a, (0x01, sp)
	ld	(0x01, sp), a
00111$:
;	main.c: 102: for(int i=3; i<7; i++){
	inc	(0x02, sp)
	jra	00110$
00108$:
;	main.c: 115: return timing;
	ld	a, (0x01, sp)
;	main.c: 116: }
	addw	sp, #2
	ret
;	main.c: 119: int main() {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #4
;	main.c: 121: uint8_t armed = 0;     
	clr	(0x04, sp)
;	main.c: 123: CLK_CKDIVR = 0x00; // Dont divide clock timing
	mov	0x50c6+0, #0x00
;	main.c: 124: uint8_t timing = get_timing(); // Get dip switch settings
	call	_get_timing
	ld	(0x01, sp), a
;	main.c: 126: while(~armed){
00103$:
	clrw	x
	ld	a, (0x04, sp)
	ld	xl, a
	cplw	x
	jreq	00121$
;	main.c: 127: if(~(read_pin('C', (1 << 7), 1))){
	push	#0x01
	ldw	x, #0x0080
	ld	a, #0x43
	call	_read_pin
	ld	xl, a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	xh, a
	cplw	x
	jreq	00103$
;	main.c: 128: armed = 1;
	ld	a, #0x01
	ld	(0x04, sp), a
	jra	00103$
;	main.c: 133: while(1){
00121$:
	clr	(0x04, sp)
00112$:
;	main.c: 134: if(elapsed >= (timing*10)){ // Check if timer has gone off
	ld	a, (0x01, sp)
	clrw	x
	ld	xl, a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	ldw	(0x02, sp), x
	ld	a, (0x04, sp)
	clrw	x
	ld	xl, a
	cpw	x, (0x02, sp)
	jrslt	00110$
;	main.c: 135: tog_pin('D', (1<<4)); // Activate ignitor
	push	#0x10
	ld	a, #0x44
	call	_tog_pin
;	main.c: 136: delay_ms(5000);  // Wait 5 seconds
	ldw	x, #0x1388
	call	_delay_ms
;	main.c: 137: tog_pin('D', (1<<4)); // Deactivate to avoid damage to lipos
	push	#0x10
	ld	a, #0x44
	call	_tog_pin
;	main.c: 138: while(1);
00107$:
	jra	00107$
00110$:
;	main.c: 140: delay_ms(100); // If timer still going wait the 100 mills
	ldw	x, #0x0064
	call	_delay_ms
;	main.c: 141: elapsed++; // Another 100 mills has elapsed
	inc	(0x04, sp)
;	main.c: 142: tog_pin('B', (1 << 5)); // Blink light for ease of use
	push	#0x20
	ld	a, #0x42
	call	_tog_pin
	jra	00112$
;	main.c: 145: }
	addw	sp, #4
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
