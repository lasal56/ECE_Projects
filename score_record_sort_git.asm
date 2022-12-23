;sort array of student recordxs by score (highest to lowest), lookup a name and put their score in x60FF
.ORIG x3000

;Your code goes here:


;initialize all registers

AND R0, R0, #0 
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0 ;Beginning of Array (address x3500)
AND R4, R4, #0 ;Use for number of elements in array
AND R5, R5, #0
AND R6, R6, #0
AND R7, R7, #0

;Task 1
        LD  R3, Array ;Beginning of array
Loop1   ST  R4, Iterations ;# of elements in array
        LDR R0, R3, #0 ;with each iteration, R3 gets next score until sentinel hit
        BRN CountComplete ;sentinel reached
        ADD R3, R3, #2 ;offset2 from original address (move to next score)
        ADD R4, R4, #1 ;1 iteration of loop
        BRNZP Loop1
        
Countdown
        ADD R4, R4, #-1 ;1 sort iteration is complete
        BRZ Done ;sorting complete

CountComplete
        AND R5, R5, #0 ;reinitialize
        AND R3, R3, #0  ;reinitialize
        LD R3, Array    ;Load R3 with address x3500
        LD R5, Iterations ;Load R5 with # of elements
Loop2
        LDR R0, R3, #0  ;Offset zero, 1st score to be compared
        LDR R6, R3, #2  ;Offset two, 2nd score to be compared
        NOT R6, R6      ;2s comp
        ADD R6, R6, #1  ;2s comp
        ADD R7, R6, R0  ;1st score -- 2nd score = R7, used to compare magnitudes
        BRN Swap        ;If 2nd score greater than 1st, R7==Neg# and swap performed
        
Sorting
        ADD R5, R5, #-1 ;Minus 1 elements left to sort
        BRZ Countdown   ;No more swaps to complete in iteration
        
        ADD R3, R3, #2  ;prep for next iteration (move to next score)
        ADD R1, R1, #2  ;prep for next it
        ADD R2, R2, #2  ;prep for next it
        BRNZP Loop2
        
Swap
        LDR R6, R3, #2  ;Reinitialize R6 with offset2 from starting address of iteration (score 2 to be compared)
        LDR R2, R3, #1  ;Offset 1st name from start of iteration address to prep for swap
        LDR R1, R3, #3  ;Offset 2nd name from start of iteration address to prep for swap
        
        
        STR R6, R3, #0  ;Swap 2nd score with 1st
        STR R0, R3, #2  ;Swap 1st score with 2nd
        STR R1, R3, #1  ;Swap 1st name with second
        STR R2, R3, #3  ;Swap 2nd name with first
        BRNZP Sorting   ;A sorting iteration has been completed
        
Done
;Task 2
        ;Reinitialize registers to 0
        AND R3, R3, #0
        AND R1, R1, #0
        AND R2, R2, #0
        AND R0, R0, #0
        AND R4, R4, #0
        AND R5, R5, #0
        AND R6, R6, #0
        AND R7, R7, #0
        
        LD R3, Lookup   ;R3 is loaded with lookup address (x6100)
        LD R7, Names    ;Offset 1 from starting address so with each iteration this register gives a name and not score
        LDR R1, R7, #0  ;Offset 0 from R7
        LD R6, Iterations ;R6 loaded with # of iterations
        
Loop3          LDR R0, R3, #0 ;Offset 0 from address in R3 at start of iteration
               LDR R2, R1, #0 ;Offset 0 from address in R1 at start of iteration
               NOT R2, R2     ;2s comp
               ADD R2, R2, #1 ;2s comp
               ADD R4, R0, R2 ;If R0--R2=0, values were equal and characters match
               BRZ CharacterMatch 
               BRNP MismatchedCharacters
           
CharacterMatch 
               ADD R0, R0, #0 ;All characters in the name matched (null sentinel reached)
               BRZ NameMatch
               ADD R3, R3, #1 ;move on to next character in lookup name
               ADD R1, R1, #1 ;move on to next character in array character string
               BRNZP Loop3
               
MismatchedCharacters
               LD R3, Lookup
               ADD R7, R7, #2 ;move on to next name to check if this one will match
               LDR R1, R7, #0 ;
               ADD R6, R6, #-1 ;minus 1 of total name options
               BRZ NoMatches ;all names checked, no matches
               BRNP Loop3
               
NoMatches      
               ADD R6, R6, #-1 ;0--1 == -1
               LD  R3, Lookup ;address x6100
               ADD R3, R3, #-1 ;address x60FF
               STR R6, R3, #0; -1 is stored at x60FF, names didnt match
               BRNZP Task2Complete
               
NameMatch      ADD R7, R7, #-1  ;get address of score matched with name
               LD  R3, Lookup   ;address x6100
               ADD R3, R3, #-1  ;address x60FF
               LDR R1, R7, #0   ;Offset 0 from correct score
               STR R1, R3, #0   ;put score into x60FF

Task2Complete
                TRAP x25
                
Array           .FILL x3500
Iterations      .FILL x6500  
Lookup          .FILL x6100
Names           .FILL x3501

                .END

;Array: Stud records are at x3500

        .ORIG x3500
        .FILL #55
        .FILL x4700
        .FILL #75
        .FILL x4100
        .FILL #65
        .FILL x4200
        .FILL #92
        .FILL x4500
        .FILL #36
        .FILL x4400
        .FILL #55
        .FILL x4300
        .FILL #-1
        .END
        

;Character Strings:

;Joe
    .ORIG x4700
    .STRINGZ "Joe"
    .END
    
;Wow
    .ORIG x4500
    .STRINGZ "Wonder Woman"
    .END

;Bat
    .ORIG x4100
    .STRINGZ "Bat Man"
    .END

;Phoeb    
    .ORIG x4300
    .STRINGZ "Phoebe Bridgers"
    .END

;Jan   
    .ORIG x4400
    .STRINGZ "Janis Joplin"
    .END

;TRex   
    .ORIG x4500
    .STRINGZ "TRex"
    .END
    
; Person to Lookup	
        .ORIG   x6100
    	
;       The following lookup should give score of... (55 in current array setup)
;	        .STRINGZ  "Joe"

;       The following lookup should give score of... (75 in current array setup)
;	        .STRINGZ  "Bat Man"

;       The following lookup should give score of -1 because Bat man is 
;           spelled with lowercase m; There is no student with that name 
;	        .STRINGZ  "Bat man"

;       The following lookup should give score of... (55 in current array setup)
	        .STRINGZ  "Phoebe Bridgers"

;       The following lookup should give score of... (36 in current array setup)
;	        .STRINGZ  "Janis Joplin"

;       The following lookup should give score of... (92 in current array setup)
; 	        .STRINGZ  "TRex"
    
    .END
  