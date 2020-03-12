.data
	array:	.space 40 # reserve 40 bytes
	size:		.byte	10  # number of elements in the array
	
.text
	lw $s1, size  # store the number of elements in $s1
	la $s0, array # store array address in $s0
	li $t0, 0 # loop iterator (i)
	
	li $a0, 101 # pass the upper bound of 101 to the function
	loop1:
		beq $t0, $s1, loop1Exit # exit out if we reached the array size
		addi $t0, $t0, 1
		jal getOddRandomNumber
		sw $v0, 0($s0) # put the generated number into the array
		addi $s0, $s0, 4 # move to the next array item space
	
	loop1Exit:
	# exit the application
	li $v0, 10
	syscall

# ==========================================
# getOddRandomNumber
# @desc: generates an odd random integer.
# @params: $a0 - upper bound
# @return: $v0 - odd random integer
getOddRandomNumber:
	# back up the registers onto the stack
	addi $sp, $sp, -12 # reserve 8 bytes
	sw $a0, 0($sp) # save the register onto the stack
	sw $a1, 4($sp) # save the register onto the stack
	sw $ra, 8($sp)
	
	getOddRandomNumberLoop:
		li $v0, 42 # get a random number
		li $a1, 101
		#sw $a1, 0($a0) # set the upper bound of random
		syscall # random number is saved to $a0
		
		jal getIntegerParity # ($a0)
		# if parity returned 1, then the number was odd, so we are done
		beq $v0, 1, getOddRandomNumberLoopExit
		j getOddRandomNumberLoop
		
	getOddRandomNumberLoopExit:
	move $v0, $a0 # save the random number to the function return register
	# restore original registers
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 8 # deallocate stack space
	jr $ra
	
# ==========================================
# getIntegerParity
# @desc: determines whether an integer is even or odd.
# @params: $a0 - integer to test
# @return: $v0 - 0 if even, 1 if odd
getIntegerParity:
	# back up the registers
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $t0, 4($sp)
	sw $ra, 8($sp)
	
	# logical shift right, then left
	srl $t0, $a0, 1
	sll $t0, $t0, 1
	# if the original number is the same as the shifted number, then the integer is even
	# otherwise it's odd
	seq $v0, $a0, $t0
	
	# restore original registers
	lw $a0, 0($sp)
	lw $t0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 # deallocate stack space
	jr $ra