// Key.c
// This software configures the off-board piano keys
// Lab 6 requires a minimum of 4 keys, but you could have more
// Runs on LM4F120 or TM4C123
// Program written by: put your names here
// Date Created: 3/6/17 
// Last Modified: 1/2/23  
// Lab number: 6
// Hardware connections
// TO STUDENTS "REMOVE THIS LINE AND SPECIFY YOUR HARDWARE********
//Students: 

// Code files contain the actual implemenation for public functions
// this file also contains an private functions and private data
#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"

// **************Key_Init*********************
// Initialize piano key inputs on PA5-2 or PE3-0
// Input: none 
// Output: none
void Key_Init(void){ 
  // used in Lab 6 
	volatile uint32_t delay;
	
	//initialize PE & PF, be friendly
	SYSCTL_RCGCGPIO_R |= 0x30; //turns on clock for Port E and Port F for heartbeat LED
	delay = SYSCTL_RCGCGPIO_R;
	GPIO_PORTE_DEN_R |= 0x0F; //turns on data enable for PE0-3
	GPIO_PORTE_DIR_R &= ~0x0F; // sets PE0-3 as inputs
	GPIO_PORTF_DEN_R |= 0x02; //digital enable for PF1
	GPIO_PORTF_DIR_R |= 0x02; // PF1 now an output
}
// **************Key_In*********************
// Input from piano key inputs on PA5-2 or PE3-0
// Input: none 
// Output: 0 to 15 depending on keys
//   0x01 is just Key0, 0x02 is just Key1, 0x04 is just Key2, 0x08 is just Key3
uint32_t Key_In(void){ 
  // write this
	if(GPIO_PORTE_DATA_R == 0x00)
    {
        return 0;
    }
    else if (GPIO_PORTE_DATA_R ==0x01)
    {
        return 1;
    }
    else if (GPIO_PORTE_DATA_R == 0x02)
    {
        return 2;
    }
    else if (GPIO_PORTE_DATA_R == 0x03)
    {
        return 3;
    }
    else if (GPIO_PORTE_DATA_R ==0x04)
    {
        return 4;
    }
    else if(GPIO_PORTE_DATA_R == 0x05)
    {
        return 5;
    }
    else if (GPIO_PORTE_DATA_R == 0x06)
    {
        return 6;
    }
    else if (GPIO_PORTE_DATA_R == 0x07)
    {
        return 7;
    }
    else if (GPIO_PORTE_DATA_R ==0x08)
    {
        return 8;
    }
    else if (GPIO_PORTE_DATA_R ==0x09)
    {
        return 9;
    }
    else if (GPIO_PORTE_DATA_R == 0x0A)
    {
        return 10;
    }
    else if(GPIO_PORTE_DATA_R == 0x0B)
    {
        return 11;
    }
    else if (GPIO_PORTE_DATA_R == 0x0C)
    {
        return 12;
    }
    else if (GPIO_PORTE_DATA_R == 0x0D)
    {
        return 13;
    }
    else if (GPIO_PORTE_DATA_R == 0x0E)
    {
        return 14;
    }
    else if (GPIO_PORTE_DATA_R ==0x0F)
    {
        return 15;
    }
    return 16; 
	
}



//------------LaunchPad_Init------------
// Initialize Switch input and LED output
// Input: none
// Output: none
void LaunchPad_Init(void){
// implement if needed
	
}


//------------LaunchPad_Input------------
// Input from Switches, 
// Convert hardware negative logic to software positive logic 
// Input: none
// Output: 0x00 none
//         0x01 SW2 pressed (from PF4)
//         0x02 SW1 pressed (from PF1)
//         0x03 both SW1 and SW2 pressed
uint8_t LaunchPad_Input(void){
// implement if needed
//			uint32_t inputData;
//			inputData = ~ GPIO_PORTA_DATA_R;
 // return ((inputData & 0x01)| (inputData & 0x02)) ; // replace   
		return 0;
}
//------------LaunchPad__Output------------
// Output to LaunchPad LEDs 
// Positive logic hardware and positive logic software
// Input: 0 off, bit0=red,bit1=blue,bit2=green
// Output: none
void LaunchPad_Output(uint8_t data){  // write three outputs bits of PORTF
// implement if needed
//			GPIO_PORTF_DATA_R = data << 3;
}

