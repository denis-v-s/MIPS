.data
	msgEven:	.asciiz " is even\n"
	msgOdd:		.asciiz " is odd\n"

.text
main:
	li $v0, 42 # generate random number
	li $a1, 100 # set upper bound for random
	syscall
	
	jal func1 # jump to func1
	
	# exit app
	li $v0, 10
	syscall

func1:
	li $v0, 1 # display the generated random number
	syscall
	
	move $s0, $a0 # save the random number to register $s0
	srl $t0, $a0, 1 # shift right by 1 bit
	sll $t0, $t0, 1 # shift left by 1 bit (this will set lsb to 0)
	bne $s0, $t0, isOdd # if the original random number is not the same (it's lsb is 1) then the number is odd
		# display the number is even message
		la $a0, msgEven
		j next
	isOdd:
		# display the number is odd message
		la $a0, msgOdd
		
	next:
	li $v0, 4
	syscall
	jr $ra # return back out of the function