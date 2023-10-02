// Lab6.c
// Runs on TM4C123
// Use SysTick interrupts to implement a 4-key digital piano
// EE319K lab6 starter
// Program written by: put your names here
//Students: 

// Date Created: 3/6/17 
// Last Modified: 3/1/23  
// Lab number: 6
// Hardware connections
// TO STUDENTS "REMOVE THIS LINE AND SPECIFY YOUR HARDWARE********

//key3=PE3, Key2=PE2, Key1=PE1, Key0=PE0, DAC=PB5-0

//Key0=246.9, Key1=311.1, Key2=370.0, Key3=415.3Hz



#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
#include "Sound.h"
#include "Key.h"
#include "Song.h"
#include "../inc/wave.h"
#include "Lab6Grader.h"
// put both EIDs in the next two lines
char EID1[] = "LS45349"; //  ;replace abc123 with your EID
char EID2[] = "AL55599"; //  ;replace abc123 with your EID







void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void DAC_Init(void);          // your lab 6 solution
void DAC_Out(uint8_t data);   // your lab 6 solution
uint32_t Testdata;
uint32_t beat = 0;
void heartbeat(void){
		beat++;
	if(beat & 0x00010000)
				GPIO_PORTF_DATA_R ^= 0x02;
}	
		
// lab video Lab6_voltmeter
// use this if you have a voltmeter
// 1) connect voltmeter to DACOUT 
// 2) add a breakpoint at i+1
// 3) run and record voltage for each input value
const uint32_t Inputs[16]={0,1,7,8,15,16,17,18,31,32,33,47,48,49,62,63};
int voltmetermain(void){ uint32_t i;  
  
  TExaS_Init(SIMULATIONGRADER);    
  LaunchPad_Init();
  DAC_Init(); // your lab 6 solution
  i = 0;
  EnableInterrupts();
  while(1){                
    Testdata = Inputs[i];
    DAC_Out(Testdata); // your lab 6 solution
    i=(i+1)&0x0F;  // <---put a breakpoint here
  }
}
// DelayMs
//  - busy wait n milliseconds
// Input: time to wait in msec
// Outputs: none
void static DelayMs(uint32_t n){
  volatile uint32_t time;
  while(n){
    time = 6665;  // 1msec, tuned at 80 MHz
    while(time){
      time--;
    }
    n--;
  }
}
// lab video Lab6_static
// use this if you DO NOT have a voltmeter
// you need to implement LaunchPad_Init and LaunchPad_Input
// Connect PD3 to your DACOUT and observe the voltage using TExaSdisplay in scope mode.
int staticmain(void){  
  uint32_t last,now,i;  
	DisableInterrupts();
  TExaS_Init(SCOPE);    // bus clock at 80 MHz
  LaunchPad_Init();
  DAC_Init(); // your lab 6 solution
  i = 0;
  EnableInterrupts();
  last = LaunchPad_Input();
  while(1){                
    now = LaunchPad_Input();
    if((last != now)&&now){
      Testdata = Inputs[i];
      DAC_Out(Testdata); // your lab 6 solution
      i=(i+1)&0x0F;
    }
    last = now;
    DelayMs(25);   // debounces switch
  }
}

     //heartbeat led
//no input or outputs, toggle LED to flash it
void heartBeat(void){
			GPIO_PORTF_DATA_R ^= 0x02; 
}


int main(void){       
  DisableInterrupts();
  TExaS_Init(REALBOARDGRADER);    // bus clock at 80 MHz
//    SCOPE,
//    LOGICANALYZERA,
//    LOGICANALYZERB,
//    LOGICANALYZERC,
//    LOGICANALYZERE,
//    REALBOARDGRADER,
//    SIMULATIONGRADER,
//    NONE
  Key_Init();
  LaunchPad_Init(); // if needed
  Sound_Init();
  Song_Init(); // extra credit 1)
  Wave_Init(); // extra credit 2)
  EnableInterrupts();
	
	//initialize
	
	
	uint32_t heart = 0;
	
	
  while(1){        
		
    //Key0=246.9, Key1=311.1, Key2=370.0, Key3=415.3Hz
		if(heart == 800000){
			heartBeat();
			heart = 0;
		}
		uint8_t key;
		
		//80MHz clock (comes from 1/12.5ns) 
		//64 samples per cycle
		//therefore: (80)/(64 * freq) = period 
		//round to get integer value
		
			key = Key_In();
			
			
			if(key == 1){ //key0 : 0001
					Sound_Start(5063); //Freq should = 246.9 Hz
			}
			// 
			if(key == 2){ //key1 : 0010
					Sound_Start(4018); //Freq = 311.1 Hz
			}

			if(key == 4){ //key2 : 0100
					Sound_Start(3378); //Freq = 370.0 Hz
			}
			
			if(key == 8){ //key3 : 1000
					Sound_Start(3010); //Freq = 415.3 Hz
			}
			
			else
					Sound_Start(0);
			heart++;
  }        
}


