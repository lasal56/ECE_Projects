// DAC.c
// This software configures DAC output
// Labs 6 and 10 requires 6 bits for the DAC
// Runs on LM4F120 or TM4C123
// Program written by: put your names here
//Students: Laura Salazar, Aaron Lee
// Date Created: 3/6/17 
// Last Modified: 3/1/23 
// Lab number: 6
// Hardware connections
// TO STUDENTS "REMOVE THIS LINE AND SPECIFY YOUR HARDWARE********

#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
// Code files contain the actual implemenation for public functions
// this file also contains an private functions and private data

// **************DAC_Init*********************
// Initialize 6-bit DAC, called once 
// Input: none
// Output: none
void DAC_Init(void){
  // used in Lab 6 and lab 10

			volatile uint32_t delay;
		SYSCTL_RCGCGPIO_R |= 0x02; // turn on port  B clock
		delay = SYSCTL_RCGCGPIO_R;	// delay time for clock to stabilize/boot up
	GPIO_PORTB_DIR_R |= 0x3F;	// make PB5-0 output
	GPIO_PORTB_DR8R_R |= 0x3F;	// can drive up to 8mA out (PB5-0)
	GPIO_PORTB_DEN_R |= 0x3F;	// enable digital I/O on PB5-0
	
}

// **************DAC_Out*********************
// output to DAC
// Input: 6-bit data, 0 to 63 
// Input=n is converted to n*3.3V/63
// Output: none
void DAC_Out(uint32_t data){
  // used in Lab 6 and lab 10
	GPIO_PORTB_DATA_R = data; //take 6 bit inout from data reg
}
