# Define an integer array of size 12
# 1. Initialize this array with random numbers in range [0, 100].
# 2. Display this array; display 5 elements per line.
# 3. Find the maximum and minimum numbers in array, display these 2 numbers
# 4. Calculate the average value (integer) of this array, display this number

.data
	array:	.space 48 # allocate 48 bytes of memory (12 * 4)
	size: .word 12
	linebreak:	.asciiz "\n"
	emptyspace: .asciiz " "
	msgMin: .asciiz "Min: "
	msgMax: .asciiz " Max: "
	msgAvg: .asciiz ", Avg: "

.text
	li $t0, 0 # store loop index in $t0
	lw $t1, size # save size value to $t1
	la $a2, array # get memory location of array
	
loop1:
	li $v0, 42 # get a random number
	li $a1, 101 # set an upper bound of the random (exclusive)
	syscall
	
	sw $a0, 0($a2) # save the random number to the array location
	addi $t0, $t0, 1 # increase loop index by 1
	beq $t0, $t1, done1 # if index reached the size limit, then break out of the loop
	addi $a2, $a2, 4 # shift the write array location by 4 bytes
	j loop1
	
done1:
	la $a2, array # get the starting memory location of array
	li $t0, 0 # loop index
	
loop2:
	lw $a0, 0($a2) # read item in the array
	li $v0, 1 # display the number
	syscall
	
	# add an empty space to separate the numbers
	la $a0, emptyspace
	li $v0, 4
	syscall
	
	addi $t0, $t0, 1 # increase the loop index
	beq $t0, $t1, done2 # exit if we reached the limit
	
	addi $a2, $a2, 4 # shift to the next array element
	j loop2
	
done2:
	# find MIN and MAX values
	# and keep track of the sum in order to calculate the average
	# $s0: min, $s1: max, $s3: sum
	la $a2, array # get the starting memory location of array
	
	lw $s0, ($a2) # min
	lw $s1, ($a2) # max
	lw $s2, ($a2) # sum
	
	li $t0, 1 # loop index
	addi $a2, $a2, 4 # move to index 1 in the array
loop3:
	lw $t4, ($a2) # put the current value to $t4
	bge $t4, $s0, skipMin
		# if current item is less than the MIN
		move $s0, $t4 # update the MIN
skipMin:
	blt $t4, $s1, skipMax
		# if current item is greater than the MAX
		move $s1, $t4 # update the MAX
skipMax:
	add $s2, $s2, $t4	# update the sum
	
	addi $t0, $t0, 1 # increase the loop index
	beq $t0, $t1, done3 # exit the loop if we reached the counter limit
	
	addi $a2, $a2, 4 # shift to the next array element
	
	j loop3
	
done3:
	la $a0, linebreak
	li $v0, 4
	syscall
	
	la $a0, msgMin
	li $v0, 4
	syscall
	
	move $a0, $s0 # get the MIN
	li $v0, 1 # display the MIN
	syscall
	
	la $a0, msgMax
	li $v0, 4
	syscall
	
	move $a0, $s1 # get the MAX
	li $v0, 1 # display the MAX
	syscall
	
	# figure out the average
	div $s2, $t1 # divide SUM by the number of elements
	mflo $s3 # put the quotient into $s3
	
	la $a0, msgAvg
	li $v0, 4
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall
	
	# add an empty space to separate the numbers
	la $a0, linebreak
	li $v0, 4
	syscall

	# exit the application
	li $v0, 10
	syscall
