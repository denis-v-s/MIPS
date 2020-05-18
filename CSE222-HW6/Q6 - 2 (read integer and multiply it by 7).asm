# Loop method (adding 7, x times)
.data
	x: .word 0
	prompt: .asciiz "Enter an integer: "
	msgResult: .asciiz "Result is "
	linebreak:	.asciiz "\n"
	
.text
	# prompt the user to enter an integer
	la $a0, prompt
	li $v0, 4
	syscall
	
	# get user entry
	li $v0, 5
	syscall
	
	sw $v0, x
	move $t0, $v0   # loop index in $t0
	abs $t0, $t0    # make the number positive, to avoid infinite loop
	addi $t1, $0, 0 # keep track of sum in $t1
	loop:
		beqz $t0, done
		subi $t0, $t0, 1 # decrement the index
		addi $t1, $t1, 7 # increase the sum
		j loop
	done:
	
	# fix the sign of the sum value, if x was negative
	bgtz $v0, skip
		# convert to negative
		sub $t1, $0, $t1
	skip:
	
	# display the multiplication result
	la $a0, msgResult
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	la $a0, linebreak
	li $v0, 4
	syscall
	
	# exit application
	li $v0, 10
	syscall