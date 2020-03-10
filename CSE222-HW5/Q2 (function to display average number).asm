.data
	size:  .word 2   # size of the array
	array: .space 8 # allocate memory for 2 elements 2 * 4
	linebreak:	.asciiz "\n"
	emptyspace: .asciiz " "
	
.text
	la $t9, array # get memory address of the array
	la $s0, size  # put size of the array into $s0
	
	# load value 2 into the array
	li $t0, 2
	sw $t0, ($t9)
	
	# load value 10 into the array
	li $t0, 10
	sw $t0, ($t9)
	
	jal calculateAverage
	# display the average
	lw $a0, ($v0)
	li $v0, 1
	syscall
	
	# exit the app
	li $v0, 10
	syscall
	
	calculateAverage:
		la $t9, array # get the starting location in memory
		
		addi, $s1, $s1, 0 # keep track of the sum in $s1
		li $t0, 0 # loop counter (i)
		loop1:
			beq $t0, $s0, done1 # break out of the loop
			addi $t0, $t0, 1 # increment the loop counter
			
			lw $t1, ($t9) # get the value of the current item in the array
			add $s1, $s1, $t1 # add it to the sum, in $s1
			
			addi $t9, $t9, 4 # move to the next array item
			j loop1
		done1:
		div $s1, $s0
		mfhi $v0 # save the quotient to the return register $v0
		jr $ra # go back to the main program