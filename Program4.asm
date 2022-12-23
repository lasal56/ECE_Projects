;***********************************************************
; Programming Assignment 4
; Student Name: Laura Salazar
; UT Eid: LS45349
; -------------------Save Simba (Part II)---------------------
; This is the starter code. You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

;***********************************************************

.ORIG x4000

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
HOMEBOUND
        LEA   R0, LC_OUT_STRING
        TRAP  x22
        LDI   R0,LC_LOC
        LD    R4,ASCII_OFFSET_POS
        ADD   R0, R0, R4
        TRAP  x21
        LEA   R0,PROMPT
        TRAP  x22
        TRAP  x20                        ; get a character from keyboard into R0
        TRAP  x21                        ; echo character entered
        LD    R3, ASCII_Q_COMPLEMENT     ; load the 2's complement of ASCII 'Q'
        ADD   R3, R0, R3                 ; compare the first character with 'Q'
        BRz   EXIT                       ; if input was 'Q', exit
;; call a converter to convert i,j,k,l to up(0) left(1),down(2),right(3) respectively
        JSR   IS_INPUT_VALID      
        ADD   R2, R2, #0                 ; R2 will be zero if the move was valid
        BRz   VALID_INPUT
        LEA   R0, INVALID_MOVE_STRING    ; if the input was invalid, output corresponding
        TRAP  x22                        ; message and go back to prompt
        BRnzp    HOMEBOUND
VALID_INPUT                 
        JSR   APPLY_MOVE                 ; apply the move (Input in R0)
        JSR   DISPLAY_JUNGLE
        JSR   SIMBA_STATUS      
        ADD   R2, R2, #0                 ; R2 will be zero if reached Home or -1 if Dead
        BRp  HOMEBOUND                     ; otherwise, loop back
EXIT   
        LEA   R0, GOODBYE_STRING
        TRAP  x22                        ; output a goodbye message
        TRAP  x25                        ; halt
JUNGLE_LOADED       .STRINGZ "\nJungle Loaded\n"
JUNGLE_INITIAL      .STRINGZ "\nJungle Initial\n"
ASCII_Q_COMPLEMENT  .FILL    x-71    ; two's complement of ASCII code for 'q'
ASCII_OFFSET_POS        .FILL    x30
LC_OUT_STRING    .STRINGZ "\n LIFE_COUNT is "
LC_LOC  .FILL LIFE_COUNT
PROMPT .STRINGZ "\nEnter Move up(i) \n left(j),down(k),right(l): "
INVALID_MOVE_STRING .STRINGZ "\nInvalid Input (ijkl)\n"
GOODBYE_STRING      .STRINGZ "\n!Goodbye!\n"
BLOCKS               .FILL x6000

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
LIFE_COUNT         .FILL   #1       ; Initial Life Count is One
                                    ; Count increases when Simba
                                    ; meets a Friend; decreases
                                    ; when Simba meets a Hyena
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
;   Friends (F) and Hyenas(#) are, and Simba's Home (H).
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers
;***********************************************************
DISPLAY_JUNGLE      
; Your Program 3 code goes here


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
    JMP R7

;***********************************************************
; LOAD_JUNGLE
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has four fields:
;       0. Address of the next gridblock in the list
;       1. row # (0-7)
;       2. col # (0-7)
;       3. Symbol (can be I->Initial,H->Home, F->Friend or #->Hyena)
;    The list is guaranteed to: 
;               * have only one Inital and one Home gridblock
;               * have zero or more gridboxes with Hyenas/Friends
;               * be terminated by a gridblock whose next address 
;                 field is a zero
; Output: None
;   This function loads the JUNGLE from a linked list by inserting 
;   the appropriate characters in boxes (I(*),#,F,H)
;   You must also change the contents of these
;   locations: 
;        1.  (CURRENT_ROW, CURRENT_COL) to hold the (row, col) 
;            numbers of Simba's Initial gridblock
;        2.  (HOME_ROW, HOME_COL) to hold the (row, col) 
;            numbers of the Home gridblock
;       
;***********************************************************
LOAD_JUNGLE 
; Your Program 3 code goes here

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
; Your Program 3 code goes here

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
        
;gotta  move onto column mem find

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
    
 grab_grid .FILL GRID
Save_R1_gridadd .BLKW #1
Save_R2_gridadd .BLKW #1
Save_R3_gridadd .BLKW #1
Save_R4_gridadd .BLKW #1
Save_R5_gridadd .BLKW #1
Save_R6_gridadd .BLKW #1


;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
; Your New (Program4) code goes here

                            ; R0 is Input Char
    AND R2, R2, #0          ; R2 is Output #
    AND R5, R5, #0          ; initialize
    AND R4, R4, #0          ; initialize
                            
                            ; ASCII char i = x69, #105
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15         ; R5 = 105
    NOT R5, R5
    ADD R5, R5, #1          ; R5 = -105 ; 2's Comp
    ADD R4, R0, R5          ; R6 = R0 - 105
    BRz yay_val_input
                            
                            ; ASCII char j = x6A 
    ADD R5, R5, #-1         ; R5 = -106
    ADD R4, R0, R5          ; R6 = R0 - 106
    BRz yay_val_input
                            ; ASCII char k = x6B 
    ADD R5, R5, #-1         ; R5 = -107
    ADD R4, R0, R5          ; R6 = R0 - 107
    BRz yay_val_input
                            
                            ; ASCII char l = x6C 
    ADD R5, R5, #-1         ; R3 = -108
    ADD R4, R0, R5          ; R4 = R0 - 108
    BRz yay_val_input
    
    ; not valid input
    ADD R2, R2, #-1         ; R2 = -1 ; Output of Invalid Input
    
yay_val_input                 ; R2 = 0  ; Output of Valid Input
    AND R6, R6, #0
    AND R5, R5, #0
    AND R4, R4, #0          ; Callee-Saves
    
    JMP R7

;***********************************************************
; CAN_MOVE
; This subroutine checks if a move can be made and returns 
; the new position where Simba would go to if the move is made. 
; To be able to make a move is to ensure that movement 
; does not take Simba off the grid; this can happen in any direction.
; In coding this routine you will need to translate a move to 
; coordinates (row and column). 
; Your APPLY_MOVE subroutine calls this subroutine to check 
; whether a move can be made before applying it to the GRID.
; Inputs: R0 - a move represented by 'i', 'j', 'k', or 'l'
; Outputs: R1, R2 - the new row and new col, respectively 
;              if the move is possible; 
;          if the move cannot be made (outside the GRID), 
;              R1 = -1 and R2 is untouched.
; Note: This subroutine does not check if the input (R0) is valid. 
;       You will implement this functionality in IS_INPUT_VALID. 
;       Also, this routine does not make any updates to the GRID 
;       or Simba's position, as that is the job of the APPLY_MOVE function.
;***********************************************************

CAN_MOVE      
; Your New (Program4) code goes here

;Initialize registers
                            ; R0 input 
                            ; R1 is Input: current row, Output: new row
                            ; R2 is Input: current col, Output: new col
    AND R4, R4, #0          ;clear reg
    AND R3, R3, #0          ;clear reg
    
    LDI R1, currentyrow ; R1 = current row
    LDI R2, currentycol ; R2 = current col

; ASCII char i = x6C, #105
    ADD R4, R4, #15
    ADD R4, R4, #15
    ADD R4, R4, #15
    ADD R4, R4, #15
    ADD R4, R4, #15
    ADD R4, R4, #15
    ADD R4, R4, #15         ; R4 = 105
    NOT R4, R4
    ADD R4, R4, #1          ; R4 = -105 ; 2's Comp
    ADD R3, R0, R4          ; R3 = R0 - 105
    BRz i_ascii_char
; ASCII value j = x6A, #106
    ADD R4, R4, #-1         ; R4 = -106
    ADD R3, R0, R4          ; R3 = R0 - 106
    BRz j_ascii_char
; ASCII value k = x6B, #107
    ADD R4, R4, #-1         ; R4 = -107
    ADD R3, R0, R4          ; R3 = R0 - 107
    BRz k_ascii_char
; ASCII value l = x6C, #108
    ADD R4, R4, #-1         ; R4 = -108
    ADD R3, R0, R4          ; R3 = R0 - 108
    BRz l_ascii_char

;pa ariba
i_ascii_char
    ADD R1, R1, #-1
    BRn ohno_cantmove
    BR yay_canmove

;pa la izquierda
j_ascii_char
    ADD R2, R2, #-1
    BRn ohno_cantmove
    BR yay_canmove

;pa abajo
k_ascii_char
    ADD R1, R1, #1
    AND R3, R3, #0
    ADD R3, R3, #8
    NOT R3, R3 
    ADD R3, R3, #1          ; R4 = -8   ; 2's Comp
    ADD R4, R1, R3          ; R6 = R1 - 8
    BRz ohno_cantmove
    BRn yay_canmove

;pa la derecha
l_ascii_char
    ADD R2, R2, #1
    AND R3, R3, #0
    ADD R3, R3, #8
    NOT R3, R3 
    ADD R3, R3, #1          ; R5 = -8   ; 2's Comp
    ADD R4, R2, R3          ; R6 = R2 - 8
    BRz ohno_cantmove
    BR yay_canmove

ohno_cantmove
    AND R1, R1, #0
    ADD R1, R1, #-1         ; R1 = -1
    LDI R2, currentycol    ; R2 = unchanged

yay_canmove
    AND R3, R3, #0          
    AND R4, R4, #0          ; clean mess, clear registers for next 
    
    JMP R7
  
;***********************************************************
; APPLY_MOVE
; This subroutine makes the move if it can be completed. 
; It checks to see if the movement is possible by calling 
; CAN_MOVE which returns the coordinates of where the move 
; takes Simba (or -1 if movement is not possible as detailed above). 
; If the move is possible then this routine moves Simba
; symbol (*) to the new coordinates and clears any walls (|'s and -'s) 
; as necessary for the movement to take place. 
; In addition,
;   If the movement is off the grid - Output "Cannot Move" to Console
;   If the move is to a Friend's location then you increment the
;     LIFE_COUNT variable; 
;   If the move is to a Hyena's location then you decrement the
;     LIFE_COUNT variable; IF this decrement causes LIFE_COUNT
;     to become Zero then Simba's Symbol changes to X (dead)
; Input:  
;         R0 has move (i or j or k or l)
; Output: None; However yous must update the GRID and 
;               change CURRENT_ROW and CURRENT_COL 
;               if move can be successfully applied.
;               appropriate messages are output to the console 
; Notes:  Calls CAN_MOVE and GRID_ADDRESS             
;***********************************************************

APPLY_MOVE   
; Your New (Program4) code goes here

; Initilization
                            ; R0 = input / outputs
    AND R1, R1, #0          ; new row
    AND R2, R2, #0          ; new col
    AND R3, R3, #0          ; new grid address 
    AND R4, R4, #0          ; old grid address
    AND R5, R5, #0          ; math
    AND R6, R6, #0          ; input character / grid character
    STI R7, jumpity2
    
; old grid address
    ADD R3, R3, R0          ; R3 = input character
    LDI R1, currentyrow     ; R1 = current row
    LDI R2, currentycol     ; R2 = current col
    JSR grid_address        ; output R0 = old grid address
    ADD R4, R4, R0          ; R4 = old grid address
    ADD R0, R3, #0          ; R0 = input character
    ST R4, apply_move_R4
; new grid address
    JSR can_move            ; output R1 = new row , R2 = new col
    ADD R5, R1, #1          ; R1 = -1 if move is off grid, INVALID
    BRz cant_move_string
    JSR grid_address       ; output R0 = new grid address
    ADD R3, R0, #0          ; R3 = new grid address
    LD R4, apply_move_R4   

                            ; clear walls (the vert & hor lines) using x20
                            ; determ if input is i
    LDI R5, currentyrow
    ADD R5, R5, #-1
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R1, R5
    BRz move_i
; determine if the input is J
    LDI R5, currentycol
    ADD R5, R5, #-1
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R2, R5
    BRz move_j
; determine if the input is K
    LDI R5, currentyrow
    ADD R5, R5, #1
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R1, R5
    BRz move_k
; determine if the input is L
    LDI R5, currentycol
    ADD R5, R5, #1
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R2, R5
    BRz move_l
    BR cant_move

move_i ; clear = R3 - 18
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #2              ; R5 = (space)
    STR R5, R4, #-18            
    BR onwards

move_j ; clear = R3 - 1
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #2              ; R5 = (space)
    STR R5, R4, #-1 
    BR onwards

move_k ; clear = R3 + 18
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #2              ; R5 = (space)
    STR R5, R4, #18
    BR onwards

move_l ; clear = R3 + 1
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #2              ; R5 = (space)
    STR R5, R4, #1
    BR onwards

onwards
    STI R1, currentyrow
    STI R2, currentycol
    LDR R6, R3, #0              ; R6 = grid character
    AND R5, R5, #0
; check if symbol is FRIEND
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #10             ; R5 = 70 (Friend)
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R6, R5              ; R5 = R6 - 70
    BRz friendypoo
; check if symbol is HYENA
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #5              ; R5 = 35 (#) (hyena)
    NOT R5, R5
    ADD R5, R5, #1
    ADD R5, R6, R5              ; R5 = R6 - 35
    BRz hyena
    BR move_otravez
    
friendypoo
    LDI R6, ultra_lifecount 
    ADD R6, R6, #1              ; R6 = life count + 1
    STI R6, ultra_lifecount 
    BR move_otravez
    
hyena
    LDI R6, ultra_lifecount 
    ADD R6, R6, #-1              ; R6 = life count - 1
    STI R6, ultra_lifecount 
    BRp move_otravez
; if 0 lives
; clear old grid address
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #2          ; R5 = 32
    STR R5, R4, #0          ; old grid address = (empty)
; add (X) (88) to new grid address
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #13         ; R5 = 88
    STR R5, R3, #0          ; new grid address = X
    BR adios

move_otravez
; clear old grid addy
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #2          ; R5 = 32
    STR R5, R4, #0          ; old grid address = (empty)
; add * (42) to new grid addy
    AND R5, R5, #0
    ADD R5, R5, #15
    ADD R5, R5, #15
    ADD R5, R5, #12         ; R5 = 42
    STR R5, R3, #0          ; new grid address = *
    BR adios

cant_move
    AND R0, R0, #0
    ADD R0, R0, #10
    TRAP x21                ; new line
    LEA   R0, cant_move_string
    TRAP x22
    AND R0, R0, #0
    ADD R0, R0, #10
    TRAP x21                ; new line
    
adios
    LDI R7, jumpity2
    JMP R7

;***********************************************************
; SIMBA_STATUS
; Checks to see if the Simba has reached Home; Dead or still
; Alive
; Input:  None
; Output: R2 is ZERO if Simba is Home; Also Output "Simba is Home"
;         R2 is +1 if Simba is Alive but not home yet
;         R2 is -1 if Simba is Dead (i.e., LIFE_COUNT =0); Also Output"Simba is Dead"
; 
;***********************************************************

SIMBA_STATUS    

    ;remember to print strings
    ; Your code goes here
    
    
;Initialization
    AND R0, R0, #0          ; trap x21
    AND R1, R1, #0          ; altering life count
    AND R2, R2, #0          ; output
    AND R3, R3, #0          ; simba row
    AND R4, R4, #0          ; simba col
    AND R5, R5, #0          ; home row
    AND R6, R6, #0          ; home col
    LDI R3, currentyrow
    LDI R4, currentycol
    LDI R5, homesweetrow
    LDI R6, homesweetcolumn
; check if Simba is home
    NOT R5, R5
    ADD R5, R5, #1
    ADD R1, R3, R5          ; R1 = simba row - home row
    BRnp nothome
    NOT R6, R6
    ADD R6, R6, #1
    ADD R1, R4, R6          ; R1 = simba col - home col
    BRz home

nothome
    LDI R1, ultra_lifecount   ; R1 = # of lives
    BRz rip
    ADD R2, R2, #1          ; R2 = 1 if alive
    BR adiosdos                ; Life Counter fn

rip
    ADD R2, R2, #-1         ; R2 = -1 if alive
    AND R0, R0, #0
    ADD R0, R0, #10
    TRAP x21                ; new line
    LEA R0, rip_simba
    TRAP x22
    AND R0, R0, #0
    ADD R0, R0, #10
    TRAP x21                ; new line
    BR adiosdos                ; Console outputs losing message

home
    AND R2, R2, #0          ; R2 = 0 if home
    AND R0, R0, #0
    ADD R0, R0, #10
    TRAP x21                ; new line
    LEA R0, simba_is_home
    TRAP x22
    AND R0, R0, #0
    ADD R0, R0, #10
    TRAP x21                ; new line
    BR adiosdos                ; Console outputs winning message

adiosdos
    JMP R7
    
; Pseudo-Ops
    ; Used to encode labels as 9 bit 2's Comp
    greatgrid           .FILL Grab_Grid
    currentyrow         .FILL current_row
    currentycol         .FILL current_col
    homesweetrow        .FILL home_row
    homesweetcolumn     .FILL home_col
    ultra_lifecount     .FILL life_count
    apply_move_R4       .BLKW #1
    
    ; Used for console STRINGZ Output for the game
    cant_move_string        .STRINGZ "Cannot Move"
    ascii_space_string      .STRINGZ " "
    simba_is_home           .STRINGZ "Simba is Home"
    rip_simba               .STRINGZ "Simba is Dead"
    
    ; Destination addy for jump
    jumpity2               .FILL x4501
    
    
                        .END

  

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
