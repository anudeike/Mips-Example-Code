.data
	numbers: .byte 1 2 3 4 5
	sum_header: .asciiz "array sum: "

.text

main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	li $v0, 4	#print sum_header
	la $a0, sum_header
	syscall

	la $t1, numbers	#get arr addr
	li $t2, 5	#get arr length
	addi $sp, $sp, -8	#allocate space for parameters
	sw $t1, 0($sp)		#store parameters
	sw $t2, 4($sp)
	
	jal sum
	move $t0, $v0	#get return value

	li $v0, 1	#now print it
	move $a0, $t0
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


sum:		#function args: $t1 = array_addr, $t2 = array_len
	lw $t1, 0($sp)
	lw $t2, 4($sp)		
	addi $sp, $sp, 8	#deallocate space for parameters

	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	lb $s0, 0($t1)  #s0 is used to store the first number from the array
	li $t0, 1
	bne $t2, $t0, dont_return_first		#base case: return first_number if len==1
	move $v0, $s0
	j return
dont_return_first:

	addi $t1, $t1, 1	#increment addr, effectively removing first element from array
	addi $t2, $t2, -1	#decrement length accordingly
	addi $sp, $sp, -8	#allocate space for parameters
	sw $t1, 0($sp)		#store parameters
	sw $t2, 4($sp)
	jal sum
	add $v0, $s0, $v0	#return first number + sum of the rest
	#the first $v0 on this line contains the function return value, and the second $v0 contains the return value from the recursive call
return:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
