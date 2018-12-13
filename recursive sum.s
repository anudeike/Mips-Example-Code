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
	
	la $a0, numbers	#set arr addr
	li $a1, 5	#set arr length
	jal sum
	move $t0, $v0	#get return value

	li $v0, 1	#now print it
	move $a0, $t0
	syscall

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


sum:		#function args: $a0 = array_addr, $a1 = array_len
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	lb $s0, 0($a0)  #s0 is used to store the first number from the array
	li $t0, 1
	bne $a1, $t0, dont_return_first		#base case: return first_number if len==1
	move $v0, $s0
	j return
dont_return_first:

	addi $a0, $a0, 1	#increment addr, effectively removing first element from array
	addi $a1, $a1, -1	#decrement length accordingly
	jal sum
	add $v0, $s0, $v0	#return first number + sum of the rest
	#the first $v0 on this line contains the function return value, and the second $v0 contains the return value from the recursive call
return:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
