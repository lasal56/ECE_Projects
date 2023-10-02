// ADC.c
// Runs on TM4C123
// Provide functions that initialize ADC0
// Last Modified: 1/2/2023  
// Student names:
// Last modification date: 3/29/2023
// This file is in the inc folder so it automatically will be applied to labs 8 9 and 10
// Labs 8, 9, and 10 specify PD2
#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"

// ADC initialization function using PD2 
// Input: none
// Output: none
void ADC_Init(void){ 
// write this
	uint32_t delay;  
	// Setup PD2 as analog input
	
	   SYSCTL_RCGCGPIO_R|=0x08;   //activate clock for port D
		//	while ((SYSCTL_RCGCGPIO_R&0x08)==0){};	//wait for clock to stabilize
	 while((SYSCTL_PRGPIO_R & 0x08) == 0) {};
   GPIO_PORTD_DIR_R&= ~0x04;  //PD2 & PD1 is set as an input
   GPIO_PORTD_AFSEL_R|=0x04;  //enable alt func on PD2
   GPIO_PORTD_DEN_R&= ~0x04;  //disable digital IO on PD2 
   GPIO_PORTD_AMSEL_R|=0x04;  //activate analog function on PD2
  

   // ADC0 PD2 Channel 5
   SYSCTL_RCGCADC_R|=0x01;      //activate ADC0 clock
  delay = SYSCTL_RCGCADC_R;       // extra time to stabilize
  delay = SYSCTL_RCGCADC_R;       // extra time to stabilize
  delay = SYSCTL_RCGCADC_R;       // extra time to stabilize
  delay = SYSCTL_RCGCADC_R;
//stabilize clock
	 ADC0_PC_R &= ~0xF;
   ADC0_PC_R=0x01;              //max sample rate of 125k/second
   ADC0_SSPRI_R=0x0123;         //set sequencer priority
   ADC0_ACTSS_R&= ~0x0008;      //need to disable sample sequencer before configuring it
   ADC0_EMUX_R&= ~0xF000;       //NOT NEEDED?? ADC will be triggered by software start
   ADC0_SSMUX3_R = (ADC0_SSMUX3_R & ~0x000F) + 5;           //set channel 5
   ADC0_SSCTL3_R=0x0006;        //specifies that ADC will measure voltage, use busy-wait
   ADC0_IM_R&= ~0x0008;         //disable sequencer interrupts
   ADC0_ACTSS_R|=0x0008;        //enable sample sequencer
	 
	  ADC0_SAC_R = 5; //take 32, samples, return average
		//only need when testing hardware to sample average value 
 }
//------------ADC_In------------
// Busy-wait Analog to digital conversion
// Input: none
// Output: 12-bit result of ADC conversion
// measures from PD2, analog channel 5
uint32_t ADC_In(void){  
	// 1) initiate 
  // 2) wait for conversion done
  // 3) read result
  // 4) ack 
	uint32_t done;
	
	ADC0_PSSI_R = 0x0008;		// Initiate SS3
	// Check ADC0
	while((ADC0_RIS_R & 0x08) == 0){};	// Wait for conversion to be done
	done = ADC0_SSFIFO3_R & 0xFFF;	// ADC conversion is 12 bits
	ADC0_ISC_R = 0x0008;		// Clear flag
	return done;
}




