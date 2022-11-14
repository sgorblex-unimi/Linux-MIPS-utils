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


	.text

	.globl __start
__start:
	li $t0, 0b01000001010011110001101110111101		# a0 = 12.9442720413
	li $a0, 10
	mtc1 $t0, $f0
	jal print_float
	printchar nl

	li $v0, 4001
	li $a0, 0
	syscall
