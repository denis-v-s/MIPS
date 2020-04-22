# uses DIV to check if the number is a multiple of 4
.data
	prompt:						.asciiz "Enter an integer number:\n"
	msgDivisible:			.asciiz "the number is a multiple of 4\n"
	msgNotDivisible:	.asciiz "the number is NOT a multiple of 4\n"
	
.text
	# prompt the user to enter an integer
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	
	addi $s0, $0, 4 # place value 4 into $s0
	
	div $v0, $s0 # perform division
	mfhi $t0 # save the remainder to $t0

	li $v0, 4
	bnez $t0, notDivisible	
		la $a0, msgDivisible
		j exitApp
	notDivisible:
		la $a0, msgNotDivisible
		
	exitApp:
	syscall
	li $v0, 10
	syscall