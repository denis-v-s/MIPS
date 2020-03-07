.data
	msgMonday: .asciiz "Monday\n"
	msgTuesday: .asciiz "Tuesday\n"
	msgWednesday: .asciiz "Wednesday\n"
	msgThursday: .asciiz "Thursday\n"
	msgFriday: .asciiz "Friday\n"
	msgSaturday: .asciiz "Satursday\n"
	msgSunday: .asciiz "Sunday\n"
	
.text
	# get random number in 0 - 6 range
	li $v0, 42
	li $a1, 7 # set an upper bound for the random number (exclusive)
	syscall
	
	move $s0, $a0 # save the random number (from $a0) to register $s0
	
	beq $s0, 1, monday
	beq $s0, 2, tuesday
	beq $s0, 3, wednesday
	beq $s0, 4, thursday
	beq $s0, 5, friday
	beq $s0, 6, saturday
	beq $s0, 0, sunday
	
monday: 
	la $a0, msgMonday
	j done
tuesday:
	la $a0, msgTuesday
	j done
wednesday:
	la $a0, msgWednesday
	j done
thursday:
	la $a0, msgThursday
	j done
friday:
	la $a0, msgFriday
	j done
saturday:
	la $a0, msgSaturday
	j done
sunday:
	la $a0, msgSunday
	j done

done:
	# display the message
	li $v0, 4
	syscall
	
	# exit the application
	li $v0, 10
	syscall