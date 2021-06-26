.macro push reg
	addi $sp, $sp, -4
	sw \reg, 0($sp)
.endm

.macro pop reg
	lw \reg, 0($sp)
	addi $sp, $sp, 4
.endm

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
	li $v0, 4004
	li $a0, 1
	syscall

	pop $s0
	pop $ra
	jr $ra
