.data
	var1: .word 0
	var2: .word 0
	msgVar1: .asciiz "var1 = "
	msgVar2: .asciiz "var2 = "
	emptyspace:	.asciiz " "
	linebreak:	.asciiz "\n"
	
.text
	# generate the first random variable
	jal getRandomNumber
	sw $v0, var1
	
	# generate the second random variable
	jal getRandomNumber
	sw $v0, var2
	
	# comapre var2 to var1, and swap if var2 > var1
	lw $t1, var1
	lw $t2, var2
	blt $2, $t1, afterSwap
		# swap
		sw $t1, var2
		sw $t2, var1
	
	afterSwap:
	# print the values
	la $a0, msgVar1
	li $v0, 4
	syscall
	
	lw $a0, var1
	li $v0, 1
	syscall
	
	la $a0, emptyspace
	li $v0, 4
	syscall
	
	la $a0, msgVar2
	li $v0, 4
	syscall
	
	lw $a0, var2
	li $v0, 1
	syscall
	
	la $a0, linebreak
	li $v0, 4
	syscall
	
	li $v0, 10 # exit application
	syscall

getRandomNumber:
	# allocate stack space and save register content
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	
	li $v0, 42 # get a random number
	li $a1, 11 # set upper bound
	syscall # random number is saved to $a0
	
	move $v0, $a0 # save the generated random to $v0
	
	# restore registers and deallocate stack space
	lw $a0, 0($sp)
	lw $a1, 4($sp)
  addi $sp, $sp, 8
	jr $ra