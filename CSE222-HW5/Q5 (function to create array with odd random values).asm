.data
	array:	.space 40 # reserve 40 bytes 
	size:		.word	10  # number of elements in the array
	emptyspace:	.asciiz " "
	linebreak:	.asciiz "\n"
	
.text
	la $a1, array # store array address in $s0
	lw $a2, size  # store the number of elements in $s1
	li $t0, 0 # loop iterator (i)
	
	loop1:
		beq $t0, $a2, loop1Exit # exit out if we reached the array size
		addi $t0, $t0, 1
		jal getOddRandomNumber
		sw $v0, 0($a1) # put the generated number into the array
		addi $a1, $a1, 4 # move to the next array item space
		j loop1
	loop1Exit:
	
	la $a1, array
	jal printArray # ($a1, $a2) reference, size
	
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
		li $a1, 100 # set upper bound of the random
		syscall # random number is saved to $a0
		
		jal isEven # ($a0)
		# if parity returned 1, then the number was odd, so we are done
		beq $v0, 0, getOddRandomNumberLoopExit
		j getOddRandomNumberLoop
		
	getOddRandomNumberLoopExit:
	move $v0, $a0 # save the random number to the function return register
	# restore original registers
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 # deallocate stack space
	jr $ra
	
# ==========================================
# getIntegerParity
# @desc: determines whether an integer is even or odd.
# @params: $a0 - integer to test
# @return: $v0 - 0 if odd, 1 if even
isEven:
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
	
##=================================================================	
# @desc: printArray iterates through elements in an array and prints them out
# @params: $a1 array address, $a2 array size
printArray:
	addi $sp, $sp, -20	# allocate space for 1 registers on the stack
	sw $t0, 0($sp) # save $t0
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $ra, 16($sp)
	
	li $t0, 0 # loop counter (i)
	printArrayLoop:
		beq $t0, $a2, breakPrintArrayLoop # check if counter ($t0) reached the size ($a2)
		addi $t0, $t0, 1 # increment the loop counter by 1
		lw $a0, ($a1) # load the current item from the array into $a0
		addi $a1, $a1, 4 # move to the next item in the array
		
		# display the item
		li $v0, 1
		syscall
		
		la $a0, emptyspace
		li $v0, 4
		syscall
		j printArrayLoop
	breakPrintArrayLoop:
	# add a line break
	la $a0, linebreak
	li $v0, 4
	syscall
	
	# restore the variables
	lw $t0, 0($sp) # save $t0
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20 # deallocate stack space
	jr $ra # go back to the main program
