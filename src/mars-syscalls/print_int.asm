.include "syscalls.asm"

	.text

	.globl print_int
# print_int(a0) prints to stdout the signed number contained in a0.
#
# Parameters:
# a0: number to be printed
print_int:
	move $t1, $sp		# t1: temporary stack pointer
	
	beqz $a0, zero

	move $t7, $a0		# copy of a0 to later determine sign
	addi $t2, $zero, 10
	bgtz $a0, loop
	
	addi $a0, $a0, -1
	not $a0, $a0		# two's complement
loop:
	addi $t1, $t1, -1
	div $a0, $t2
	mflo $a0		# a0 /= 10
	mfhi $t0		# t0 = old a0 % 10
	addi $t0, $t0, '0'
	sb $t0, 0($t1)
	beqz $a0, store_sign
	j loop
store_sign:
	bgtz $t7, print
	addi $t1, $t1, -1
	addi $t0, $zero, '-'
	sb $t0, 0($t1)
print:
	addi $a0, $zero,  1
	move $a1, $t1
	sub $a2, $sp, $t1
	write
	jr $ra
zero:
	addi $t1, $t1, -1
	addi $t0, $zero, '0'
	sb $t0, 0($t1)
	j print
