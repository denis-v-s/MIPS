.data

.text
main:
	addi $a0, $0, 4 # call factorial with argument 4
	
	jal fact
display:
	move $a0, $v0
	li $v0, 1
	syscall
exit:
	li $v0, 10
	syscall
	
fact:
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	addi $t0, $0, 2
	slt $t1, $a0, $t0 # if $a0 is less than 2 (set $t1 flag)
	beq $t1, $0, loop
	
	addi $v0, $0, 1
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra # return 1
	
loop:
	addi $a0, $a0, -1
	jal fact
	
	lw $a0, 4($sp)
	mul $v0, $v0, $a0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra