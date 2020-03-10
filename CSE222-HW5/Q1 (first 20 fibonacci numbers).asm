.data
	size: .word 20 # size of the array
	array: .space 80 # allocate memory for 20 elements 20 * 4
	nItemsOnLine:	.word 10 # number of items that will be displayed on a single line
	linebreak:	.asciiz "\n"
	emptyspace: .asciiz " "
	
.text
	li $s0, 20 # the number of loop iterations
	li $t8, 3 # loop counter (i)
	
	la $t9, array # address of the array stored in $t9
	li $t0, 0
	sw $t0, ($t9)
	
	addi $t9, $t9, 4 # move to the next address in memory
	li $t0, 1
	sw $t0, ($t9)
	addi $t9, $t9, 4 # move to the next address in memory
	loop1:
		lw $t0, -4($t9) # get the previous fib number
		lw $t1, -8($t9) # get fib number 2 numbers back
		add $t2, $t0, $t1 # add $t0 and $t1 to get the next fib number
		sw $t2, 0($t9) # save the calculated fib number to the array
		addi $t9, $t9, 4 # move to the next memory location in the array
		
		beq $t8, $s0, done1 # break out of the loop if counter reached $s0
		addi $t8, $t8, 1    # increase the counter
		j loop1
	
	done1:
	
	li $t8, 0 # reset the loop counter to 0
	la $t9, array # get the starting address of the array
	loop2:
		beq $t8, $s0, done2 # break out of the loop if we reached $s0
		addi $t8, $t8, 1 # increment the loop counter
		
		lw $a0, 0($t9) # get the item at current index
		li $v0, 1 # display it
		syscall
		
		addi $t9, $t9, 4 # move to the next memory location
		
		la $a0, emptyspace # display an empty space to separate the numbers
		li $v0, 4
		syscall
		
		beq $t8, 10, addLinebreak 
		j loop2
		addLinebreak:
			la $a0, linebreak
			li $v0, 4
			syscall
			j loop2
	done2:
	
	li $v0, 10 # exit the app
	syscall