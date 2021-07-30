.include "syscalls.asm"

	.data

errmsg: .ascii "ERROR: cannot create a directory with the specified path.\n"
argmsg: .ascii "Please provide a path for the new directory.\n"


	.text

.globl __start
__start:
	lw $t0, 0($sp)
	addi $t0, $t0, -2			# s0: number of remaining files
	bnez $t0, argerr

	lw $a0, 8($sp)
	addi $a1, 0b0000000111111111
	mkdir
	bnez $a3, error
	exit 0

error:
	addi $a0, $zero, 1
	la $a1, errmsg
	addi $a2, $zero, 58
	write
	exit 1

argerr:
	addi $a0, $zero, 1
	la $a1, argmsg
	addi $a2, $zero, 45
	write
	exit 1
