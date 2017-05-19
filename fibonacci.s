.intel_syntax noprefix

UsageString:
	.asciz "USAGE:  ./test <number 0-300> \n"

Preface:
	.asciz "0x"

Postface:
	.asciz "\n"

Hex:
	.asciz "%llx"

.globl main
main:

	cmp rdi, 2
	jg Error

	xor r15, r15

	mov rbp, rsp

	cmp rdi, 2
	jne GrabUserInput

	mov rdi,  QWORD PTR[rsi + 8]
	mov r15, rdi

	jmp StrToL

GrabUserInput:

	sub rsp, 128
	mov rdi, rsp

	mov rsi, 128
	mov rdx, stdin
	call fgets

	mov r15, rsp

StrToL:

	mov rdi, r15
	mov edx, 10
	mov esi, 0

	call strtol #dumps command line argument to eax

	cmp eax, 0
	je SmallNumber

	cmp eax, 1
	je SmallNumber

	mov ecx, eax #Setting Counter
	inc ecx

	sub rbp, rsp
	add rsp, rbp

	xor r8, r8 # Temporarily hold values for r12
	xor r9, r9 # Temporarily hold values for r13
	xor r10, r10 # Temporarily hold values for r14
	xor r11, r11 # Temporarily hold values for r15
	xor r12, r12 # Will be the over flow for r13
	xor r13, r13 # Will be the over flow for r14
	xor r14, r14 # Will be the over flow for r15
	xor r15, r15 # The initial register 

	inc r15

	#Fibonacci Loop
1:
    xchg r11, r15
    add r11, r15

	xchg r10, r14
	adc r10, r14

	xchg r9, r13
	adc r9, r13

	xchg r8, r12
	adc r8, r12

	#Decrement by one each run through
	sub ecx, 1
	#If counter register 0 end loop
	jnz 1b

	#Stack alignment
	push rbp

	mov rdi, OFFSET Preface
	xor rsi, rsi
	call printf

	# Jump to ThirdOverflowSkip Label to avoid printing hex if empty
	cmp r12, 0x0
	je ThirdOverflowSkip 

	# prints out the overflow register for r13
	# printf("%llx", r12);
	mov rdi, OFFSET Hex
	mov rsi, r12
	call printf

ThirdOverflowSkip:

	# Jump to the SecondOverFlowSkip label to avoid printing hex if empty
	cmp r13, 0x0
	je SecondOverflowSkip

	#Prints the overflow register for r14
	mov rdi, OFFSET Hex
	mov rsi, r13
	call printf

SecondOverflowSkip:

	# Jump to FirstOverFlowSkip label to avoid printing hex if empty
	cmp r14, 0x0
	je FirstOverflowSkip

	#Prints the overflow register for r15
	mov rdi, OFFSET Hex
	mov rsi, r14
	call printf

FirstOverflowSkip:

	mov rdi, OFFSET Hex
	mov rsi, r15
	call printf

	#Prints out the hex of the fibonacci number
	mov rdi, OFFSET Postface
	xor rsi, rsi
	call printf

	pop rbp

	mov eax, 1
	ret

SmallNumber:

	push rbp

	mov rdi, OFFSET Preface
	xor rsi, rsi
	call printf

    mov rdi, OFFSET Hex
	mov rsi, rax
    call printf

	pop rbp
    mov rax, 1
    ret

Error:
	push rbp
	mov rdi, OFFSET UsageString
	xor rsi, rsi
	call printf
	pop rbp
	mov rax, 0
	ret

