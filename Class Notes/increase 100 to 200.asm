.data
var1:	.word 100
var4:	.word 0
var5:	.word 0

.text
main:
	lw, $t0, var1
	lw, $t1, var4
	lw, $t8, var5
	
	# 100 + 100 = 200. Used 100 from register $t0, and saved the result to register $t1
	add, $t1, $t0, $t0
	
	# save $t1 value of 200 to var4
	sw, $t1, var4
	
	# same but by using shift
	sll, $t8, $t0, 1
	sw, $t8, var5
	
	li $v0, 10
	syscall