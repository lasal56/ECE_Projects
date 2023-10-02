;****************** main.s ***************
; Program initially written by: Yerraballi and Valvano
; Author: 
; Date Created: 1/15/2018 
; Last Modified: 1/25/2023 
; Brief description of the program: Solution to Lab1
; The objective of this system is to implement a parity system
; Hardware connections: 
;  One output is positive logic, 1 turns on the LED, 0 turns off the LED
;  Three inputs are positive logic, meaning switch not pressed is 0, pressed is 1
;		PE0 is an input
;		PE1 is an input
;		PE2 is an input
;		PE5 is the output

GPIO_PORTD_DATA_R  EQU 0x400073FC
GPIO_PORTD_DIR_R   EQU 0x40007400
GPIO_PORTD_DEN_R   EQU 0x4000751C
GPIO_PORTE_DATA_R  EQU 0x400243FC
GPIO_PORTE_DIR_R   EQU 0x40024400
GPIO_PORTE_DEN_R   EQU 0x4002451C
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
       PRESERVE8 
       AREA   Data, ALIGN=2
; Declare global variables here if needed
; with the SPACE assembly directive
       ALIGN 4
       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT EID
EID    DCB "LS45349",0  ;replace ABC123 with your EID
       EXPORT RunGrader
	   ALIGN 4
RunGrader DCD 1 ; change to nonzero when ready for grading
           
      EXPORT  Lab1

Lab1	
 ;initialization
 
	;turn on the clock
	LDR R0, =SYSCTL_RCGCGPIO_R ;R0 currently has address of clock register
	LDR R1, [R0]				;R1 has value of clock register
	;....._ _ _ _ _ _
	;     F E D C B A
	;port E is bit 4
	ORR R1, #0x10	;00010000
	STR R1, [R0]	;store back at address in R0
	;wait for clock to boot up
	NOP				;wait cycle 1
	NOP				;wait cycle 2
	;DIR: 0 = input, 1 = output
	LDR R0, =GPIO_PORTE_DIR_R	;give R0 address of direction register
	LDR R1, [R0]				;access value at address in R0
	;now, make PE0,PE1, & PE2 inputs   make PE5 output
	BIC R1, #0x07				;0000 0111 (clear lower three bits)
	ORR R1, #0x20				;0010 0000  (set bit 5 to 1 so PE5 is output)
	STR R1, [R0]				;store back at memory address of R0
	
	;DEN: digitally enable pins PE0, PE1, PE2, and PE5	LDR R0, =GPIO_PORTE_DEN_R
	LDR R0, =GPIO_PORTE_DEN_R
	LDR R1, [R0] 
	ORR R1, #0x27				;0010 0111 (set bits 0,1,2, 5 to equal 1, thus enabling pins
	STR R1, [R0]				; store back at memory address of R0
	
loop
   ;main program loop
    LDR R0, =GPIO_PORTE_DATA_R  ;give R0 address of portE data
    LDR R1, [R0]					;give R1 value of data register
   
   ;masks used to isolate bits associated with specific inputs
   ;implement boolean logic function for even parity:
   ; A^B^C with A B C corresp to PE0 PE1 PE2
   ;output is PE5
   ;EOR using least sig bit
   ;AND bit mask implem to isolate pin bit

	AND R2, R1, #0x01 ;R2 = PE0 no need to shift bc already LSB
	AND R3, R1, #0x02 ;R3 = PE1
	LSR R3, #1	;shift bit to right 1 spot (bc PE1) to be  LSB
	AND R4, R1, #0x04 ;R4 = PE2
	LSR R4, #2	;shift bit right 2 spots (bc PE2) to be LSB
   
   ;now time to implement function A^B^C
   ;2 steps: first A^B then ^ result with C...
   ;...aka (A^B)^C
    EOR R6, R2, R3 	;A^B
    EOR R7, R6, R4	;Result of last op ^C
	 
   ;now time to put output of function in PE5
    LSL R7, #5		;PE5 is 6th bit, so shift left 5
    STR R7, [R0] 	;Store output to data register
  
    B    loop
  
    ALIGN        ; make sure the end of this section is aligned
    END          ; end of file
               
