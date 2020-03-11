# Write MIPS code to prompt user to enter an integer number. Check if the entered
# number is positive or not, if negative, ask user to enter again until a positive number
# is entered; Calculate and display the sum from 1 to this positive number, for
# example, if input number is 6, calculate the sum from 1 through 6. Display this
# positive number and the sum. Define functions to check if a number is positive or
# negative; and calculate the sum.
.data
	msgPrompt:	.asciiz "Enter a positive integer: "
	msgSum: "\nThe sum is: "
	linebreak:	.asciiz "\n"
	
.text
	# dispmay  a prompt for the user to enter a positive integer
prompt:
	la $a0, msgPrompt
	li $v0, 4
	syscall
	
	li $v0, 5 # get the user's entry
	syscall
	
	move $a0, $v0 # save the user's entry to $a0

		# check if the number is positive
	jal isPositive # param ($a0), return ($v0)
	beq $v0, $0, prompt # if the function returned 0, then go back to the prompt
	
	# calculate the sum
	jal sigmaSum # param ($a0), return ($v0)
	
	move $s0, $v0 # save the returned sum to $s0
	
	# display "Sum is"
	la $a0, msgSum
	li $v0, 4
	syscall
	
	# display the calculated sum
	move $a0, $s0
	li $v0, 1
	syscall
	
	li $v0, 10 # exit the app
	syscall
	
	# ==========================================
	# isPositive
	# @desc: checks if the number is positive
	# @params: $a0 - integer that will be tested
	# @return: $v0 will be set to 1 if positive, 0 if negative
	isPositive:
		# if the number is 0, then return 0
		li $v0, 0
		beqz $a0, isPositiveExit
		
		# if $a0 is equal to $a1 after left/right shift, then the number is positive, otherwise it's negative
		move $a1, $a0
		sll $a1, $a1, 1
		srl $a1, $a1, 1
		seq $v0, $a1, $a0 # set $v0 to 1 if $a1 is equal to $a0
		isPositiveExit:
		jr $ra # go back to main program
	
	# ==========================================
	# sigmaSum
	# @desc: calculates the sum of a sequence up to a number
	# @params: $a0 - integer that will be the threshold for sum calculation
	# @return: $v0 - will be set to the sum
	sigmaSum:
		li $a1, 1 # sum calculation starts with 1
		li $v0, 1
		
		sigmaLoop:
			bge $a1, $a0, sigmaLoopEnd # if we reached the threshold then exit the loop
			addi $a1, $a1, 1 # increment
			add $v0, $v0, $a1 # add the increment to the cumulative sum
			j sigmaLoop
			
		sigmaLoopEnd:
		jr $ra # go back to main program