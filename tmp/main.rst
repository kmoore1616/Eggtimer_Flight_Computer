                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ISO C Compiler
                                      3 ; Version 4.5.0 #15242 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	
                                      7 ;--------------------------------------------------------
                                      8 ; Public variables in this module
                                      9 ;--------------------------------------------------------
                                     10 	.globl _main
                                     11 	.globl _get_timing
                                     12 	.globl _read_pin
                                     13 	.globl _tog_pin
                                     14 	.globl _delay_ms
                                     15 ;--------------------------------------------------------
                                     16 ; ram data
                                     17 ;--------------------------------------------------------
                                     18 	.area DATA
                                     19 ;--------------------------------------------------------
                                     20 ; ram data
                                     21 ;--------------------------------------------------------
                                     22 	.area INITIALIZED
                                     23 ;--------------------------------------------------------
                                     24 ; Stack segment in internal ram
                                     25 ;--------------------------------------------------------
                                     26 	.area SSEG
      000001                         27 __start__stack:
      000001                         28 	.ds	1
                                     29 
                                     30 ;--------------------------------------------------------
                                     31 ; absolute external ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area DABS (ABS)
                                     34 
                                     35 ; default segment ordering for linker
                                     36 	.area HOME
                                     37 	.area GSINIT
                                     38 	.area GSFINAL
                                     39 	.area CONST
                                     40 	.area INITIALIZER
                                     41 	.area CODE
                                     42 
                                     43 ;--------------------------------------------------------
                                     44 ; interrupt vector
                                     45 ;--------------------------------------------------------
                                     46 	.area HOME
      008000                         47 __interrupt_vect:
      008000 82 00 80 07             48 	int s_GSINIT ; reset
                                     49 ;--------------------------------------------------------
                                     50 ; global & static initialisations
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
                                     53 	.area GSINIT
                                     54 	.area GSFINAL
                                     55 	.area GSINIT
      008007 CD 83 8F         [ 4]   56 	call	___sdcc_external_startup
      00800A 4D               [ 1]   57 	tnz	a
      00800B 27 03            [ 1]   58 	jreq	__sdcc_init_data
      00800D CC 80 04         [ 2]   59 	jp	__sdcc_program_startup
      008010                         60 __sdcc_init_data:
                                     61 ; stm8_genXINIT() start
      008010 AE 00 00         [ 2]   62 	ldw x, #l_DATA
      008013 27 07            [ 1]   63 	jreq	00002$
      008015                         64 00001$:
      008015 72 4F 00 00      [ 1]   65 	clr (s_DATA - 1, x)
      008019 5A               [ 2]   66 	decw x
      00801A 26 F9            [ 1]   67 	jrne	00001$
      00801C                         68 00002$:
      00801C AE 00 00         [ 2]   69 	ldw	x, #l_INITIALIZER
      00801F 27 09            [ 1]   70 	jreq	00004$
      008021                         71 00003$:
      008021 D6 80 2C         [ 1]   72 	ld	a, (s_INITIALIZER - 1, x)
      008024 D7 00 00         [ 1]   73 	ld	(s_INITIALIZED - 1, x), a
      008027 5A               [ 2]   74 	decw	x
      008028 26 F7            [ 1]   75 	jrne	00003$
      00802A                         76 00004$:
                                     77 ; stm8_genXINIT() end
                                     78 	.area GSFINAL
      00802A CC 80 04         [ 2]   79 	jp	__sdcc_program_startup
                                     80 ;--------------------------------------------------------
                                     81 ; Home
                                     82 ;--------------------------------------------------------
                                     83 	.area HOME
                                     84 	.area HOME
      008004                         85 __sdcc_program_startup:
      008004 CC 82 D1         [ 2]   86 	jp	_main
                                     87 ;	return from main will return to caller
                                     88 ;--------------------------------------------------------
                                     89 ; code
                                     90 ;--------------------------------------------------------
                                     91 	.area CODE
                                     92 ;	main.c: 4: int8_t tog_pin(char port, char x){
                                     93 ;	-----------------------------------------
                                     94 ;	 function tog_pin
                                     95 ;	-----------------------------------------
      00802D                         96 _tog_pin:
      00802D 88               [ 1]   97 	push	a
                                     98 ;	main.c: 9: PA_CR2 &= ~x;         // disable fast mode
      00802E 88               [ 1]   99 	push	a
      00802F 7B 05            [ 1]  100 	ld	a, (0x05, sp)
      008031 43               [ 1]  101 	cpl	a
      008032 6B 02            [ 1]  102 	ld	(0x02, sp), a
      008034 84               [ 1]  103 	pop	a
                                    104 ;	main.c: 5: switch(port){
      008035 A1 41            [ 1]  105 	cp	a, #0x41
      008037 27 0F            [ 1]  106 	jreq	00101$
      008039 A1 42            [ 1]  107 	cp	a, #0x42
      00803B 27 2D            [ 1]  108 	jreq	00102$
      00803D A1 43            [ 1]  109 	cp	a, #0x43
      00803F 27 4B            [ 1]  110 	jreq	00103$
      008041 A1 44            [ 1]  111 	cp	a, #0x44
      008043 27 69            [ 1]  112 	jreq	00104$
      008045 CC 80 D0         [ 2]  113 	jp	00105$
                                    114 ;	main.c: 6: case 'A':
      008048                        115 00101$:
                                    116 ;	main.c: 7: PA_DDR |= x;          // output
      008048 C6 50 02         [ 1]  117 	ld	a, 0x5002
      00804B 1A 04            [ 1]  118 	or	a, (0x04, sp)
      00804D C7 50 02         [ 1]  119 	ld	0x5002, a
                                    120 ;	main.c: 8: PA_CR1 |= x;          // push-pull
      008050 C6 50 03         [ 1]  121 	ld	a, 0x5003
      008053 1A 04            [ 1]  122 	or	a, (0x04, sp)
      008055 C7 50 03         [ 1]  123 	ld	0x5003, a
                                    124 ;	main.c: 9: PA_CR2 &= ~x;         // disable fast mode
      008058 C6 50 04         [ 1]  125 	ld	a, 0x5004
      00805B 14 01            [ 1]  126 	and	a, (0x01, sp)
      00805D C7 50 04         [ 1]  127 	ld	0x5004, a
                                    128 ;	main.c: 10: PA_ODR ^= x;
      008060 C6 50 00         [ 1]  129 	ld	a, 0x5000
      008063 18 04            [ 1]  130 	xor	a, (0x04, sp)
      008065 C7 50 00         [ 1]  131 	ld	0x5000, a
                                    132 ;	main.c: 11: break;
      008068 20 69            [ 2]  133 	jra	00106$
                                    134 ;	main.c: 12: case 'B':
      00806A                        135 00102$:
                                    136 ;	main.c: 13: PB_DDR |= x;          // output
      00806A C6 50 07         [ 1]  137 	ld	a, 0x5007
      00806D 1A 04            [ 1]  138 	or	a, (0x04, sp)
      00806F C7 50 07         [ 1]  139 	ld	0x5007, a
                                    140 ;	main.c: 14: PB_CR1 |= x;          // push-pull
      008072 C6 50 08         [ 1]  141 	ld	a, 0x5008
      008075 1A 04            [ 1]  142 	or	a, (0x04, sp)
      008077 C7 50 08         [ 1]  143 	ld	0x5008, a
                                    144 ;	main.c: 15: PB_CR2 &= ~x;         // disable fast mode
      00807A C6 50 09         [ 1]  145 	ld	a, 0x5009
      00807D 14 01            [ 1]  146 	and	a, (0x01, sp)
      00807F C7 50 09         [ 1]  147 	ld	0x5009, a
                                    148 ;	main.c: 16: PB_ODR ^= x;
      008082 C6 50 05         [ 1]  149 	ld	a, 0x5005
      008085 18 04            [ 1]  150 	xor	a, (0x04, sp)
      008087 C7 50 05         [ 1]  151 	ld	0x5005, a
                                    152 ;	main.c: 17: break;
      00808A 20 47            [ 2]  153 	jra	00106$
                                    154 ;	main.c: 19: case 'C':
      00808C                        155 00103$:
                                    156 ;	main.c: 20: PC_DDR |= x;          // output
      00808C C6 50 0C         [ 1]  157 	ld	a, 0x500c
      00808F 1A 04            [ 1]  158 	or	a, (0x04, sp)
      008091 C7 50 0C         [ 1]  159 	ld	0x500c, a
                                    160 ;	main.c: 21: PC_CR1 |= x;          // push-pull
      008094 C6 50 0D         [ 1]  161 	ld	a, 0x500d
      008097 1A 04            [ 1]  162 	or	a, (0x04, sp)
      008099 C7 50 0D         [ 1]  163 	ld	0x500d, a
                                    164 ;	main.c: 22: PC_CR2 &= ~x;         // disable fast mode
      00809C C6 50 0E         [ 1]  165 	ld	a, 0x500e
      00809F 14 01            [ 1]  166 	and	a, (0x01, sp)
      0080A1 C7 50 0E         [ 1]  167 	ld	0x500e, a
                                    168 ;	main.c: 23: PC_ODR ^= x;
      0080A4 C6 50 0A         [ 1]  169 	ld	a, 0x500a
      0080A7 18 04            [ 1]  170 	xor	a, (0x04, sp)
      0080A9 C7 50 0A         [ 1]  171 	ld	0x500a, a
                                    172 ;	main.c: 24: break;
      0080AC 20 25            [ 2]  173 	jra	00106$
                                    174 ;	main.c: 25: case 'D':
      0080AE                        175 00104$:
                                    176 ;	main.c: 26: PD_DDR |= x;          // output
      0080AE C6 50 11         [ 1]  177 	ld	a, 0x5011
      0080B1 1A 04            [ 1]  178 	or	a, (0x04, sp)
      0080B3 C7 50 11         [ 1]  179 	ld	0x5011, a
                                    180 ;	main.c: 27: PD_CR1 |= x;          // push-pull
      0080B6 C6 50 12         [ 1]  181 	ld	a, 0x5012
      0080B9 1A 04            [ 1]  182 	or	a, (0x04, sp)
      0080BB C7 50 12         [ 1]  183 	ld	0x5012, a
                                    184 ;	main.c: 28: PD_CR2 &= ~x;         // disable fast mode
      0080BE C6 50 13         [ 1]  185 	ld	a, 0x5013
      0080C1 14 01            [ 1]  186 	and	a, (0x01, sp)
      0080C3 C7 50 13         [ 1]  187 	ld	0x5013, a
                                    188 ;	main.c: 29: PD_ODR ^= x;
      0080C6 C6 50 0F         [ 1]  189 	ld	a, 0x500f
      0080C9 18 04            [ 1]  190 	xor	a, (0x04, sp)
      0080CB C7 50 0F         [ 1]  191 	ld	0x500f, a
                                    192 ;	main.c: 30: break;
      0080CE 20 03            [ 2]  193 	jra	00106$
                                    194 ;	main.c: 31: default:
      0080D0                        195 00105$:
                                    196 ;	main.c: 32: return -1;
      0080D0 A6 FF            [ 1]  197 	ld	a, #0xff
                                    198 ;	main.c: 33: }
                                    199 ;	main.c: 34: return 0;
      0080D2 21                     200 	.byte 0x21
      0080D3                        201 00106$:
      0080D3 4F               [ 1]  202 	clr	a
      0080D4                        203 00107$:
                                    204 ;	main.c: 35: }
      0080D4 5B 01            [ 2]  205 	addw	sp, #1
      0080D6 85               [ 2]  206 	popw	x
      0080D7 5B 01            [ 2]  207 	addw	sp, #1
      0080D9 FC               [ 2]  208 	jp	(x)
                                    209 ;	main.c: 37: int8_t read_pin(char port, int x, char floating){ 
                                    210 ;	-----------------------------------------
                                    211 ;	 function read_pin
                                    212 ;	-----------------------------------------
      0080DA                        213 _read_pin:
      0080DA 52 09            [ 2]  214 	sub	sp, #9
      0080DC 1F 08            [ 2]  215 	ldw	(0x08, sp), x
                                    216 ;	main.c: 39: switch(port){
      0080DE A1 41            [ 1]  217 	cp	a, #0x41
      0080E0 26 07            [ 1]  218 	jrne	00182$
      0080E2 88               [ 1]  219 	push	a
      0080E3 A6 01            [ 1]  220 	ld	a, #0x01
      0080E5 6B 02            [ 1]  221 	ld	(0x02, sp), a
      0080E7 84               [ 1]  222 	pop	a
      0080E8 C5                     223 	.byte 0xc5
      0080E9                        224 00182$:
      0080E9 0F 01            [ 1]  225 	clr	(0x01, sp)
      0080EB                        226 00183$:
      0080EB A1 42            [ 1]  227 	cp	a, #0x42
      0080ED 26 07            [ 1]  228 	jrne	00185$
      0080EF 88               [ 1]  229 	push	a
      0080F0 A6 01            [ 1]  230 	ld	a, #0x01
      0080F2 6B 03            [ 1]  231 	ld	(0x03, sp), a
      0080F4 84               [ 1]  232 	pop	a
      0080F5 C5                     233 	.byte 0xc5
      0080F6                        234 00185$:
      0080F6 0F 02            [ 1]  235 	clr	(0x02, sp)
      0080F8                        236 00186$:
      0080F8 A1 43            [ 1]  237 	cp	a, #0x43
      0080FA 26 07            [ 1]  238 	jrne	00188$
      0080FC 88               [ 1]  239 	push	a
      0080FD A6 01            [ 1]  240 	ld	a, #0x01
      0080FF 6B 04            [ 1]  241 	ld	(0x04, sp), a
      008101 84               [ 1]  242 	pop	a
      008102 C5                     243 	.byte 0xc5
      008103                        244 00188$:
      008103 0F 03            [ 1]  245 	clr	(0x03, sp)
      008105                        246 00189$:
      008105 A0 44            [ 1]  247 	sub	a, #0x44
      008107 26 04            [ 1]  248 	jrne	00191$
      008109 4C               [ 1]  249 	inc	a
      00810A 6B 04            [ 1]  250 	ld	(0x04, sp), a
      00810C C5                     251 	.byte 0xc5
      00810D                        252 00191$:
      00810D 0F 04            [ 1]  253 	clr	(0x04, sp)
      00810F                        254 00192$:
                                    255 ;	main.c: 41: PA_DDR &= ~x;          // Input 
      00810F 7B 09            [ 1]  256 	ld	a, (0x09, sp)
      008111 6B 05            [ 1]  257 	ld	(0x05, sp), a
      008113 43               [ 1]  258 	cpl	a
      008114 6B 06            [ 1]  259 	ld	(0x06, sp), a
                                    260 ;	main.c: 38: if(floating){
      008116 0D 0C            [ 1]  261 	tnz	(0x0c, sp)
      008118 26 03            [ 1]  262 	jrne	00193$
      00811A CC 81 E1         [ 2]  263 	jp	00114$
      00811D                        264 00193$:
                                    265 ;	main.c: 39: switch(port){
      00811D 0D 01            [ 1]  266 	tnz	(0x01, sp)
      00811F 26 12            [ 1]  267 	jrne	00101$
      008121 0D 02            [ 1]  268 	tnz	(0x02, sp)
      008123 26 45            [ 1]  269 	jrne	00102$
      008125 0D 03            [ 1]  270 	tnz	(0x03, sp)
      008127 26 69            [ 1]  271 	jrne	00103$
      008129 0D 04            [ 1]  272 	tnz	(0x04, sp)
      00812B 27 03            [ 1]  273 	jreq	00197$
      00812D CC 81 BA         [ 2]  274 	jp	00104$
      008130                        275 00197$:
      008130 CC 81 DC         [ 2]  276 	jp	00105$
                                    277 ;	main.c: 40: case 'A':
      008133                        278 00101$:
                                    279 ;	main.c: 41: PA_DDR &= ~x;          // Input 
      008133 C6 50 02         [ 1]  280 	ld	a, 0x5002
      008136 6B 07            [ 1]  281 	ld	(0x07, sp), a
      008138 14 06            [ 1]  282 	and	a, (0x06, sp)
      00813A 6B 07            [ 1]  283 	ld	(0x07, sp), a
      00813C AE 50 02         [ 2]  284 	ldw	x, #0x5002
      00813F 7B 07            [ 1]  285 	ld	a, (0x07, sp)
      008141 F7               [ 1]  286 	ld	(x), a
                                    287 ;	main.c: 42: PA_CR1 &= ~x;          // Pull-up 
      008142 C6 50 03         [ 1]  288 	ld	a, 0x5003
      008145 6B 07            [ 1]  289 	ld	(0x07, sp), a
      008147 14 06            [ 1]  290 	and	a, (0x06, sp)
      008149 6B 07            [ 1]  291 	ld	(0x07, sp), a
      00814B AE 50 03         [ 2]  292 	ldw	x, #0x5003
      00814E 7B 07            [ 1]  293 	ld	a, (0x07, sp)
      008150 F7               [ 1]  294 	ld	(x), a
                                    295 ;	main.c: 43: PA_CR2 &= ~x;         // No interupt 
      008151 C6 50 04         [ 1]  296 	ld	a, 0x5004
      008154 6B 07            [ 1]  297 	ld	(0x07, sp), a
      008156 14 06            [ 1]  298 	and	a, (0x06, sp)
      008158 6B 07            [ 1]  299 	ld	(0x07, sp), a
      00815A AE 50 04         [ 2]  300 	ldw	x, #0x5004
      00815D 7B 07            [ 1]  301 	ld	a, (0x07, sp)
      00815F F7               [ 1]  302 	ld	(x), a
                                    303 ;	main.c: 44: return (PA_IDR & x); 
      008160 C6 50 01         [ 1]  304 	ld	a, 0x5001
      008163 6B 07            [ 1]  305 	ld	(0x07, sp), a
      008165 14 05            [ 1]  306 	and	a, (0x05, sp)
      008167 CC 82 74         [ 2]  307 	jp	00116$
                                    308 ;	main.c: 45: case 'B':
      00816A                        309 00102$:
                                    310 ;	main.c: 46: PB_DDR &= ~x;          // Input 
      00816A C6 50 07         [ 1]  311 	ld	a, 0x5007
      00816D 6B 07            [ 1]  312 	ld	(0x07, sp), a
      00816F 14 06            [ 1]  313 	and	a, (0x06, sp)
      008171 C7 50 07         [ 1]  314 	ld	0x5007, a
                                    315 ;	main.c: 47: PB_CR1 &= ~x;          // Pull-up 
      008174 C6 50 08         [ 1]  316 	ld	a, 0x5008
      008177 6B 07            [ 1]  317 	ld	(0x07, sp), a
      008179 14 06            [ 1]  318 	and	a, (0x06, sp)
      00817B C7 50 08         [ 1]  319 	ld	0x5008, a
                                    320 ;	main.c: 48: PB_CR2 &= ~x;         // No interupt 
      00817E C6 50 09         [ 1]  321 	ld	a, 0x5009
      008181 6B 07            [ 1]  322 	ld	(0x07, sp), a
      008183 14 06            [ 1]  323 	and	a, (0x06, sp)
      008185 C7 50 09         [ 1]  324 	ld	0x5009, a
                                    325 ;	main.c: 49: return (PB_IDR & x); 
      008188 C6 50 06         [ 1]  326 	ld	a, 0x5006
      00818B 6B 07            [ 1]  327 	ld	(0x07, sp), a
      00818D 14 05            [ 1]  328 	and	a, (0x05, sp)
      00818F CC 82 74         [ 2]  329 	jp	00116$
                                    330 ;	main.c: 50: case 'C':
      008192                        331 00103$:
                                    332 ;	main.c: 51: PC_DDR &= ~x;          // Input 
      008192 C6 50 0C         [ 1]  333 	ld	a, 0x500c
      008195 6B 07            [ 1]  334 	ld	(0x07, sp), a
      008197 14 06            [ 1]  335 	and	a, (0x06, sp)
      008199 C7 50 0C         [ 1]  336 	ld	0x500c, a
                                    337 ;	main.c: 52: PC_CR1 &= ~x;          // Pull-up 
      00819C C6 50 0D         [ 1]  338 	ld	a, 0x500d
      00819F 6B 07            [ 1]  339 	ld	(0x07, sp), a
      0081A1 14 06            [ 1]  340 	and	a, (0x06, sp)
      0081A3 C7 50 0D         [ 1]  341 	ld	0x500d, a
                                    342 ;	main.c: 53: PC_CR2 &= ~x;         // No interupt 
      0081A6 C6 50 0E         [ 1]  343 	ld	a, 0x500e
      0081A9 6B 07            [ 1]  344 	ld	(0x07, sp), a
      0081AB 14 06            [ 1]  345 	and	a, (0x06, sp)
      0081AD C7 50 0E         [ 1]  346 	ld	0x500e, a
                                    347 ;	main.c: 54: return (PC_IDR & x); 
      0081B0 C6 50 0B         [ 1]  348 	ld	a, 0x500b
      0081B3 6B 07            [ 1]  349 	ld	(0x07, sp), a
      0081B5 14 05            [ 1]  350 	and	a, (0x05, sp)
      0081B7 CC 82 74         [ 2]  351 	jp	00116$
                                    352 ;	main.c: 56: case 'D':
      0081BA                        353 00104$:
                                    354 ;	main.c: 57: PD_DDR &= ~x;          // Input 
      0081BA C6 50 11         [ 1]  355 	ld	a, 0x5011
      0081BD 14 06            [ 1]  356 	and	a, (0x06, sp)
      0081BF C7 50 11         [ 1]  357 	ld	0x5011, a
                                    358 ;	main.c: 58: PD_CR1 &= ~x;          // Pull-up 
      0081C2 C6 50 12         [ 1]  359 	ld	a, 0x5012
      0081C5 14 06            [ 1]  360 	and	a, (0x06, sp)
      0081C7 C7 50 12         [ 1]  361 	ld	0x5012, a
                                    362 ;	main.c: 59: PD_CR2 &= ~x;         // No interupt 
      0081CA C6 50 13         [ 1]  363 	ld	a, 0x5013
      0081CD 14 06            [ 1]  364 	and	a, (0x06, sp)
      0081CF C7 50 13         [ 1]  365 	ld	0x5013, a
                                    366 ;	main.c: 60: return (PD_IDR & x); 
      0081D2 C6 50 10         [ 1]  367 	ld	a, 0x5010
      0081D5 6B 07            [ 1]  368 	ld	(0x07, sp), a
      0081D7 14 05            [ 1]  369 	and	a, (0x05, sp)
      0081D9 CC 82 74         [ 2]  370 	jp	00116$
                                    371 ;	main.c: 62: default:
      0081DC                        372 00105$:
                                    373 ;	main.c: 63: return -1;
      0081DC A6 FF            [ 1]  374 	ld	a, #0xff
      0081DE CC 82 74         [ 2]  375 	jp	00116$
                                    376 ;	main.c: 64: }
      0081E1                        377 00114$:
                                    378 ;	main.c: 69: PA_CR1 |= x;          // Pull-up 
      0081E1 7B 09            [ 1]  379 	ld	a, (0x09, sp)
      0081E3 6B 07            [ 1]  380 	ld	(0x07, sp), a
                                    381 ;	main.c: 66: switch(port){
      0081E5 0D 01            [ 1]  382 	tnz	(0x01, sp)
      0081E7 26 0E            [ 1]  383 	jrne	00107$
      0081E9 0D 02            [ 1]  384 	tnz	(0x02, sp)
      0081EB 26 29            [ 1]  385 	jrne	00108$
      0081ED 0D 03            [ 1]  386 	tnz	(0x03, sp)
      0081EF 26 44            [ 1]  387 	jrne	00109$
      0081F1 0D 04            [ 1]  388 	tnz	(0x04, sp)
      0081F3 26 5F            [ 1]  389 	jrne	00110$
      0081F5 20 7B            [ 2]  390 	jra	00111$
                                    391 ;	main.c: 67: case 'A':
      0081F7                        392 00107$:
                                    393 ;	main.c: 68: PA_DDR &= ~x;          // Input 
      0081F7 C6 50 02         [ 1]  394 	ld	a, 0x5002
      0081FA 14 06            [ 1]  395 	and	a, (0x06, sp)
      0081FC C7 50 02         [ 1]  396 	ld	0x5002, a
                                    397 ;	main.c: 69: PA_CR1 |= x;          // Pull-up 
      0081FF C6 50 03         [ 1]  398 	ld	a, 0x5003
      008202 1A 07            [ 1]  399 	or	a, (0x07, sp)
      008204 C7 50 03         [ 1]  400 	ld	0x5003, a
                                    401 ;	main.c: 70: PA_CR2 &= ~x;         // No interupt 
      008207 C6 50 04         [ 1]  402 	ld	a, 0x5004
      00820A 14 06            [ 1]  403 	and	a, (0x06, sp)
      00820C C7 50 04         [ 1]  404 	ld	0x5004, a
                                    405 ;	main.c: 71: return (PA_IDR & x); 
      00820F C6 50 01         [ 1]  406 	ld	a, 0x5001
      008212 14 05            [ 1]  407 	and	a, (0x05, sp)
      008214 20 5E            [ 2]  408 	jra	00116$
                                    409 ;	main.c: 72: case 'B':
      008216                        410 00108$:
                                    411 ;	main.c: 73: PB_DDR &= ~x;          // Input 
      008216 C6 50 07         [ 1]  412 	ld	a, 0x5007
      008219 14 06            [ 1]  413 	and	a, (0x06, sp)
      00821B C7 50 07         [ 1]  414 	ld	0x5007, a
                                    415 ;	main.c: 74: PB_CR1 |= x;          // Pull-up 
      00821E C6 50 08         [ 1]  416 	ld	a, 0x5008
      008221 1A 07            [ 1]  417 	or	a, (0x07, sp)
      008223 C7 50 08         [ 1]  418 	ld	0x5008, a
                                    419 ;	main.c: 75: PB_CR2 &= ~x;         // No interupt 
      008226 C6 50 09         [ 1]  420 	ld	a, 0x5009
      008229 14 06            [ 1]  421 	and	a, (0x06, sp)
      00822B C7 50 09         [ 1]  422 	ld	0x5009, a
                                    423 ;	main.c: 76: return (PB_IDR & x); 
      00822E C6 50 06         [ 1]  424 	ld	a, 0x5006
      008231 14 05            [ 1]  425 	and	a, (0x05, sp)
      008233 20 3F            [ 2]  426 	jra	00116$
                                    427 ;	main.c: 77: case 'C':
      008235                        428 00109$:
                                    429 ;	main.c: 78: PC_DDR &= ~x;          // Input 
      008235 C6 50 0C         [ 1]  430 	ld	a, 0x500c
      008238 14 06            [ 1]  431 	and	a, (0x06, sp)
      00823A C7 50 0C         [ 1]  432 	ld	0x500c, a
                                    433 ;	main.c: 79: PC_CR1 |= x;          // Pull-up 
      00823D C6 50 0D         [ 1]  434 	ld	a, 0x500d
      008240 1A 07            [ 1]  435 	or	a, (0x07, sp)
      008242 C7 50 0D         [ 1]  436 	ld	0x500d, a
                                    437 ;	main.c: 80: PC_CR2 &= ~x;         // No interupt 
      008245 C6 50 0E         [ 1]  438 	ld	a, 0x500e
      008248 14 06            [ 1]  439 	and	a, (0x06, sp)
      00824A C7 50 0E         [ 1]  440 	ld	0x500e, a
                                    441 ;	main.c: 81: return (PC_IDR & x); 
      00824D C6 50 0B         [ 1]  442 	ld	a, 0x500b
      008250 14 05            [ 1]  443 	and	a, (0x05, sp)
      008252 20 20            [ 2]  444 	jra	00116$
                                    445 ;	main.c: 83: case 'D':
      008254                        446 00110$:
                                    447 ;	main.c: 84: PD_DDR &= ~x;          // Input 
      008254 C6 50 11         [ 1]  448 	ld	a, 0x5011
      008257 14 06            [ 1]  449 	and	a, (0x06, sp)
      008259 C7 50 11         [ 1]  450 	ld	0x5011, a
                                    451 ;	main.c: 85: PD_CR1 |= x;          // Pull-up 
      00825C C6 50 12         [ 1]  452 	ld	a, 0x5012
      00825F 1A 07            [ 1]  453 	or	a, (0x07, sp)
      008261 C7 50 12         [ 1]  454 	ld	0x5012, a
                                    455 ;	main.c: 86: PD_CR2 &= ~x;         // No interupt 
      008264 C6 50 13         [ 1]  456 	ld	a, 0x5013
      008267 14 06            [ 1]  457 	and	a, (0x06, sp)
      008269 C7 50 13         [ 1]  458 	ld	0x5013, a
                                    459 ;	main.c: 87: return (PD_IDR & x); 
      00826C C6 50 10         [ 1]  460 	ld	a, 0x5010
      00826F 14 05            [ 1]  461 	and	a, (0x05, sp)
                                    462 ;	main.c: 89: default:
                                    463 ;	main.c: 90: return -1;
                                    464 ;	main.c: 95: return -1;
      008271 C5                     465 	.byte 0xc5
      008272                        466 00111$:
      008272 A6 FF            [ 1]  467 	ld	a, #0xff
      008274                        468 00116$:
                                    469 ;	main.c: 96: }
      008274 5B 09            [ 2]  470 	addw	sp, #9
      008276 85               [ 2]  471 	popw	x
      008277 5B 01            [ 2]  472 	addw	sp, #1
      008279 FC               [ 2]  473 	jp	(x)
                                    474 ;	main.c: 99: uint8_t get_timing(void){
                                    475 ;	-----------------------------------------
                                    476 ;	 function get_timing
                                    477 ;	-----------------------------------------
      00827A                        478 _get_timing:
      00827A 52 02            [ 2]  479 	sub	sp, #2
                                    480 ;	main.c: 101: uint8_t timing = 0;
      00827C 0F 01            [ 1]  481 	clr	(0x01, sp)
                                    482 ;	main.c: 102: for(int i=3; i<7; i++){
      00827E A6 03            [ 1]  483 	ld	a, #0x03
      008280 6B 02            [ 1]  484 	ld	(0x02, sp), a
      008282                        485 00110$:
      008282 7B 02            [ 1]  486 	ld	a, (0x02, sp)
      008284 A1 07            [ 1]  487 	cp	a, #0x07
      008286 24 44            [ 1]  488 	jrnc	00108$
                                    489 ;	main.c: 104: input = read_pin('C', (1 << i), 0); // Check if pin is pulled low
      008288 5F               [ 1]  490 	clrw	x
      008289 5C               [ 1]  491 	incw	x
      00828A 7B 02            [ 1]  492 	ld	a, (0x02, sp)
      00828C                        493 00143$:
      00828C 58               [ 2]  494 	sllw	x
      00828D 4A               [ 1]  495 	dec	a
      00828E 26 FC            [ 1]  496 	jrne	00143$
      008290 4B 00            [ 1]  497 	push	#0x00
      008292 A6 43            [ 1]  498 	ld	a, #0x43
      008294 CD 80 DA         [ 4]  499 	call	_read_pin
      008297 97               [ 1]  500 	ld	xl, a
      008298 49               [ 1]  501 	rlc	a
      008299 4F               [ 1]  502 	clr	a
      00829A A2 00            [ 1]  503 	sbc	a, #0x00
      00829C 95               [ 1]  504 	ld	xh, a
                                    505 ;	main.c: 105: if(input < 0){ // Error checking ):
      00829D 5D               [ 2]  506 	tnzw	x
      00829E 2A 0F            [ 1]  507 	jrpl	00105$
                                    508 ;	main.c: 106: while(1){
      0082A0                        509 00102$:
                                    510 ;	main.c: 107: tog_pin('B', (1 << 5));
      0082A0 4B 20            [ 1]  511 	push	#0x20
      0082A2 A6 42            [ 1]  512 	ld	a, #0x42
      0082A4 CD 80 2D         [ 4]  513 	call	_tog_pin
                                    514 ;	main.c: 108: delay_ms(1000);
      0082A7 AE 03 E8         [ 2]  515 	ldw	x, #0x03e8
      0082AA CD 83 7E         [ 4]  516 	call	_delay_ms
      0082AD 20 F1            [ 2]  517 	jra	00102$
      0082AF                        518 00105$:
                                    519 ;	main.c: 111: if(input == 0){ // If pulled low
      0082AF 5D               [ 2]  520 	tnzw	x
      0082B0 26 16            [ 1]  521 	jrne	00111$
                                    522 ;	main.c: 112: timing |= (1 << (i-3)); // Set bit on nibble
      0082B2 7B 02            [ 1]  523 	ld	a, (0x02, sp)
      0082B4 A0 03            [ 1]  524 	sub	a, #0x03
      0082B6 97               [ 1]  525 	ld	xl, a
      0082B7 A6 01            [ 1]  526 	ld	a, #0x01
      0082B9 88               [ 1]  527 	push	a
      0082BA 9F               [ 1]  528 	ld	a, xl
      0082BB 4D               [ 1]  529 	tnz	a
      0082BC 27 05            [ 1]  530 	jreq	00148$
      0082BE                        531 00147$:
      0082BE 08 01            [ 1]  532 	sll	(1, sp)
      0082C0 4A               [ 1]  533 	dec	a
      0082C1 26 FB            [ 1]  534 	jrne	00147$
      0082C3                        535 00148$:
      0082C3 84               [ 1]  536 	pop	a
      0082C4 1A 01            [ 1]  537 	or	a, (0x01, sp)
      0082C6 6B 01            [ 1]  538 	ld	(0x01, sp), a
      0082C8                        539 00111$:
                                    540 ;	main.c: 102: for(int i=3; i<7; i++){
      0082C8 0C 02            [ 1]  541 	inc	(0x02, sp)
      0082CA 20 B6            [ 2]  542 	jra	00110$
      0082CC                        543 00108$:
                                    544 ;	main.c: 115: return timing;
      0082CC 7B 01            [ 1]  545 	ld	a, (0x01, sp)
                                    546 ;	main.c: 116: }
      0082CE 5B 02            [ 2]  547 	addw	sp, #2
      0082D0 81               [ 4]  548 	ret
                                    549 ;	main.c: 119: int main() {
                                    550 ;	-----------------------------------------
                                    551 ;	 function main
                                    552 ;	-----------------------------------------
      0082D1                        553 _main:
      0082D1 52 04            [ 2]  554 	sub	sp, #4
                                    555 ;	main.c: 123: CLK_CKDIVR = 0x00; // Dont divide clock timing
      0082D3 35 00 50 C6      [ 1]  556 	mov	0x50c6+0, #0x00
                                    557 ;	main.c: 124: uint8_t timing = get_timing(); // Get dip switch settings
      0082D7 CD 82 7A         [ 4]  558 	call	_get_timing
      0082DA 6B 01            [ 1]  559 	ld	(0x01, sp), a
                                    560 ;	main.c: 126: while(read_pin('C', (1<<7), 1)); // Hold countdown until launch event detected (pin c7 DCed during launch)
      0082DC                        561 00101$:
      0082DC 4B 01            [ 1]  562 	push	#0x01
      0082DE AE 00 80         [ 2]  563 	ldw	x, #0x0080
      0082E1 A6 43            [ 1]  564 	ld	a, #0x43
      0082E3 CD 80 DA         [ 4]  565 	call	_read_pin
      0082E6 4D               [ 1]  566 	tnz	a
      0082E7 26 F3            [ 1]  567 	jrne	00101$
                                    568 ;	main.c: 129: while(1){
      0082E9 0F 04            [ 1]  569 	clr	(0x04, sp)
      0082EB                        570 00110$:
                                    571 ;	main.c: 130: if(elapsed >= (timing*10)){ // Check if timer has gone off
      0082EB 7B 01            [ 1]  572 	ld	a, (0x01, sp)
      0082ED 5F               [ 1]  573 	clrw	x
      0082EE 97               [ 1]  574 	ld	xl, a
      0082EF 89               [ 2]  575 	pushw	x
      0082F0 58               [ 2]  576 	sllw	x
      0082F1 58               [ 2]  577 	sllw	x
      0082F2 72 FB 01         [ 2]  578 	addw	x, (1, sp)
      0082F5 58               [ 2]  579 	sllw	x
      0082F6 5B 02            [ 2]  580 	addw	sp, #2
      0082F8 1F 02            [ 2]  581 	ldw	(0x02, sp), x
      0082FA 7B 04            [ 1]  582 	ld	a, (0x04, sp)
      0082FC 5F               [ 1]  583 	clrw	x
      0082FD 97               [ 1]  584 	ld	xl, a
      0082FE 13 02            [ 2]  585 	cpw	x, (0x02, sp)
      008300 2F 16            [ 1]  586 	jrslt	00108$
                                    587 ;	main.c: 131: tog_pin('D', (1<<4)); // Activate ignitor
      008302 4B 10            [ 1]  588 	push	#0x10
      008304 A6 44            [ 1]  589 	ld	a, #0x44
      008306 CD 80 2D         [ 4]  590 	call	_tog_pin
                                    591 ;	main.c: 132: delay_ms(5000);  // Wait 5 seconds
      008309 AE 13 88         [ 2]  592 	ldw	x, #0x1388
      00830C CD 83 7E         [ 4]  593 	call	_delay_ms
                                    594 ;	main.c: 133: tog_pin('D', (1<<4)); // Deactivate to avoid damage to lipos
      00830F 4B 10            [ 1]  595 	push	#0x10
      008311 A6 44            [ 1]  596 	ld	a, #0x44
      008313 CD 80 2D         [ 4]  597 	call	_tog_pin
                                    598 ;	main.c: 134: while(1); // Program finished, 
      008316                        599 00105$:
      008316 20 FE            [ 2]  600 	jra	00105$
      008318                        601 00108$:
                                    602 ;	main.c: 136: delay_ms(100); // If timer still going wait the 100 mills
      008318 AE 00 64         [ 2]  603 	ldw	x, #0x0064
      00831B CD 83 7E         [ 4]  604 	call	_delay_ms
                                    605 ;	main.c: 137: elapsed++; // Another 100 mills has elapsed
      00831E 0C 04            [ 1]  606 	inc	(0x04, sp)
                                    607 ;	main.c: 138: tog_pin('B', (1 << 5)); // Blink light for ease of use
      008320 4B 20            [ 1]  608 	push	#0x20
      008322 A6 42            [ 1]  609 	ld	a, #0x42
      008324 CD 80 2D         [ 4]  610 	call	_tog_pin
      008327 20 C2            [ 2]  611 	jra	00110$
                                    612 ;	main.c: 141: }
      008329 5B 04            [ 2]  613 	addw	sp, #4
      00832B 81               [ 4]  614 	ret
                                    615 	.area CODE
                                    616 	.area CONST
                                    617 	.area INITIALIZER
                                    618 	.area CABS (ABS)
