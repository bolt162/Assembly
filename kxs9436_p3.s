.global main
.func main

main:
	BL _scanf
	MOV R5, R0
	BL _scanf
	MOV R6, R0
	MOV R1,R5
	MOV R2,R6
	BL _count_partitions
	MOV R1, R0
	MOV R2, R5
	MOV R3, R6
	BL _printf
	B main


_exit:  
   	 MOV R7, #4              @ write syscall, 4
 	 MOV R0, #1              @ outpu sasasasaast stream to monitor, 1
    	 MOV R2, #21             @ print string length
    	 LDR R1, =exit_str       @ string at label exit_str:
     	 SWI 0                    @ execute syscall
    	 MOV R7, #1              @ terminate syscall, 1
	 SWI 0                   @ execute syscall

_count_partitions:
	PUSH {LR}

	CMP R1, #0
	MOVEQ R0, #1
	POPEQ {PC}


	MOVLT R0, #0
	POPLT {PC}

	CMP R2, #0
	MOVEQ R0, #0
	POPEQ {PC}

	PUSH {R7}
	PUSH {R1}
	PUSH {R2}
	SUB R1, R1, R2
	BL _count_partitions
	MOV R7,R0
	POP {R2}
	POP {R1}
	SUB R2, R2, #1
	BL _count_partitions
	ADD R0, R0, R7
	
	POP {R7}
	POP {PC}


_scanf:
    PUSH {LR}               @ store the return address
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =n_str     	    @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {PC}                @ restore the stack pointer and return

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1
    MOV R2, R2             	@ R1 contains printf argument 1 (redundant line)
    MOV R3, R3             	@ R2 contains printf argument 2 (redundant line)
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

.data

n_str:			.asciz		"%d"
printf_str:		.asciz 		"There are %d partitions of %d using integers upto %d\n"
exit_str:       .ascii      "Terminating program.\n"


