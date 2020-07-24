.global main
.func main

main:
    BL  _scanf              @ load the numerator
    MOV R4, R0
    BL  _scanf
    MOV  R5, R0
    BL  _print_nd
    VMOV S0, R4             @ move the numerator to floating point register
    VMOV S1, R5             @ move the denominator to floating point register
    VCVT.F32.S32 S0, S0     @ convert unsigned bit representation to single float
    VCVT.F32.S32 S1, S1     @ convert unsigned bit representation to single float
    BL _divide
    VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL  _printf_result      @ print the result
    B   main                @ branch to exit procedure with no return

_print_nd:
    PUSH {LR}               @ push LR to stack
    LDR R0, =nd_str         @ R0 contains formatted string address
    MOV R1, R4
    MOV R2, R5
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return

_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

_divide:
    VDIV.F32 S2, S0, S1     @ compute S2 = S0 / S1

.data
nd_str:		.asciz	    "%d / %d = "
format_str:	.asciz	    "%d"
result_str:     .asciz      "%f \n"



