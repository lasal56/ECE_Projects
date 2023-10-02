; BusyWait.s
; Student names: Laura Salazar & Aaron Lee
; Last modification date: 3/8/23

; Runs on TM4C123

; As part of Lab 7, students need to implement these two functions
; This file is in the inc folder so it automatically will be applied to labs 7 8 9 and 10


      EXPORT   SPIOutCommand
      EXPORT   SPIOutData

      AREA    |.text|, CODE, READONLY, ALIGN=2
      THUMB
      ALIGN
; Used in ECE319K Labs 7,8,9,10. You write these two functions

; ***********SPIOutCommand*****************
; This is a helper function that sends an 8-bit command to the LCD.
; Inputs: R0 = 32-bit command (number)
;         R1 = 32-bit SPI status register address
;         R2 = 32-bit SPI data register address
;         R3 = 32-bit GPIO port address for D/C
; Outputs: none
; Assumes: SPI and GPIO have already been initialized and enabled
; Note: must be AAPCS compliant
; Note: access to bit 6 of GPIO must be friendly
SPIOutCommand
; --UUU-- Code to write a command to the LCD
;1) Read the SPI status register (R1 has address) and check bit 4, 
;2) If bit 4 is high, loop back to step 1 (wait for BUSY bit to be low)
;3) Clear D/C (GPIO bit 6) to zero, be friendly (R3 has address)
;4) Write the command to the SPI data register (R2 has address)
;5) Read the SPI status register (R1 has address) and check bit 4, 
;6) If bit 4 is high, loop back to step 5 (wait for BUSY bit to be low)
    
  ;1)
  
  
loop1
	LDR R12, [R1] ;SPI status reg value into r12
	AND R12, #0x10 ;isolate bit 4
	CMP R12, #0x10 ;compare to see if high/low
	; if high, keep waiting
	BEQ loop1
	; if low, set GPIO Bit 6 = 0
	LDR R12, [R3]  ;get d/c port value into r12
	BIC R12, #0x40 ;clear bit 6, friendly
	STR R12, [R3]  ;store d/c port value back
	; Write the command to data reg
	STRB R0, [R2] 
	; Read spi stat reg
loop2
	LDR R12, [R1] ;SPI status reg value into r12
	AND R12, #0x10 ;isolate bit 4
	CMP R12, #0x10 ;compare to see if high/low
	; if its high, keep waiting
	BEQ loop2
	
 
		
   
    BX  LR             ;   return



; ***********SPIOutData*****************
; This is a helper function that sends an 8-bit data to the LCD.
; Inputs: R0 = 32-bit data (number)
;         R1 = 32-bit SPI status register address
;         R2 = 32-bit SPI data register address
;         R3 = 32-bit GPIO port address for D/C
; Outputs: none
; Assumes: SPI and GPIO have already been initialized and enabled
; Note: must be AAPCS compliant
; Note: access to bit 6 of GPIO must be friendly
SPIOutData
; --UUU-- Code to write data to the LCD
;1) Read the SPI status register (R1 has address) and check bit 1, 
;2) If bit 1 is low, loop back to step 1 (wait for TNF bit to be high)
;3) Set D/C (GPIO bit 6) to one, be friendly (R3 has address)
;4) Write the data to the SPI data register (R2 has address)
   
	;1)
	
loop3
	LDR R12, [R1] ;load contents of spi status reg into r12
	AND R12, #0x02 ;isolate bit 1
	CMP R12, #0    ;check to see if bit 1 is high or low
	; if low, keep oon waiting
	BEQ loop3
	; if its high, set the GPIO Bit 6 to 1
	LDR R12, [R3] ;load contents of d/c port
	ORR R12, #0x40 ;set bit 6 to 1
	STR R12, [R3] ;store vale back at add
	STRB R0, [R2] ;write data to data reg
	
	
	
	
  

		BX  LR             ;return
;****************************************************

    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
