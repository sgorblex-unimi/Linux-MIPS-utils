.include "syscalls.asm"
.include "stack.asm"


	.data
nl: .ascii "\n"
point:	.ascii "."


	.bss

.macro printchar lab
	li $v0, 4004
	li $a0, 1
	la $a1, \lab
	li $a2, 1
	syscall
.endm

.macro print_integer_part
	# copy input in $s7 as integer
	mfc1 $s7, $f0

	# SIGN
	srl $s0, $s7, 31					# s0 = s

	# EXPONENT
	srl $s1, $s7, 23					# 23x0 s eeeeeeee
	andi $s1, $s1, 0b00000000000000000000000011111111	# 24x0 eeeeeeee
	addi $s1, $s1, -127					# s1 = e

	# MANTISSA
	li $t2, 0b00000000011111111111111111111111		# mask for mantissa
	and $t2, $s7, $t2					# t2 = 9x0 mmmmmmmmmmmmmmmmmmmmmmm (i.e. m)
	bnez $s0, 1f
	# for normalized use leading 1.m
	lui $t3, 0b0000000010000000
	add $t2, $t2, $t3					# t2 = 8x0 1 mmmmmmmmmmmmmmmmmmmmmmm
1:	# for denormalized use leading 0.m

	# STAMPO PARTE INTERA
	li $t0, 23
	sub $t0, $t0, $s1					# only for max exponent 23
	srl $s3, $t2, $t0					# s3 = integer part

	move $a0, $s3
	jal print_int
.endm


.set BASE,10

	.text


.globl print_float
# print_float(f0, a0) prints to stdout the single precision floating point number contained in f0, with precision a0. Precision, when applicable, means digits after '.'. Requesting too much precision makes approximation errors occur.
#
# Parameters:
# a0: number to be printed
print_float:
	push $ra

# TODO:
# functional precision system
# make this work for every number

# it now works only for numbers such that:
# - they are normalized
# - the exponent is between 0 and 23
# - the precision is appropriate
# - they are positive (easy fix though)


	# IEEE 654 32 bit:
	# s eeeeeeee mmmmmmmmmmmmmmmmmmmmmmm
	# s = sign (1 = neg)
	# e = actual exponent (i.e. eeeeeeee -127)
	# m = mantissa
	# b = base of the resulting representation

	move $s6, $a0
	print_integer_part
	beqz $s6, end
	printchar point

	addi $t0, $zero, BASE					# t4 = base
	mtc1 $t0, $f6
	cvt.s.w $f6, $f6					# base as float

decimal:
	beqz $s6, end
	mtc1 $s3, $f4						# integer part as integer
	cvt.s.w $f4, $f4					# integer part as float
	sub.s $f0, $f0, $f4					# f0 = number - integer part
	mul.s $f0, $f0, $f6					# f0 multiplied by base (for printing a new digit)
	print_integer_part
	addi $s6, $s6, -1
	j decimal

end:
	pop $ra
	jr $ra

# vim:ft=asm
