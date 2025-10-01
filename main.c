#include "stm8.h"
#include "tim.h"

int8_t tog_pin(char port, char x){
    switch(port){
        case 'A':
            PA_DDR |= x;          // output
            PA_CR1 |= x;          // push-pull
            PA_CR2 &= ~x;         // disable fast mode
            PA_ODR ^= x;
            break;
        case 'B':
            PB_DDR |= x;          // output
            PB_CR1 |= x;          // push-pull
            PB_CR2 &= ~x;         // disable fast mode
            PB_ODR ^= x;
            break;
        
        case 'C':
            PC_DDR |= x;          // output
            PC_CR1 |= x;          // push-pull
            PC_CR2 &= ~x;         // disable fast mode
            PC_ODR ^= x;
            break;
        case 'D':
            PD_DDR |= x;          // output
            PD_CR1 |= x;          // push-pull
            PD_CR2 &= ~x;         // disable fast mode
            PD_ODR ^= x;
            break;
        default:
            return -1;
    }
    return 0;
}

int8_t read_pin(char port, int x, char floating){ 
    if(floating){
        switch(port){
            case 'A':
                PA_DDR &= ~x;          // Input 
                PA_CR1 &= ~x;          // Pull-up 
                PA_CR2 &= ~x;         // No interupt 
                return (PA_IDR & x); 
            case 'B':
                PB_DDR &= ~x;          // Input 
                PB_CR1 &= ~x;          // Pull-up 
                PB_CR2 &= ~x;         // No interupt 
                return (PB_IDR & x); 
            case 'C':
                PC_DDR &= ~x;          // Input 
                PC_CR1 &= ~x;          // Pull-up 
                PC_CR2 &= ~x;         // No interupt 
                return (PC_IDR & x); 

            case 'D':
                PD_DDR &= ~x;          // Input 
                PD_CR1 &= ~x;          // Pull-up 
                PD_CR2 &= ~x;         // No interupt 
                return (PD_IDR & x); 
            
            default:
                return -1;
        }
    }else{
        switch(port){
            case 'A':
                PA_DDR &= ~x;          // Input 
                PA_CR1 |= x;          // Pull-up 
                PA_CR2 &= ~x;         // No interupt 
                return (PA_IDR & x); 
            case 'B':
                PB_DDR &= ~x;          // Input 
                PB_CR1 |= x;          // Pull-up 
                PB_CR2 &= ~x;         // No interupt 
                return (PB_IDR & x); 
            case 'C':
                PC_DDR &= ~x;          // Input 
                PC_CR1 |= x;          // Pull-up 
                PC_CR2 &= ~x;         // No interupt 
                return (PC_IDR & x); 

            case 'D':
                PD_DDR &= ~x;          // Input 
                PD_CR1 |= x;          // Pull-up 
                PD_CR2 &= ~x;         // No interupt 
                return (PD_IDR & x); 
            
            default:
                return -1;
        }
    }
    return -1;
}

// Reads dip switch to get timing nibble
uint8_t get_timing(void){
    int input = 0; // Tempoary iterator
    uint8_t timing = 0;
    for(int i=3; i<7; i++){
        // Low means dip switch is set
        input = read_pin('C', (1 << i), 0); // Check if pin is pulled low
        if(input < 0){ // Error checking ):
            while(1){
                tog_pin('B', (1 << 5));
                delay_ms(1000);
            }
        }
        if(input == 0){ // If pulled low
            timing |= (1 << (i-3)); // Set bit on nibble
        }
    }
    return timing;
}


int main() {
    uint8_t elapsed = 0; // Timer counter
    uint8_t armed = 0;     

    CLK_CKDIVR = 0x00; // Dont divide clock timing
    uint8_t timing = get_timing(); // Get dip switch settings
    
    while(read_pin('C', (1<<7), 1)); // Hold countdown until launch event detected (pin c7 DCed during launch)


    while(1){
        if(elapsed >= (timing*10)){ // Check if timer has gone off
            tog_pin('D', (1<<4)); // Activate ignitor
            delay_ms(5000);  // Wait 5 seconds
            tog_pin('D', (1<<4)); // Deactivate to avoid damage to lipos
            while(1); // Program finished, 
        }
        delay_ms(100); // If timer still going wait the 100 mills
        elapsed++; // Another 100 mills has elapsed
        tog_pin('B', (1 << 5)); // Blink light for ease of use
    }

}
