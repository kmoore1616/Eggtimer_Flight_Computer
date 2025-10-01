#include "tim.h"


void delay_1_sec(void){
	uint8_t uif_flag = 0;
	TIM2_CR1 = TIM2_CR1 & 0xFE;
	TIM2_PSCR = 8; // 16 MHz / 256
	TIM2_ARRH = 0xF4;
	TIM2_ARRL = 0x24;
	TIM2_SR1 = TIM2_SR1 & (0b11111110);
	TIM2_CR1 = TIM2_CR1 | (0b00000001);
	while(!(uif_flag)){
		uif_flag = TIM2_SR1 & (0b00000001);
	}
}

void delay_1_ms(void){
	uint8_t uif_flag = 0;
	TIM2_CR1 = TIM2_CR1 & 0xFE;
	TIM2_PSCR = 1; 
	TIM2_ARRH = 0x1F;
	TIM2_ARRL = 0x40;
    TIM2_SR1 &= ~0x01;
	TIM2_SR1 = TIM2_SR1 & (0b11111110);
	TIM2_CR1 = TIM2_CR1 | (0b00000001);
	while(!(uif_flag)){
		uif_flag = TIM2_SR1 & (0b00000001);
	}
}

void delay_ms(int ms){
	int i = 0;
	for (i = 0; i < ms; i++){
		delay_1_ms();
	}
}

