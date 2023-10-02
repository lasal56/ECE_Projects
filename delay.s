;Software delay functions
; Your name
; Date last modified
   AREA    |.text|, CODE, READONLY, ALIGN=3
   THUMB
   EXPORT Delay
;*********Delay**********************
; Software delay loop
; Input: R0 is count, the amount to delay in 100ns
; Output: none
      ALIGN 8
Delay NOP ;dummy operation
      NOP
      NOP
      NOP
      SUBS R1,R1,#1
      BNE  Delay
      BX   LR
      
   EXPORT Wait10ms
;*********Wait10ms**********************
; Software delay loop
; Input: R0 is count, the amount to delay in 10ms
; Output: none
; implement this using AAPCS
Wait10ms
		PUSH {R4,LR}
Repeat
		MOV R1, #10000
		BL Delay
		SUBS R0, R0, #1
		BNE Repeat
		POP {R4,LR}
		BX  LR
		END      
