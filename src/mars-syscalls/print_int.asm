.include "stack.asm"

	.text

	.globl print_int
# print_int(a0) prints to stdout the signed number contained in a0.
#
# Parameters:
# a0: number to be printed
#
# Errors:
# a3 = 1 if failed brk or write
print_int:
	push $s0
	push $s1
	push $s2
	push $s3

	move $s0, $a0

	li $v0, 4045
	li $a0, 0
	syscall			# brk(0)
	move $s1, $v0

	# allocate 11 bytes
	li $v0, 4045
	addi $a0, $s1, 11
	syscall 		# brk(pr_bk + 11)

	# check brk success
	beq $v0, $s1, error
	move $a1, $v0		# v0: br_bk = first address out of string
	move $s2, $v0


	slt $s3, $s0, $zero
	beqz $s0, zero
	li $t0, 10
	beqz $s3, loop
	addi $s0, $s0, -1
	not $s0, $s0

loop:
	beqz $s0, checkneg	# end loop if s0=0
	addi $a1, $a1, -1
	div $s0, $t0
	mflo $s0		# s0 /= 10
	mfhi $t1		# t1 = s0%10
	addi $t1, $t1, '0'
	sb $t1, 0($a1)
	j loop

zero:
	li $t1, '0'
	addi $a1, $a1, -1
	sb $t1, 0($a1)

checkneg:
	# minus if negative
	beqz $s3, print
	li $t1, '-'
	addi $a1, $a1, -1
	sb $t1, 0($a1)

print:
	sub $a2, $s2, $a1
	li $a0, 1
	li $v0, 4004
	syscall

	li $v0, 4045
	move $a0, $s1
	syscall
	beq $v0, $s2, error
	
end:
	pop $s3
	pop $s2
	pop $s1
	pop $s0
	jr $ra

error:
	li $a3, 1
	j end
