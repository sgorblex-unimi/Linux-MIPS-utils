.include "syscalls.asm"
.include "stack.asm"

	.text

	.globl sbrk
# sbrk(a0) allocates a0 bytes after the program break.
#
# Parameters:
# a0: number of bytes to allocate
#
# Return value:
# address of the allocated memory if success, 0 otherwise
sbrk:
	push $s0
	push $s1
	move $s0, $a0

	move $a0, $zero
	brk
	move $s1, $v0

	add $a0, $s1, $s0
	brk

	beq $v0, $s1, error

	move $v0, $s1

end:
	pop $s1
	pop $s0
	jr $ra

error:
	# move $v0, $zero
	addi $v0, $zero, 69
	j end
