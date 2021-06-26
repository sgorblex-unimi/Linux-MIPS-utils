	.data
filename: 	.asciiz "test.txt"

.macro sc num
	addi $v0, $zero, \num
	syscall
.endm

.macro open
	sc 4005
.endm

.macro read
	sc 4003
.endm

.macro write
	sc 4004
.endm

.macro exit
	move $a0, $zero
	sc 4001
.endm

	.text
.globl __start
########################################
#         This program is WIP!         #
########################################
__start:
	la $a0, filename
	move $a1, $zero
	open

	move $s0, $v0 		# file descriptor in s0

	addi $s1, $zero, 1024 	# buffer size
	jal sbrk

	move $s2, $v0  		# buffer

	move $a1, $s2
	move $a0, $s0
	move $a2, $s1
	read

	move $a2, $v0
	addi $a0, $zero, 1
	move $a1, $s2
	write

	exit
