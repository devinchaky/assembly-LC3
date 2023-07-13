; Program5.asm
; Name(s): Devin Chaky, Jamee Labberton
; UTEid(s): dmc4627, jnl2428
; Continuously reads from x3600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
    .ORIG x3000
    JSR Setup
Loop
    AND R0, R0, #0
    STI R0, Glob
    JSR GetInput
    JSR ProcessInput
    ADD R0, R0, #0
    BRp Loop
    HALT
    
Setup
    ST R0, SU0  ;callee save
    ST R1, SU1
; set up the keyboard interrupt vector table entry
;M[x0180] <- x2600
    LD R0, KBISR
    STI R0, KBINTVec

; enable keyboard interrupts
; KBSR[14] <- 1 ==== M[xFE00] = x4000
    LDI R0, KBSR
    LD R1, KBINTEN
    NOT R0, R0
    NOT R1, R1
    AND R0, R0, R1
    NOT R0, R0
    STI R0, KBSR
    
    LD R0, SU0  ;callee save
    LD R1, SU1
    RET
SU0 .BLKW #1
SU1 .BLKW #1

; This loop is the proper way to read an input
GetInput
    LDI R0,GLOB
    BRz GetInput  
    RET
 
ProcessInput
    ST R1, PI1
    ST R2, PI2
    ST R7, PI7
    
    LD R1, CS
    LEA R2, SPR
    ADD R2, R2, R1
    LDR R2, R2, #0
    JSRR R2
    ST R1, CS
    
    LD R1, PI1
    LD R2, PI2
    LD R7, PI7
    RET
CS  .fill #0
SPR .fill State0
    .fill State1
    .fill State2
    .fill State3
    .fill State4
    .fill State5
    .fill State6
    .fill State7
PI1 .BLKW #1
PI2 .BLKW #1
PI7 .BLKW #1
    
State0
    ST R3, S03
    LD R3, A_comp1  ;check if kb val is a
    ADD R3, R0, R3
    BRnp State0Done  ;skip if not a
    
    ADD R1, R1, #1  ;increment state counter
State0Done
    PUTC
    LD R3, S03
    RET  ;return to take input
S03 .BLKW #1
    
State1
    ST R3, S13
    ADD R1, R1, #1 ;increment state
    
    LD R3, U_comp1  ;check if u
    ADD R3, R0, R3
    BRz State1Done
    
    ADD R1, R1, #-1 ;decrement (state stays same)
    
    LD R3, A_comp1
    ADD R3, R0, R3
    BRz State1Done
    
    ADD R1, R1, #-1  ; decrement state back to initial
State1Done
    PUTC
    LD R3, S13
    RET
S13 .BLKW #1
    
State2
    ST R0, S20
    ST R3, S23
    LD R3, G_comp1  ;check if g
    ADD R3, R0, R3
    BRz State2G
    
    ADD R1, R1, #-1
    LD R3, A_comp1
    ADD R3, R0, R3
    BRz State2Done
    
    ADD R2, R2, #-1
    BRnzp State2Done
State2G
    ADD R1, R1, #1
    PUTC
    LD R0, ascii_pipe
State2Done
    PUTC
    LD R3, S23
    LD R0, S20
    RET
S23 .BLKW #1
S20 .BLKW #1
    
State3
    ST R3, S33
    ADD R1, R1, #2  ;increase state

    LD R3, U_comp1  ;check if u
    ADD R3, R0, R3
    BRz State3Done
    
    ADD R1, R1, #-1  ;increase state again
State3Done
    PUTC
    LD R3, S33
    RET
S33 .BLKW #1
    
State4
    ST R3, S43
    ADD R1, R1, #1
    LD R3, U_comp1
    ADD R3, R0, R3
    BRz State4Done
    
    ADD R1, R1, #-1
State4Done
    PUTC
    LD R3, S43
    RET
S43 .BLKW #1
    
State5
    ST R3, S53
    ADD R1, R1, #-1 ;decrement state
    
    LD R3, C_comp1  ;check if c
    ADD R3, R0, R3
    BRz State5Done
    
    ADD R1, R1, #1  ;increment state
    
    LD R3, U_comp1  ;check if u
    ADD R3, R0, R3
    BRz State5Done
    
    ADD R1, R1, #1  ;increment state
    
    LD R3, A_comp1
    ADD R3, R0, R3
    BRz State5Done
    
    ADD R1, R1, #1  ;increment state
State5Done
    PUTC
    LD R3, S53
    RET
S53 .BLKW #1
    
State6
    ST R3, S63
    ADD R1, R1, #-2 ;decrement state
    
    LD R3, C_comp1  ;check if c
    ADD R3, R0, R3
    BRz State6Done
    
    ADD R1, R1, #1
    
    LD R3, U_comp1
    ADD R3, R0, R3
    BRz State6Done
    
    ADD R1, R1, #3  ; goes to state 8
    PUTC
    AND R0, R0, #0
    RET
    
State6Done  ;not a or g
    PUTC
    LD R3, S63
    RET
S63 .BLKW #1
    
State7
    ST R3, S73
    ADD R1, R1, #1
    
    LD R3, A_comp1
    ADD R3, R0, R3
    BRnp Cont7
    PUTC
    AND R0, R0, #0
    RET
    
Cont7
    ADD R1, R1, #-3
    
    LD R3, U_comp1
    ADD R3, R0, R3
    BRz State7Done
    
    ADD R2, R2, #-1
State7Done
    PUTC
    LD R3, S73
    RET
S73 .BLKW #1
    
KBINTVec .FILL x0180
KBSR     .FILL xFE00
KBISR    .FILL x2600
KBINTEN  .FILL x4000
GLOB     .FILL x3600
A_comp1  .FILL #-65
U_comp1  .FILL #-85
C_comp1  .FILL #-67
G_comp1  .FILL #-71
ascii_pipe  .FILL #124

	.END

; Interrupt Service Routine
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x3600
        .ORIG x2600
        ST R0, ISRSaveR0
        
        LDI R1, KBDR
        
        LD R0, A_comp
        ADD R0, R1, R0
        BRz Valid_input
        
        LD R0, U_comp
        ADD R0, R1, R0
        BRz Valid_input
        
        LD R0, C_comp
        ADD R0, R1, R0
        BRz Valid_input
        
        LD R0, G_comp
        ADD R0, R1, R0
        BRz Valid_input
        
        BRnzp ISRReturn
        
    Valid_input
        LDI R0, GLOBAddress
        STR R1, R0, #0
        
    ISRReturn
        LD R0, ISRSaveR0
        
        RTI
        
KBDR  .FILL xFE02
A_comp  .FILL #-65
U_comp  .FILL #-85
C_comp  .FILL #-67
G_comp  .FILL #-71
ISRSaveR0   .BLKW #1
GLOBAddress .FILL GLOB

		.END
