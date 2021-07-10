.include "stack.asm"

	.text

	.globl sbrk
# sbrk(a0) allocates a0 bytes after the program break.
#
# Parameters:
# a0: number of bytes to allocate
#
# Return value:
# address of the allocated memory if success, -1 otherwise
sbrk:
	push $s0
	move $s0, $a0

	li $v0, 4045
	li $a0, 0
	syscall
	move $s1, $v0

	li $v0, 4045
	add $a0, $s1, $s0
	syscall

	beq $v0, $s1, error
	move $v0, $s1

end:
	pop $s0
	jr $ra

error:
	li $v0, -1
	j end
