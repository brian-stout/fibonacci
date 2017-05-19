.intel_syntax noprefix

ZeroResult:
	.asciz "0"

.globl main
main:
	main:
	mov rdi,  QWORD PTR[rsi + 8]
	mov edx, 10
	mov esi, 0

	call strtol #dumps command line argument to eax

	cmp eax, 0
	je Exit

	ret


Exit:
    mov rdi, OFFSET ZeroResult
    call puts
    mov eax, 1
    ret
