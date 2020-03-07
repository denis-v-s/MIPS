# Input an integer number n, calculate and display the sum, where
# sum = (2^1 + 2^2 + ... + 2^n)
.data
	msgPrompt:	.asciiz "enter n: \n"
	msgSum: .asciiz "The sum is "

.text
	# prompt the user for entry
	la $a0, msgPrompt
	li $v0, 4
	syscall
	
	li $v0, 5 # read user entry
	syscall
	
	move $s0, $v0 # save N to register $s0
	li $t0, 1  # $t0 holds loop counter, initialized to 1
	li $t1, 0x2 # $t1 holds 2^1
	la $s1, ($t1) # $s1 holds our sum
loop1:
	beq $t0, $s0, done1 # if counter $t0 reaches N ($s0), then exit loop
	sll $t1, $t1, 1 # get the next power of two, by shifting the bit left
	add $s1, $s1, $t1 # add it to the sum
	addi $t0, $t0, 1 # increase loop counter by 1
	j loop1
done1:
	# display text "sum is "
	la $a0, msgSum
	li $v0, 4
	syscall
	
	#display the sum
	la $a0, ($s1)
	li $v0, 1
	syscall
	
	#exit application
	li $v0, 10
	syscall