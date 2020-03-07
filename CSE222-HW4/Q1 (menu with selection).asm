# Display the following menus, ask user to select one item. If 1-3 is selected, display
# message “item x is selected”, (x is the number of a menu item), display menus
# again; if 0 is selected, quit from the program
.data
	menu:	.asciiz "1. Menu Item 1\n2. Menu Item 2\n3. Menu Item 3\n0. Quit\nPlease select from above menu (1-3) to execute one function. Select 0 to quit."
	msgItem: .asciiz "Item "
	msgSelected:	.asciiz " is selected\n"
	msgExit:	.asciiz "Item 0 selected, application will now exit\n"
	
.text
	la $a0, menu
	li $v0, 4
	syscall

loop1:
	li $v0, 5 				 # read user's input
	syscall
	move $t0, $v0			 # save user's entry to $t0
	beq $0, $t0, done1 #if the user entered 0, then exit
	
	# display text "item"
	la $a0, msgItem
	li $v0, 4
	syscall
	
	# display selected value
	la $a0, ($t0)
	li $v0, 1
	syscall
	
	# display text "is selected"
	la $a0, msgSelected
	li $v0, 4
	syscall
	j loop1
	
done1:
	# display exit message
	lw $a0, msgExit
	li $v0, 4
	syscall
	
	# exit application
	li $v0, 10
	syscall