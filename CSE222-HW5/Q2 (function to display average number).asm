.data
	size:  .word 2   # size of the array
	array: .space 8 # allocate memory for 2 elements 2 * 4
	linebreak:	.asciiz "\n"
	emptyspace: .asciiz " "
	msgAvg:	.asciiz "Average: "
	msgItems:	.asciiz "Items: "
	
.text
	la $a1, array # get memory address of the array
	lw $a2, size  # put size of the array into $a2
	
	# load value 2 into the array
	li $t0, 2
	sw $t0, 0($a1)
	
	# load value 10 into the array
	li $t0, 10
	sw $t0, 4($a1)
	
	jal calculateAverage
	move $s0, $v0 # save the return value to $s0
	
	la $a1, array # get memory address of the array
	# display the items
	la $a0, msgItems
	li $v0, 4
	syscall
	jal printArray
	syscall
		
	# display the average
	la $a0, msgAvg
	li $v0, 4
	syscall
	la $a0, ($s0)
	li $v0, 1
	syscall
	
	# exit the app
	li $v0, 10
	syscall
	
	##=================================================================
	calculateAverage:
		addi $sp, $sp, -12	# allocate space for 3 registers on the stack
		sw $t0, 8($sp) # save $t0
		sw $t1, 4($sp) # save t1
		sw $t2, 0($sp) # save t1
		
		addi, $t2, $t2, 0 # keep track of the sum in $t2
		li $t0, 0 # loop counter (i)
		loop1:
			beq $t0, $a2, done1 # break out of the loop if we reached $a2
			addi $t0, $t0, 1 # increment the loop counter
			
			lw $t1, ($a1) # get the value of the current item in the array
			add $t2, $t2, $t1 # add it to the sum, in $t2
			
			addi $a1, $a1, 4 # move to the next array item
			j loop1
			
		done1:
		div $t2, $a2 # divide the sum by the number of items in the array
		mflo $v0 # save the quotient to the return register $v0
		
		# restore the variables
		lw $t2, 0($sp)
		lw $t1, 4($sp)
		lw $t0, 8($sp)
		addi $sp, $sp, 12 # deallocate stack space
		jr $ra # go back to the main program

	##=================================================================	
	# @desc: printArray iterates through elements in an array and prints them out
	# @params: $a1 array address, $a2 array size
	printArray:
		addi $sp, $sp, -4	# allocate space for 1 registers on the stack
		sw $t0, 0($sp) # save $t0
		
		li $t0, 0 # loop counter (i)
		printArrayLoop:
			beq $t0, $a2, breakPrintArrayLoop # check if counter ($t0) reached the size ($a2)
			addi $t0, $t0, 1 # increment the loop counter by 1
			lw $a0, ($a1) # load the current item from the array into $t1
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
		lw $t0, 0($sp)
		addi $sp, $sp, 4 # deallocate stack space
		jr $ra # go back to the main program
