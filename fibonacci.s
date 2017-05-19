.intel_syntax noprefix

Format:
	.asciz "%ld\n"

ZeroResult:
	.asciz "0"

OneResult:
	.asciz "1"

TwoResult:
	.asciz "2"

.globl main
main:
	main:
	mov rdi,  QWORD PTR[rsi + 8]
	mov edx, 10
	mov esi, 0

	call strtol #dumps command line argument to eax

	cmp eax, 0
	je ExitZero

	cmp eax, 1
	je ExitOne

	cmp eax, 2
	je ExitTwo

	mov ecx, eax #r15d is counter
	sub ecx, 2
	mov rax, 1
	inc rbx
	inc rdx

1:
	add rax, rbx
	mov rbx, rdx
	mov rdx, rax

	sub ecx, 1
	jnz 1b

	push rbp
	mov rdi, OFFSET Format
	mov rsi, rax
	call printf

	ret


ExitZero:
    mov rdi, OFFSET ZeroResult
    call puts
    mov eax, 1
    ret

ExitOne:
    mov rdi, OFFSET OneResult
    call puts
    mov eax, 1
    ret

ExitTwo:
    mov rdi, OFFSET TwoResult
    call puts
    mov eax, 1
    ret
