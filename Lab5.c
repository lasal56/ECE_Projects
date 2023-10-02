// Lab5.c starter program EE319K Lab 5, Spring 2023
// Runs on TM4C123
// Put your names here
//
// 2/5/2023 version


/* Option A1, connect LEDs to PB5-PB0, switches to PA5-3, walk LED PF321
   Option A2, connect LEDs to PB5-PB0, switches to PA4-2, walk LED PF321
   Option A6, connect LEDs to PB5-PB0, switches to PE3-1, walk LED PF321
   Option A5, connect LEDs to PB5-PB0, switches to PE2-0, walk LED PF321
   Option B4, connect LEDs to PE5-PE0, switches to PC7-5, walk LED PF321
<3 Option B3, connect LEDs to PE5-PE0, switches to PC6-4, walk LED PF321
   Option B1, connect LEDs to PE5-PE0, switches to PA5-3, walk LED PF321
   Option B2, connect LEDs to PE5-PE0, switches to PA4-2, walk LED PF321
  */
// east/west red light connected to bit 5
// east/west yellow light connected to bit 4
// east/west green light connected to bit 3
// north/south facing red light connected to bit 2
// north/south facing yellow light connected to bit 1
// north/south facing green light connected to bit 0
// pedestrian detector connected to most significant bit (1=pedestrian present)
// north/south car detector connected to middle bit (1=car present)
// east/west car detector connected to least significant bit (1=car present)
// "walk" light connected to PF3-1 (built-in white LED)
// "don't walk" light connected to PF3-1 (built-in red LED)
#include <stdint.h>
#include "Lab5grader.h"
#include "../inc/tm4c123gh6pm.h"
// put both EIDs in the next two lines
char EID1[] = "LS45349"; //  ;replace abc123 with your EID
char EID2[] = "AL55599"; //  ;replace abc123 with your EID

void DisableInterrupts(void);
void EnableInterrupts(void);

void Wait10ms(uint32_t Time); //Wait10ms loop from delay.s

//option b3
//to do: make state

#define	large 600 //6 seconds (a bunch of 10ms delays added up)
#define small 300 //3 seconds


struct state {
	char name[8]; 
	uint32_t traffic_output;
	uint32_t ped_output;

	uint32_t delay; //delay in 10ms increments
	//unsigned short Next [8]; //go to next state based on in and current
	const struct state *next[14]; //14 states in FSM so... 
};

typedef const struct state state_t;
//all 24 possible states
#define GoS  &FSM[0]//0 
#define WaitS &FSM[1]//1
#define StopS &FSM[2]//2
#define GoW &FSM[3] //3 
#define WaitW &FSM[4]//4
#define StopW &FSM[5]//5 
#define GoP &FSM[6]//6
#define RedP1 &FSM[7]//7
#define OffP1 &FSM[8]//8 
#define RedP2 &FSM[9]//9
#define OffP2 &FSM[10]//10
#define RedP3 &FSM[11]//11
#define OffP3 &FSM[12]//12
#define RedPFin &FSM[13]//13

//STT:
//name, traffic lights output, ped lights ouput, delay, next states

state_t FSM[14]= {
	{"GoS", 0x21, 0x02, large, {GoS, WaitS, GoS, WaitS, WaitS, WaitS, WaitS, WaitS}}, //0
	{"WaitS",0x22, 0x02, large, {StopS, StopS, StopS, StopS, StopS, StopS, StopS, StopS}}, //1
	{"StopS",0x24, 0x02, small, {GoW, GoW, GoS, GoW, GoP, GoW, GoP, GoW}}, //2
	{"GoW",0x0C, 0x02, large, {GoW, GoW, WaitW, WaitW, WaitW, WaitW, WaitW, WaitW}}, //3
	{"WaitW",0x14, 0x02, large, {StopW, StopW, StopW, StopW, StopW, StopW, StopW, StopW}}, //4
	{"StopW",0x24, 0x02, small, {GoP, GoW, GoS, GoS, GoP, GoP, GoP, GoP}}, //5
	{"GoP",0x24, 0x0E, large, {RedP1, GoP, RedP1, RedP1, RedP1, RedP1, RedP1, RedP1}}, //6
	{"RedP1",0x24, 0x02, small, {OffP1, OffP1, OffP1, OffP1, OffP1, OffP1, OffP1, OffP1}}, //7
	{"OffP1",0x24, 0x00, small, {RedP2, RedP2, RedP2, RedP2, RedP2, RedP2, RedP2, RedP2}}, //8
	{"RedP2",0x24, 0x02, small, {OffP2, OffP2, OffP2, OffP2, OffP2, OffP2, OffP2, OffP2}}, //9
	{"OffP2",0x24, 0x00, small, {RedP3, RedP3, RedP3, RedP3, RedP3, RedP3, RedP3, RedP3}}, //10
	{"RedP3",0x24, 0x02, small, {OffP3, OffP3, OffP3, OffP3, OffP3, OffP3, OffP3, OffP3}}, //11
	{"OffP3",0x24, 0x00, large, {RedPFin, RedPFin, RedPFin, RedPFin, RedPFin, RedPFin, RedPFin, RedPFin}}, //12
	{"RedPFin",0x24, 0x02, small, {GoS, GoW, GoS, GoS, GoP, GoW, GoS, GoS}}, //13
	
	//state zero is Go south
	

};


//void DisableInterrupts(void);
//void EnableInterrupts(void);

//void Wait10ms(uint32_t Time);// implemented in delay.s
int main(void){ 
  DisableInterrupts();
  TExaS_Init(GRADER);
	
	//uint32_t StateIndex; //= initial state fsm goes here; 
	state_t *pt; //pointer for state
uint32_t Input; 
  // Initialize GPIO ports
  // Specify initial state
		SYSCTL_RCGCGPIO_R|=0x34;//clock for PC, PE, PF (0011 0100)
		//int delay = SYSCTL_RCGCGPIO_R;//clock cycles
	  Wait10ms(1);

//port initialization
	
	//Port C Switches/buttons
		GPIO_PORTC_DIR_R&=~0x70;//switches are inputs
		GPIO_PORTC_DEN_R|=0x70;//digital enable for PC6-4 (0111 0000)
	//Port E traffic light out
		GPIO_PORTE_DIR_R |= 0x3F; //pe5-pe0 are outputs	(0011 1111)
		GPIO_PORTE_DEN_R |= 0x3F; //digital enable for PE5-0 (0011 1111)
	//Port F Ped light out
		GPIO_PORTF_DIR_R |= 0x0E; //Walk LED are outputs (PF3,2,1 
		GPIO_PORTF_DEN_R |= 0x0E; //digital enable for Port F3,2,1

		//initial state for fsm
	
	pt = GoS; //south-> west-> walk
	
  EnableInterrupts(); // grader, scope, logic analyzer need interrupts
	

	
			//to do
	while(1){
    // set traffic lights
    // set walk lights
    // wait using Wait10ms
		// read input
   

		GPIO_PORTE_DATA_R = pt->traffic_output;   // traffic light output set
		GPIO_PORTF_DATA_R = pt->ped_output;				//pedestrian light output set
		Wait10ms(pt->delay); //wait using Wait10ms from delay func
		
		Input = (GPIO_PORTC_DATA_R&0x70)>>4;     // Input = data & 0111 0000 // read sensors, shift bits 4 places to lsb
    pt = pt->next[Input];    // go to next state, next state comes from input and current state
  }
}

