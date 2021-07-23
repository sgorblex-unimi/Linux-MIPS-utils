.include "stack.asm"

	.text

	.globl print_asciiz
# print_asciiz(a0) prints to stdout the content of the zero-terminated string whose address is contained in a0.
#
# Dependends on: strlen
#
# Parameters:
# a0 = base address of the asciiz string.
print_asciiz:
	push $ra
	push $s0
	move $s0, $a0

	jal strlen
	move $a2, $v0
	move $a1, $s0
	addi $v0, $zero, 4004
	addi $a0, $zero, 1
	syscall

	pop $s0
	pop $ra
	jr $ra
