@Kartikey Sharma 1001659436
.global main
.func main

main:
    BL _prompt
    BL _scanf
    MOV R6, R0
    BL _getchar
    MOV R5, R0
    BL _scanf
    MOV R7, R0
    @MOV R1, R5
    BL _compare
    MOV R10, R0
    BL _printf
    BL main


_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
    CMP R5,  #'+'
    BEQ _SUM

    CMP R5, #'|'
    BEQ _OR

    CMP R5, #'>'
    BEQ _SHIFT_RIGHT

    CMP R5, #'m'
    BEQ _MAX

_SUM:
    MOV R1, R6
    MOV R2, R7
    ADD R0, R1, R2
    MOV PC, LR

_MAX:
    MOV R1, R6
    MOV R2, R7
    CMP R1, R2
    MOVGE R0, R6
    MOVLE R0, R7
    MOV PC, LR

_SHIFT_RIGHT:
    MOV R1, R6
    MOV R2, R7
    LSR R0, R1, R2
    MOV PC, LR

_OR:
    MOV R1, R6
    MOV R2, R7
    ORR R0, R1, R2
    MOV PC, LR

_prompt:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #21             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ returns

_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_printf:
MOV R4, LR          @ store LR since printf call overwrites
LDR R0,=printf_str   @ R0 contains formatted string address
MOV R1, R10
BL printf           @ call printf
MOV PC, R4          @ return


.data

prompt_str:
    .asciz "Enter the operation: "


printf_str:     .ascii      "%d\n"

format_str:
    .asciz      "%d"

read_char:      .ascii      " "



