.data

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
	li $v0, 1 # show the generated random number
	syscall
	
	jr $ra # return back out of the function