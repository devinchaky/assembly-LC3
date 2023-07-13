; Programming Assignment 2
; Student Name: Devin Chaky
; UT Eid: dmc4627
; You are given an array of student records starting at location x3500.
; The array is terminated by a sentinel. Each student record in the array
; has two fields:
;      Score -  A value between 0 and 100
;      Address of Name  -  A value which is the address of a location in memory where
;                          this student's name is stored.
; The end of the array is indicated by the sentinel record whose Score is -1
; The array itself is unordered meaning that the student records dont follow
; any ordering by score or name.
; You are to perform two tasks:
; Task 1: Sort the array in decreasing order of Score. Highest score first.
; Task 2: You are given a name (string) at location x6100, You have to lookup this student 
;         in the linked list (post Task1) and put the student's score at x60FF (i.e., in front of the name)
;         If the student is not in the list then a score of -1 must be written to x5FFF
; Notes:
;       * If two students have the same score then keep their relative order as
;         in the original array.
;       * Names are case-sensitive.

	.ORIG	x3000
; Your code goes here
    LD R1, Address  ;load address of first element
    AND R6, R6, #0  ; init swap counter counter
    AND R5, R5, #0  ; clear reg for arith
    
Loop 
    LDR R3, R1, #0 ; load first score
    BRn Done ; finishes if array has no elements
    LDR R4, R1, #2 ; load second score
 
    BRn Bottom ; if at end of array
  
    NOT R5, R4 ; R5 = R4-R3
    ADD R5, R5, #1
    ADD R5, R5, R3
   
    BRzp Same; skip swap if R3 > R4
 
    LDR R7, R1, #3 ; load names into registers
    LDR R2, R1, #1
    
    STR R4, R1, #0 ;swap R4 and R3 in memory (scores)
    STR R7, R1, #1 ;swap R7 and R2 in memory (names)
    STR R3, R1, #2
    STR R2, R1, #3
    ADD R6, R6, #1 ; increment swap counter
 
Same
    ADD R1, R1, #2 ; move down to next element
    
    BRnzp Loop ; branch back to top of loop
    
Bottom
    LD R1, Address ; set R1 back to top of array
    ADD R6, R6, #0
    
    BRz Done ; check if swap counter is zero
    
    AND R6, R6, #0 ; reset R6
    BRnzp Loop ; loop back to beginning
    
Start
    ADD R2, R2, #2 ; move to next array
    LD R0, Lookup
    BRnzp Again
    
Done ; end of task 1
    LD R0, Lookup ; load addresses into R0 and R2
    LD R2, Address
    
Again
    LDR R3, R2, #1 ; load array address to R3
    LDR R7, R2, #0
    AND R7, R7, #-1 ; check if end of array
    BRn Unique
    
Element
    LDR R4, R3, #0 ; load element values
    LDR R1, R0, #0
    
    NOT R5, R4 ; check if R1 and R4 equal
    ADD R5, R5, #1
    ADD R5, R1, R5
    BRnp Start
    
    ADD R5, R1, R4 ; check if end of string
    BRz Exists
    
    ADD R3, R3, #1 ;increment array element
    ADD R0, R0, #1
    BRnzp Element
    
Exists
    LDR R3, R2, #0 ; store score at x60FF
    LD R0, Lookup
    STR R3, R0, #-1
    BRnzp Ended
    
Unique
    LD R0, Lookup
    STR R7, R0, #-1 ; look up not in array

Ended
	HALT
; Your .FILLs go here
Address     .FILL x3500 ; store address in reachable memory location
Lookup      .FILL x6100
	.END

; Student records are at x3500
    .ORIG	x3500
    .FILL   #55     ; student 0' score
    .FILL   x4700   ; student 0's nameAddr
    .FILL	#75     ; student 1' score
    .FILL   x4100   ; student 1's nameAdd
    .FILL   #65     ; student 2' score
    .FILL   x4200   ; student 2's nameAdd
	.FILL   #-1
    .END

; Joe
	.ORIG	x4700
	.STRINGZ "Joe"
	.END
; Wow
	.ORIG	x4200
	.STRINGZ "Wonder Woman"
	.END
	
; Bat
	.ORIG	x4100
	.STRINGZ "Bat Man"
	.END
	
; Person to Lookup	
	.ORIG   x6100
;       The following lookup should give score of 
	.STRINGZ  "Joe"
;       The following lookup should give score of
;	.STRINGZ  "Bat Man"
;       The following lookup should give score of -1 because Bat man is 
;           spelled with lowercase m; There is no student with that name 
;	.STRINGZ  "Bat man"
	.END
	