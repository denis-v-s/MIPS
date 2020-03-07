.data
var1:	.word 10
var2:	.word 20
var3:	.word 0

.text
main:
	lw $t0, var1
	lw $t1, var2
	
	addi $t1, 100
	
	add $t2, $t0, $t1
	sw $t2, var3
	
	li $v0, 10
	syscall