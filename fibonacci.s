.intel_syntax noprefix

UsageString:
	.asciz "USAGE:  ./test <number 0-300> \n"

Preface:
	.asciz "0x"

Postface:
	.asciz "\n"

Hex:
	.asciz "%llx"

String:
	.asciz "%s\n"

Decimal:
	.asciz "%d"

.globl main
main:

	#If there are more than one command line arguments, error out
	cmp rdi, 2
	jg Error

	#Setting r15 to 0 just in case
	xor r15, r15

	#Setting the stack's base pointer
	mov rbp, rsp

	#If the user did not give a command line argument
	cmp rdi, 2
	jne GrabUserInput #Move to the section that calls fgets and avoids the command line

	#If there is a command line argument, grab the address and add it to a general register
	mov rdi,  QWORD PTR[rsi + 8]
	mov r15, rdi

	#Jump over the user input that runs if there are no command line arguments
	jmp StrToL

GrabUserInput:

	#Creating space in the stack
	sub rsp, 128

	#Setting up the address for fgets
	mov rdi, rsp

	#How much memory fgets can write to
	mov rsi, 128

	#Specify stdin is being used as the iostream
	mov rdx, stdin
	call fgets

	#Save the address to the the start of the string in r15
	mov r15, rsp

StrToL:

	#Handing the string to strtol
	mov rdi, r15

	#Specifying base 10 for strtol
	mov edx, 10

	#Creating more space on the stack for strtol's endptr
	sub rsp, 16
	mov rsi, rsp

	call strtol #dumps command line argument to eax

	#Setting r15 to zero
	xor r15, r15

	#Storing the thing at rsp (endptr from strtol) to r15
	mov r15, [rsp]
	#Deferencing the endptr and comparing it to null, if it is null there were no errors
	cmp BYTE PTR [r15], 0
	je GoodNumber

	#If there is something at the endptr, see if it's a newline from fgets
	#	If it isn't then strtol found non-numeric characters
	cmp BYTE PTR [r15], 0xA
	je GoodNumber

	#If all the checks failed, error out
	jmp Error

GoodNumber:

	#Setting r15 to 0
	xor r15, r15

	#Grabbing the number returned from strtol so jumps and cmps don't modify it
	mov r15, rax

	#If the number is less than zero, error out
	cmp r15, 0
	jl Error

	#If the number is 300 or more, error out
	cmp r15, 300
	jge Error

	#If the number is 0, don't bother with the loop and just print out zero
	cmp r15, 0
	je SmallNumber

	#If the number is 1, don't bother with the loop and just print out one
	cmp r15, 1
	je SmallNumber

	mov ecx, eax #Setting Counter
	inc ecx	#Avoids off by one error since the fib sequence starts at 0

	xor r8, r8 #Temporarily hold values for r12
	xor r9, r9 #Temporarily hold values for r13
	xor r10, r10 #Temporarily hold values for r14
	xor r11, r11 #Temporarily hold values for r15
	xor r12, r12 #Will be the over flow for r13
	xor r13, r13 #Will be the over flow for r14
	xor r14, r14 #Will be the over flow for r15
	xor r15, r15 #The initial register 

	inc r15

	#Fibonacci Loop
1:
	#Flip the values to save them
    xchg r11, r15

	#Add the results together to get the next one
    add r11, r15

	xchg r10, r14
	adc r10, r14 #Will add overflow into another register

	#Repeat for additional overflows
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

	#Complicated way to print out '0x'
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

	#Prints out the first register containing the early digits of the fib number
	mov rdi, OFFSET Hex
	mov rsi, r15
	call printf

	#Complicated way to print out a newline
	mov rdi, OFFSET Postface
	xor rsi, rsi
	call printf

	mov eax, 1

	#Removing all the stack space set aside for a clean close
	sub rbp, rsp
	add rsp, rbp

	ret

SmallNumber:

	#Stack alignment
	push rbp

	mov rdi, OFFSET Preface
	xor rsi, rsi
	call printf

    mov rdi, OFFSET Hex
	mov rsi, rax
    call printf

    mov rax, 1

	#Removing all the stack space set aside for a clean close
	sub rbp, rsp
	add rsp, rbp

    ret

Error:
	#Stack alignment
	push rbp
	mov rdi, OFFSET UsageString
	xor rsi, rsi
	call printf

	mov rax, 0

	#Removing all the stack space set aside for a clean close
	sub rbp, rsp
	add rsp, rbp

	ret

