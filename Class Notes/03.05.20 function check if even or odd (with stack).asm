.data
	msgEven:	.asciiz " is even\n"
	msgOdd:		.asciiz " is odd\n"

.text
main:
	li $v0, 42 # generate random number
	li $a1, 100 # set upper bound for random
	syscall
	
	jal func1 # jump to func1
	
	# exit app
	li $v0, 10
	syscall

func1:
	# protect
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	
	li $v0, 42 # generate random number
	li $a1, 100 # set upper bound for random
	syscall
	
	# recover
	lw $a0, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
func2:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	li $t0, 2
	div $a0, $t0
	mfhi $t0
	
	beq $t0, $0, isEven
		la $a0, msgOdd
		j display
	isEven:
		la $a0, msgEven
	display:
		li $v0, 4
		syscall
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	li $v0, 1 # display the generated random number
	syscall
	
	
	li $t0, 2
	div $a0, $t0
	mfhi $t0

	beq $t0, $0, isEven
		# display the number is odd message
		la $a0, msgOdd
		j next
	isEven:
		# display the number is even message
		la $a0, msgEven
		
	next:
	li $v0, 4
	syscall
	jr $ra # return back out of the function