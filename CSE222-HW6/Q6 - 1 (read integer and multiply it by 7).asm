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
	
	li $t0, 7 # we are multiplying by 7
	lw $t1, x
	mult $t0, $t1
	
	mflo $t0
	
	# display the multiplication result
	la $a0, msgResult
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, linebreak
	li $v0, 4
	syscall
	
	# exit application
	li $v0, 10
	syscall