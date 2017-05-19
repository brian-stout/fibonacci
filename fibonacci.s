.intel_syntax noprefix

Preface:
	.asciz "0x"

Postface:
	.asciz "\n"

Hex:
	.asciz "%llx"

SmallDigit:
	.asciz "%d\n"


.globl main
main:
	main:
	mov rdi,  QWORD PTR[rsi + 8]
	mov edx, 10
	mov esi, 0

	call strtol #dumps command line argument to eax

	cmp eax, 0
	je SmallNumber

	cmp eax, 1
	je SmallNumber

	cmp eax, 2
	je SmallNumber

	mov ecx, eax #Setting Counter
	inc ecx

	xor r8, r8
	xor r9, r9
	xor r10, r10
	xor r11, r11
	xor r12, r12
	xor r13, r13
	xor r14, r14
	xor r15, r15

	inc r15

1:
	#add rax, rbx
	#mov rbx, rdx
	#mov rdx, rax

    xchg r11, r15
    add r11, r15

	xchg r10, r14
	adc r10, r14

	xchg r9, r13
	adc r9, r13

	xchg r8, r12
	adc r8, r12

	sub ecx, 1
	jnz 1b

	push rbp

	mov rdi, OFFSET Preface
	xor rsi, rsi
	call printf

	cmp r12, 0x0
	je ThirdLevelBitSkip

	mov rdi, OFFSET Hex
	mov rsi, r12
	call printf

ThirdLevelBitSkip:
	cmp r13, 0x0
	je SecondLevelBitSkip

	mov rdi, OFFSET Hex
	mov rsi, r13
	call printf

SecondLevelBitSkip:
	cmp r14, 0x0
	je FirstLevelBitSkip

	mov rdi, OFFSET Hex
	mov rsi, r14
	call printf

FirstLevelBitSkip:

	mov rdi, OFFSET Hex
	mov rsi, r15
	call printf

	mov rdi, OFFSET Postface
	xor rsi, rsi
	call printf

	pop rbp

	mov eax, 1
	ret

SmallNumber:
	push rbp

    mov rdi, OFFSET SmallDigit
	mov esi, eax
    call printf

	pop rbp
    mov eax, 1
    ret

