.data
	array:	.space 64 # reserve 64 bytes 
	size:		.word	16  # number of elements in the array 16
	emptyspace:	.asciiz " "
	linebreak:	.asciiz "\n"
	msgEvenItems:	.asciiz "Number of EVEN elements: "
	msgOddItems:	.asciiz "Number of ODD elements: "
.text
	la $a1, array # store array address in $s0
	lw $a2, size  # store the number of elements in $s1
	li $t0, 0 # loop iterator (i)
	
	loop1:
		beq $t0, $a2, loop1Exit # exit out if we reached the array size
		addi $t0, $t0, 1
		jal getRandomNumber
		sw $v0, 0($a1) # put the generated number into the array
		addi $a1, $a1, 4 # move to the next array item space
		j loop1
	loop1Exit:
	
	############### display the randomly generated array
	la $a1, array
	jal printArray # ($a1, $a2) reference, size
	
	jal parseArray
	move $t0, $v0 # same the returned value to $t0

	# display message "number of even elements in the array"
	la $a0, msgEvenItems
	li $v0, 4
	syscall
	# show the count of even items
	move $a0, $t0
	li $v0, 1
	syscall
	
	# add a line break
	la $a0, linebreak
	li $v0, 4
	syscall
	
	# display message "number of ODD elements in the array"
	la $a0, msgOddItems
	li $v0, 4
	syscall
	
	# show the count of even items
	sub $a0, $a2, $t0 # number of items - number of even items = number of odd items
	li $v0, 1
	syscall
	
	# add a line break
	la $a0, linebreak
	li $v0, 4
	syscall
	
	# exit the application
	li $v0, 10
	syscall

# ==========================================
# getOddRandomNumber
# @desc: generates an odd random integer.
# @params: $a0 - upper bound
# @return: $v0 - odd random integer
getRandomNumber:
	# back up the registers onto the stack
	addi $sp, $sp, -12 # reserve 8 bytes
	sw $a0, 0($sp) # save the register onto the stack
	sw $a1, 4($sp) # save the register onto the stack
	sw $ra, 8($sp)
	
	li $v0, 42 # get a random number
	li $a1, 91 # set upper bound of the random
	syscall # random number is saved to $a0
	
	move $v0, $a0 # save the random number to the function return register
	addi $v0, $v0, 10 # the original returned value by random is 0-90, we add 10 to shift the range to 10 - 100
	
	# restore original registers
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 # deallocate stack space
	jr $ra

# ==========================================
# parseArray
# @desc: counts even elements of the array
# @params: $a1 - array address, $a2 - array size
# @return: $v0 - number of even elements
parseArray:
	addi $sp, $sp, -24	# allocate space for 1 registers on the stack
	sw $t0, 0($sp) # save $t0
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $t1, 16($sp)
	sw $ra, 20($sp)
	
	li $t0, 0 # loop counter (i)
	li $t1, 0 # counts how many "even" items are in the array
	parseArrayLoop:
		beq $t0, $a2, breakParseArrayLoop # check if counter ($t0) reached the size ($a2)
		addi $t0, $t0, 1 # increment the loop counter by 1
		lw $a0, ($a1) # load the current item from the array into $a0
		
		jal isEven # check if the element is even
		add $t1, $t1, $v0 # increase count of even items (if isEven returned 1)
		
		addi $a1, $a1, 4 # move to the next item in the array
		j parseArrayLoop
	breakParseArrayLoop:
	# add a line break
	la $a0, linebreak
	li $v0, 4
	syscall
	
	move $v0, $t1 # save the return count
	
	# restore the variables
	lw $t0, 0($sp) # save $t0
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $t1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24 # deallocate stack space
	jr $ra # go back to the main program
	

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