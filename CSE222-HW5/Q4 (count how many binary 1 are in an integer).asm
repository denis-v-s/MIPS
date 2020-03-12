# Define a function to count how many 1’s in an integer number. Return this count

.data
	msgPrompt:	.asciiz "Enter an integer: "
	msgTxt1: "\nThere are "
	msgTxt2: " ones (1) in the entered number "
	linebreak:	.asciiz "\n"
	
.text
	# display message prompt
	la $a0, msgPrompt
	li $v0, 4
	syscall
	
	li $v0, 5 # get the user's entry
	syscall
	
	move $a0, $v0
	
	jal countOnes # ($a0), returns $v0
	move $s0, $v0 # save the returned value to $s0
	
	la $a0, msgTxt1
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	la $a0, msgTxt2
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
	# ==========================================
	# countOnes
	# @desc: looks at the binary representation of an integer and counts how many 1 bits are in it
	# by repeatedly moving 1 bit to the left, 0001 -> 0010 0-> 0100 -> 1000, and applying logical AND
	# @params: $a0 - integer that will be tested
	# @return: $v0 - the number of ones (1)
	countOnes:
		# back up registers onto the stack
		addi $sp, $sp, -16
		sw $t0, 12($sp)
		sw $t1, 8($sp)
		sw $a1, 4($sp)
		sw $a0, 0($sp)
			
		li $a1, 32 # number of loop iterations. There's a total of 32 bits
		li $v0, 0
		li $t0, 0x1
		
		countOnesLoop:
			beq $a1, $0, countOnesLoopEnd # break the loop if we reached 0
			subi $a1, $a1, 1 # reduce the iterations by 1
			
			and $t1, $a0, $t0
			sll $t0, $t0, 1 # shift the testing bit left
			beqz $t1, countOnesLoop # if it's a 0, then no need to count it
			addi $v0, $v0, 1 # current bit was ON, increment the count of 1s
			j countOnesLoop
			
		countOnesLoopEnd:
		
		# restore original registers
		lw $t0, 12($sp)
		lw $t1, 8($sp)
		lw $a1, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, -16 # deallocate stack space
		jr $ra
