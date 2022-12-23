;;***********************************************************
; Programming Assignment 3
; Student Name: Laura Salazar
; UT Eid: LS45349
; Simba in the Jungle
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.
; Note: Remember "Callee-Saves" (Cleans its own mess)

;***********************************************************

.ORIG x3000

;***********************************************************
; Main Program
;***********************************************************
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_INITIAL
    TRAP  x22 
    LDI   R0,BLOCKS
    JSR   LOAD_JUNGLE
    JSR   DISPLAY_JUNGLE
    LEA   R0, JUNGLE_LOADED
    TRAP  x22                        ; output end message
    TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
BLOCKS          .FILL x6000

;***********************************************************
; Global constants used in program
;***********************************************************
;***********************************************************
; This is the data structure for the Jungle grid
;***********************************************************
GRID .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
     .STRINGZ "| | | | | | | | |"
     .STRINGZ "+-+-+-+-+-+-+-+-+"
                   

;***********************************************************
; this data stores the state of current position of Simba and his Home
;***********************************************************
CURRENT_ROW        .BLKW   #1       ; row position of Simba
CURRENT_COL        .BLKW   #1       ; col position of Simba 
HOME_ROW           .BLKW   #1       ; Home coordinates (row and col)
HOME_COL           .BLKW   #1

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************

;***********************************************************
; DISPLAY_JUNGLE
;   Displays the current state of the Jungle Grid 
;   This can be called initially to display the un-populated jungle
;   OR after populating it, to indicate where Simba is (*), any 
;   Hyena's(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************

DISPLAY_JUNGLE      

        ST R0, Save_R0_disp ;callee saves, store registers so they can be restored
        ST R1, Save_R1_disp
        ST R2, Save_R2_disp
        ST R3, Save_R3_disp
        ST R4, Save_R4_disp
        ST R5, Save_R5_disp
        ST R6, Save_R6_disp

       
        LEA R0, line ;load new line
        PUTS         ;output
        LEA R0, numberline_colrow ;top line above grid
        PUTS                      ;trap x22
        LD R1, disp_junglegrid    ;ld grid address
        LD R4, ASCII_zero         ;load ascii character for "0"
        LD R5, char_rows
        
display_loop
        AND R3, R5, x0001  ;bit mask, if row is odd, result == 1, if row is even, result==0
        BRz even ;row is even
        LEA R0, space  ;row is odd so space goes here not number
        PUTS
        BRnzp display_innerloop
            
even
        ADD R0, R4, #0  ;initial val, put into r0
        OUT             ;output to monitor
        ADD R4, R4, #1  ;with each iteration, row value will increase by 1
        
display_innerloop
        LEA R0, space  ;ld space address
        PUTS           ;output string to monitor
        AND R0, R0, #0 ;initialize
        ADD R0, R0, R1 ;get addy of grid
        PUTS           ;output to monitor
        ADD R1, R1, #9 
        ADD R1, R1, #9 ;17 chars in line, 18 to go to next
        LEA R0, line   ;load new line
        PUTS           ;output string to monitor
        ADD R5, R5, #-1 ;iterate until no more rows left (zero)
        BRnp display_loop
        
        
        LD R0, Save_R0_disp  ;clean mess (callee saves and restores)
        LD R1, Save_R1_disp
        LD R2, Save_R2_disp
        LD R3, Save_R3_disp
        LD R4, Save_R4_disp
        LD R5, Save_R5_disp
        

    
    JMP R7



space                   .STRINGZ " "
disp_junglegrid         .FILL GRID
numberline_colrow       .STRINGZ "   0 1 2 3 4 5 6 7 \n"
line                    .STRINGZ "\n"
ASCII_zero              .FILL x30
char_rows               .FILL #17

Save_R0_disp     .BLKW #1
Save_R1_disp     .BLKW #1
Save_R2_disp     .BLKW #1
Save_R3_disp     .BLKW #1
Save_R4_disp     .BLKW #1
Save_R5_disp     .BLKW #1
Save_R6_disp     .BLKW #1




;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************


LOAD_JUNGLE 

                
                ST R0, Save_R0_load
                ST R1, Save_R1_load
                ST R2, Save_R2_load
                ST R3, Save_R3_load
                ST R4, Save_R4_load
                ST R5, Save_R5_load
                ST R6, Save_R6_load
                ST R7, Save_R7_load
                
                ;getting stuff from linked list
load_iterate    LDR R3, R0, #0 ;next iteration head address
                LDR R1, R0, #1 ;load row number for this iter
                LDR R2, R0, #2 ;load column number for this iter
                LDR R4, R0, #3 ;get ascii character for this iter
                LD R5, neg_check ;use to check for hyena character
                ADD R6, R4, R5   ;check for hyena
                BRn found_hyena  ;if neg, hyena found
                ADD R6, R6, #-1  ;if zero now, character found was x49 (I) initial...
                BRz initial      ;...else, character was x23 (#), home
                LD R6, home_row_grab ;ld home row
                STR R1, R6, #0       ;write to mem
                LD R6, home_col_grab  ;ld home column
                STR R2, R6, #0        ;write to mem
                BRnzp found_hyena     ;done, ready for disp   
                
initial
                LD R4, initialloc_ASCII ;load character of initial location (*)
                LD R6, curr_row_grab    ;load current row position of simba
                STR R1, R6, #0          ;write to mem current row coord
                LD R6, curr_col_grab    ;load current col position of simba
                STR R2, R6, #0          ;write to mem current col coord
                BRnzp found_hyena
                
found_hyena
                JSR GRID_ADDRESS ;call my next subroutine
                STR R4, R0, #0   ;translates logical grid coords. of gridblock to physical addy in grid mem
                ADD R3, R3, #0   ;prep to check if end has been reached
                BRz end_of_list  ;if == 0, end of linked list reached (0)
                ADD R0, R3, #0   ;move to next gridblock, end, not reached yet
                BRnzp load_iterate ;iterate until end of linked list reached
        
end_of_list     LD R7, Save_R7_load
                LD R0, Save_R0_load
                LD R1, Save_R1_load
                LD R2, Save_R2_load
                LD R3, Save_R3_load
                LD R4, Save_R4_load
                LD R5, Save_R5_load
                LD R6, Save_R6_load

    JMP  R7
    

Save_R0_load        .BLKW #1 ;restore registers
Save_R1_load        .BLKW #1     
Save_R2_load        .BLKW #1     
Save_R3_load        .BLKW #1     
Save_R4_load        .BLKW #1 
Save_R5_load        .BLKW #1 
Save_R6_load        .BLKW #1 
Save_R7_load        .BLKW #1

neg_check           .FILL x-48
curr_row_grab       .FILL CURRENT_ROW
home_row_grab       .FILL HOME_ROW
curr_col_grab       .FILL CURRENT_COL
home_col_grab       .FILL HOME_COL
initialloc_ASCII    .FILL x2A


;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-7)
;         R2 has the column number (0-7)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************
GRID_ADDRESS   
        ;function (r,c)
        ;2r+1 == 18
        ;r1 has current row num
        ;GRID + 18(2 x r1 + 1) + (2 x r2 +1)
    
            ST R1, Save_R1_gridadd ;callee saves
            ST R2, Save_R2_gridadd
            ST R3, Save_R3_gridadd
            ST R4, Save_R4_gridadd
            ST R5, Save_R5_gridadd
            ST R6, Save_R6_gridadd
            
            LD R6, grab_grid ;ld grid addy
            AND R4, R4, #0   ;initialize register
            AND R3, R3, #0   ;initialize register
reg1_times2
            ADD R3, R3, #2  ;add two with each iteration
            ADD R1, R1, #-1 ;iterate until neg (all possible coords have been fulfilled)
            BRzp reg1_times2
            ADD R3, R3, #-1 ;move row down 1
            
            AND R5, R5, #0 ;initialize for times_18 op
        
times_18
            ADD R5, R5, #9 ;part 1 of succesive multiplication
            ADD R5, R5, #9 ;part w of succesive mult
            ADD R3, R3, #-1 ;iterate until reach zero
            BRnp times_18
        
;gotta  move obto column mem find

;multiply R2 by 2
reg2_times2
            ADD R4, R4, #2   ;add two with each iteration
            ADD R2, R2, #-1  ;number of times that succesive addition will occur
            BRzp reg2_times2 ;iterate until neg (all possible coords have been fulfilled)
            ADD R4, R4, #-1  ;move row down 1
            
            
            ADD R6, R6, R5 ;sum inputs...
            ADD R6, R6, R4 ;..sum inputs
            
            AND R0, R0, #0 ;intialize r0...
            ADD R0, R0, R6 ;....store addy into r0
        
        
            LD R1, Save_R1_gridadd  ;restore registers/clean mess
            LD R2, Save_R2_gridadd
            LD R3, Save_R3_gridadd
            LD R4, Save_R4_gridadd
            LD R5, Save_R5_gridadd
            LD R6, Save_R6_gridadd 
    
 
    JMP R7

    

    ; This section has the linked list for the
; Jungle's layout: #(0,1)->H(4,7)->I(2,1)->#(1,1)->#(6,3)->F(3,5)->F(4,4)->#(5,6)
	.ORIG	x6000
	.FILL	Head   ; Holds the address of the first record in the linked-list (Head)
blk2
	.FILL   blk4
	.FILL   #1
    .FILL   #1
	.FILL   x23

Head
	.FILL	blk1
    .FILL   #0
	.FILL   #1
	.FILL   x23

blk1
	.FILL   blk3
	.FILL   #4
	.FILL   #7
	.FILL   x48

blk3
	.FILL   blk2
	.FILL   #2
	.FILL   #1
	.FILL   x49

blk4
	.FILL   blk5
	.FILL   #6
	.FILL   #3
	.FILL   x23

blk7
	.FILL   #0
	.FILL   #5
	.FILL   #6
	.FILL   x23
blk6
	.FILL   blk7
	.FILL   #4
	.FILL   #4
	.FILL   x46
blk5
	.FILL   blk6
	.FILL   #3
	.FILL   #5
	.FILL   x46
	.END	


