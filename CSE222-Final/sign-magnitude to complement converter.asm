# perform the conversion of 32-bit sign/magnitude binary to 2's complement numbers
# test cases
# (5) "0000 0000 0000 0000 0000 0000 0000 0101" to "0000 0000 0000 0000 0000 0000 0000 0101"
# (5) "00000000000000000000000000000101" to "0000 0000 0000 0000 0000 0000 0000 0101"
# (5) "101" to "0000 0000 0000 0000 0000 0000 0000 0101"

# (0) "0000 0000 0000 0000 0000 0000 0000 0000" to "0000 0000 0000 0000 0000 0000 0000 0000"
# (-0) "1000 0000 0000 0000 0000 0000 0000 0000" to "0000 0000 0000 0000 0000 0000 0000 0000"
# (-1) "1000 0000 0000 0000 0000 0000 0000 0001" to "1111 1111 1111 1111 1111 1111 1111 1111"

# (-5) "1000 0000 0000 0000 0000 0000 0000 0101" to "1111 1111 1111 1111 1111 1111 1111 1101"
# (-5) "10000000000000000000000000000101" to "1111 1111 1111 1111 1111 1111 1111 1101"
.data
	emptyspace:	.asciiz " "
	linebreak:	.asciiz "\n"
	prompt: .asciiz "enter a 32 bit binary number (spaces are ok, 0000 0000 0000 0000 0000 0000 0000 0000)\n"
	one: .asciiz "1"
	zero: .asciiz "0"
	buffer: .space 40 # 40 bits
	
	msgConverted: .asciiz " sign/magniture, converted to two's complement is: "
.text
	# display prompt message to the user
	la $a0, prompt
	li $v0, 4
	syscall
	
	# get the user's entry (string)
	li $v0, 8
	la $a0, buffer
	li $a1, 40 # max of 39 characters
	syscall
	
	move $t0, $a0 # save the user's entry to register $t0
	la $s0, 0x00000000
	la $t8, 0x80000000
	
	# -----------------------------
	# convert the input into binary
	# move through $t0, by loading current bit into $t2 on each loop pass
	loop:
		lb $t2, 0($t0) # load byte into register $t2
		bne $t2, 0x31, next #0x31 = ascii 1
			# if current character is a 1, then add it to LSB
			xor $s0, $s0, 1
		next:
		addi $t0, $t0, 1 # move next
		lb $t2, 0($t0) # check the next byte
		beq $t2, $0, done # if the value is \0 then we are done
		beq $t2, 0xa, done # if the value is 0xa then we are done (the user terminated input with enter key)
		
		# shift left (if the character is not a "space")
		beq $t2, 0x20, loop
			sll $s0, $s0, 1
		j loop
	done:
	
	# -------------------------------
	# display: x converted to two's complement is: 		
	la $a0, msgConverted
	li $v0, 4
	syscall
	
	# -------------------------------
	# $s0 = user's input as actual binary
	# figure out if the input was negative or positive
	andi $s1, $s0, 0x80000000 # msb	
	
	bne $s1, 0x80000000, isPositive
	
	# -------------------------------
	# if MSB is 1, then then number is negative, so we can convert it by
	# subtracting it from 0x80000000 ($t8)
	sub $a1, $t8, $s0
	jal displayHexAsBinary
	j exitApp
	
	# -------------------------------
	# if MSB is 0, then there's no need for conversion, since the number is the same
	# in both, sign/magnitude, and in two's complement
	isPositive:
		#la $a0, testinput
		#li $v0, 4
		#syscall
		
		#la $a0, msgConverted
		#li $v0, 4
		#syscall
		
		move $a1, $s0
		jal displayHexAsBinary # accepts $a1 as parameter
#		la $a0, ($s0)
#		li $v0, 1
#		syscall
	
exitApp:
	li $v0, 10
	syscall
	
	
	
# params: $a1 - hexadecimal to convert
# no return value, this is an action
displayHexAsBinary:
	addi $sp, $sp, -20 # reserve 12 bytes
	sw, $t0, 0($sp)
	sw, $t1, 4($sp)
	sw, $t2, 8($sp)
	sw, $t3, 12($sp)
	sw, $t4, 16($sp)
	
	li $t1, 0x80000000 # will be used for AND opration
	li $t2, 0 # loop index variable
	li $t3, 4 # insert a space every 4 bits
	loop1:
		# apply AND operation to $a0 (hex input) and $t1, and store the result in $t0
		and $t0, $a1, $t1
		
		beqz $t0, isZeroBit # if $t0 is 0, then the bit is 0, otherwise it's 1
			# display one
			la $a0, one
			li $v0, 4
			syscall
			j skipZeroBit
		isZeroBit:
			# display zero
			la $a0, zero
			li $v0, 4
			syscall

		skipZeroBit:
			srl $t1, $t1, 1 # move the bit right 1000 -> 0100 -> 0010 -> 0001 -> etc.
			addi $t2, $t2, 1 # increment loop index
			beq $t2, 32, done1 # we are only looping 32 times, so break out when we reached the condition
			
			# insert a space, every 4 bits, to prettify the output
			div $t2, $t3
			mfhi $t4
			bnez $t4, loop1
				# insert an empty space if remainder is 0
				la $a0, emptyspace
				li $v0, 4
				syscall
			j loop1
	done1:
	
	lw, $t0, 0($sp)
	lw, $t1, 4($sp)
	lw, $t2, 8($sp)
	lw, $t3, 12($sp)
	lw, $t4, 16($sp)
	addi $sp, $sp, 20 # deallocate 16 bytes
jr $ra
