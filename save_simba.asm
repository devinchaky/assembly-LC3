;***********************************************************
; Programming Assignment 4
; Student Name: Devin Chaky
; UT Eid: dmc4627
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
    ST R0, DJSaveR0
    ST R1, DJSaveR1
    ST R3, DJSaveR3
    ST R4, DJSaveR4
    ST R5, DJSaveR5

    LEA R0, ColNum ;print column numbers
    PUTS
    
    LEA R0, Space ;print first row
    PUTS
    LEA R0, Space
    PUTS
    LD R0, GridStart
    PUTS
    
    AND R3, R3, #0 ; create counter
    LD R1, GridStart    ;load gridstart into gridcurrent
    ST R1, GridCurrent
    LD R1, Zero     ;load zero in rownum
    ST R1, RowNum

Loop
    AND R4, R4, #0 ; checker
    ADD R4, R4, #15 ;check if counter is 16
    ADD R4, R4, #1
    NOT R4, R4
    ADD R4, R4, #1
    ADD R4, R3, R4
    BRz GridDone

    LD R1, GridCurrent
    ADD R1, R1, #15
    ADD R1, R1, #3
    ST R1, GridCurrent    ;increment grid address
    
    AND R4, R3, #1 ;check if counter is even
    BRp NoNum
    
    LEA R0, NewLine     ;print row with number
    PUTS
    LEA R0, RowNum
    PUTS
    
    LD R5, RowNum     ;increment row number
    ADD R5, R5, #1
    ST R5, RowNum
    BRnzp PrintGrid
    
NoNum
    LEA R0, NewLine    ;print spaces if not row num
    PUTS
    LEA R0, Space
    PUTS
    LEA R0, Space
    PUTS
    
PrintGrid    
    LD R0, GridCurrent ;print rest of row
    PUTS
    
    ADD R3, R3, #1 ;increment counter
    BRnzp Loop

GridDone
    LEA R0, NewLine ;print space between
    PUTS
    
    LD R0, DJSaveR0
    LD R1, DJSaveR1
    LD R3, DJSaveR3
    LD R4, DJSaveR4
    LD R5, DJSaveR5

    JMP R7
    
; fills
DJSaveR0    .BLKW #1
DJSaveR1    .BLKW #1
DJSaveR3    .BLKW #1
DJSaveR4    .BLKW #1
DJSaveR5    .BLKW #1
ColNum  .STRINGZ "\n   0 1 2 3 4 5 6 7 \n"
GridStart   .FILL GRID
GridCurrent .BLKW #1
Zero    .STRINGZ "0"
RowNum  .BLKW #1
Space   .STRINGZ " "
NewLine .STRINGZ "\n"

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
    ST R0, LJSaveR0
    ST R1, LJSaveR1
    ST R2, LJSaveR2
    ST R3, LJSaveR3
    ST R4, LJSaveR4
    ST R6, LJSaveR6
    ST R7, LJSaveR7

    AND R4, R0, #-1 ;move r0 into r4 (list address)

LJLoop
    LDR R1, R4, #1 ;load row into r1
    LDR R2, R4, #2 ;load column into r2
    LDR R3, R4, #3 ;load char into r3
    JSR GRID_ADDRESS ; get address of element
    
    LD R6, Initial ; check if char is initial
    NOT R6, R6
    ADD R6, R6, #1
    ADD R6, R3, R6
    BRnp NotInit

    LD R3, Star ;if initial change i to *
    LD R6, CR_ADDRESS 
    STR R1, R6, #0 ;store current row
    LD R6, CC_ADDRESS
    STR R2, R6, #0 ;store current column
    
NotInit 
    LD R6, Home ; check if char is home
    NOT R6, R6
    ADD R6, R6, #1
    ADD R6, R3, R6
    BRnp NotHome
    
    LD R6, HR_ADDRESS 
    STR R1, R6, #0 ;store home row
    LD R6, HC_ADDRESS
    STR R2, R6, #0 ;store home column
    
NotHome
    STR R3, R0, #0 ;store char in grid
    
    LDR R4, R4, #0 ;move to next element in list
    BRz ListDone ; check if end of list
    BRnzp LJLoop
    
ListDone
    LD R0, LJSaveR0
    LD R1, LJSaveR1
    LD R2, LJSaveR2
    LD R3, LJSaveR3
    LD R4, LJSaveR4
    LD R6, LJSaveR6
    LD R7, LJSaveR7

    JMP  R7

;fills
Initial   .fill x49
Home      .fill x48
Star      .fill x2A
CR_ADDRESS  .fill CURRENT_ROW
CC_ADDRESS  .fill CURRENT_COL
HR_ADDRESS  .fill HOME_ROW
HC_ADDRESS  .fill HOME_COL
LJSaveR0    .BLKW #1
LJSaveR1    .BLKW #1
LJSaveR2    .BLKW #1
LJSaveR3    .BLKW #1
LJSaveR4    .BLKW #1
LJSaveR6    .BLKW #1
LJSaveR7    .BLKW #1

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
    ST R1, GASaveR1
    ST R2, GASaveR2
    ST R3, GASaveR3
    ST R4, GASaveR4
    
    ADD R1, R1, R1  ;calc number of rows to move down
    ADD R1, R1, #1
    
    AND R3, R3, #0 ; counter w/ row#
    ADD R3, R3, R1
    
    LD R0, GridStart    ;load gridstart into gridcurrent
    ST R0, GridCurrent
    
Mult17   
    AND R4, R3, #-1 ;check if counter 0
    BRz AddCol

    ADD R0, R0, #15     ;increment by 18 (increment row)
    ADD R0, R0, #3
    ADD R3, R3, #-1     ;decrement counter
    BRnzp Mult17
 
AddCol
    ADD R2, R2, R2  ;increment column
    ADD R2, R2, #1
    ADD R0, R0, R2
    
    LD R1, GASaveR1
    LD R2, GASaveR2
    LD R3, GASaveR3
    LD R4, GASaveR4
    
    JMP R7
    
;fills
GASaveR1 .BLKW #1
GASaveR2 .BLKW #1
GASaveR3 .BLKW #1
GASaveR4 .BLKW #1
GASaveR7 .BLKW #1

;***********************************************************
; IS_INPUT_VALID
; Input: R0 has the move (character i,j,k,l)
; Output:  R2  zero if valid; -1 if invalid
; Notes: Validates move to make sure it is one of i,j,k,l
;        Only checks if a valid character is entered
;***********************************************************

IS_INPUT_VALID
; Your New (Program4) code goes here
    ST R1, IVSaveR1

    LD R1, i_comp ; check if input is i
    ADD R2, R1, R0
    BRz validInput
    
    LD R1, j_comp ;check if input is j
    ADD R2, R1, R0
    BRz validInput
    
    LD R1, k_comp ;check if input is k
    ADD R2, R1, R0
    BRz validInput
    
    LD R1, l_comp ;chekc if input is l
    ADD R2, R1, R0
    BRz validInput
    
    BRnzp invalidInput ;invalid input entered
    
validInput
    AND R2, R2, #0
    BRnzp IVDone
    
invalidInput
    AND R2, R2, #0
    ADD R2, R2, #-1
    
IVDone
    LD R1, IVSaveR1
    
    JMP R7
    
;fills
i_comp  .fill #-105
j_comp  .fill #-106
k_comp  .fill #-107
l_comp  .fill #-108

IVSaveR1    .BLKW #1

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
    ST R2, CMSaveR2
    ST R3, CMSaveR3

    LD R1, i_comp   ;input is i
    ADD R2, R1, R0
    BRz i_input
    
    LD R1, j_comp   ;input is j
    ADD R2, R1, R0
    BRz j_input
    
    LD R1, k_comp
    ADD R2, R1, R0
    BRz k_input
    
    LD R1, l_comp
    ADD R2, R1, R0
    BRz l_input
    
i_input
    LD R1, CURRENT_ROW  ;decrement row
    ADD R1, R1, #-1
    BRn CMInvalid   ;check if row valid
    LD R2, CURRENT_COL ; load r2 with col num
    BRnzp CMDone
    
j_input
    LD R2, CURRENT_COL  ;decrement col
    ADD R2, R2, #-1     ;check if col valid
    BRn CMInvalid
    LD R1, CURRENT_ROW  ;load r1 with row num
    BRnzp CMDone
    
k_input
    LD R1, CURRENT_ROW  ;increment row
    ADD R1, R1, #1
    LD R3, eight_comp
    ADD R3, R1, R3      ;check if row valid
    BRz CMInvalid
    LD R2, CURRENT_COL ; load r2 with col num
    BRnzp CMDone
    
l_input
    LD R2, CURRENT_COL
    ADD R2, R2, #1
    LD R3, eight_comp
    ADD R3, R2, R3
    BRz CMInvalid
    LD R1, CURRENT_ROW ; load r1 with row num
    BRnzp CMDone

CMInvalid
    AND R1, R1, #0  ;return R1=-1 for invalid
    ADD R1, R1, #-1
    LD R2, CMSaveR2
    
CMDone
    LD R3, CMSaveR3

    JMP R7

;fills
eight_comp   .fill #-8

CMSaveR2    .BLKW #1
CMSaveR3    .BLKW #1

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
    ST R0, AMSaveR0
    ST R1, AMSaveR1
    ST R2, AMSaveR2
    ST R3, AMSaveR3
    ST R4, AMSaveR4
    ST R7, AMSaveR7
    
    JSR CAN_MOVE    ;call can_move --> r1=new row, r2=new col
    ADD R1, R1, #0
    BRn NO_MOVE     ;check if entered move is valid
    
    LD R3, i_comp   ;figures out what input move is
    ADD R4, R3, R0
    BRz i_in
    
    LD R3, j_comp   
    ADD R4, R3, R0
    BRz j_in
    
    LD R3, k_comp
    ADD R4, R3, R0
    BRz k_in
    
    LD R3, l_comp
    ADD R4, R3, R0
    BRz l_in

i_in
    JSR GRID_ADDRESS    ;loads new memory loc 
    ADD R3, R0, #15
    ADD R3, R3, #3
    LD R4, Space    ;clears bar below location
    STR R4, R3, #0
    BRnzp AMCont
    
j_in
    JSR GRID_ADDRESS
    ADD R3, R0, #1
    LD R4, Space
    STR R4, R3, #0
    BRnzp AMCont
    
k_in
    JSR GRID_ADDRESS
    ADD R3, R0, #-15
    ADD R3, R3, #-3
    LD R4, Space
    STR R4, R3, #0
    BRnzp AMCont
    
l_in
    JSR GRID_ADDRESS
    ADD R3, R0, #-1
    LD R4, Space
    STR R4, R3, #0
    BRnzp AMCont
    
AMCont
    LDR R3, R0, #0
    LD R4, f_comp   ;check if friend
    ADD R4, R3, R4
    BRz friend_loc
    LD R4, h_comp   ;check if hyena
    ADD R4, R3, R4
    BRz hyena_loc
    BRnzp ReplaceChar   ;neither, branch to replace char
    
friend_loc
    LDI R3, LC_ADDRESS   ;increment life count
    ADD R3, R3, #1
    STI R3, LC_ADDRESS
    BRnzp ReplaceChar
    
hyena_loc
    LDI R3, LC_ADDRESS   ;decrement life count
    ADD R3, R3, #-1
    STI R3, LC_ADDRESS
    ADD R3, R3, #0  ;check  if dead
    BRp ReplaceChar ;not dead
    
    LD R3, x_val    ;stores X for dead simba
    STR R3, R0, #0
    BRnzp AMDone
    
ReplaceChar
    LD R3, Star ;replace new loc with simba
    STR R3, R0, #0
    
AMDone
    ST R1, AMSaveNR     ;temp registers for new loc
    ST R2, AMSaveNC
    LDI R1, CR_ADDRESS
    LDI R2, CC_ADDRESS
    JSR GRID_ADDRESS    ;get old mem location
    
    LD R3, Space    ;clear old location
    STR R3, R0, #0
    
    LD R1, AMSaveNR
    LD R2, AMSaveNC
    STI R1, CR_ADDRESS
    STI R2, CC_ADDRESS
    BRnzp AMFinal
    
NO_MOVE
    LEA R0, CN_MoveST
    PUTS
    
AMFinal
    LD R0, AMSaveR0
    LD R1, AMSaveR1
    LD R2, AMSaveR2
    LD R3, AMSaveR3
    LD R4, AMSaveR4
    LD R7, AMSaveR7

    JMP R7
    
;fills
f_comp  .fill #-70
h_comp  .fill #-35
x_val   .fill #88
AMSaveNR    .BLKW #1
AMSaveNC    .BLKW #1
CN_MoveST   .STRINGZ "\nCannot Move \n"
LC_ADDRESS  .fill LIFE_COUNT

AMSaveR0    .BLKW #1
AMSaveR1    .BLKW #1
AMSaveR2    .BLKW #1
AMSaveR3    .BLKW #1
AMSaveR4    .BLKW #1
AMSaveR7    .BLKW #1

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
    ; Your code goes here
    ST R0, SSSaveR0
    ST R1, SSSaveR1
    ST R3, SSSaveR3
    ST R4, SSSaveR4
    
    LDI R0, CR_ADDRESS  ;load current row and col into r1, r2
    LDI R1, CC_ADDRESS
    
    LDI R2, HR_ADDRESS  ;load home row and col into r2, r3
    LDI R3, HC_ADDRESS
    
    NOT R4, R2
    ADD R4, R4, #1
    ADD R4, R0, R4  ;compare current and home row
    BRnp NotAtHome
    
    NOT R4, R3
    ADD R4, R4, #1
    ADD R4, R1, R4  ;compare current and home col
    BRnp NotAtHome
    
    AND R2, R2, #0  ;simba is home, print string
    LEA R0, SimbaHome
    PUTS
    BRnzp SSDone
    
NotAtHome
    AND R2, R2, #0
    ADD R2, R2, #1
    LDI R0, LC_ADDRESS  ; see if simba is dead
    BRnp SSDone
    
    ADD R2, R2, #-2     ;simba is dead
    LEA R0, SimbaDead
    PUTS

SSDone
    LD R0, SSSaveR0
    LD R1, SSSaveR1
    LD R3, SSSaveR3
    LD R4, SSSaveR4
    
    JMP R7
    
;fills
SSSaveR0    .BLKW #1
SSSaveR1    .BLKW #1
SSSaveR3    .BLKW #1
SSSaveR4    .BLKW #1

SimbaHome   .STRINGZ "\nSimba is Home\n"
SimbaDead   .STRINGZ "\nSimba is Dead\n"
    
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
