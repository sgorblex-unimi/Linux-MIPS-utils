	.text
	.globl strlen
# strlen(a0) returns the length of the zero-terminated string whose base address is contained in a0.
#
# Parameters:
# a0 = base address of the string
#
# Return values:
# v0 = length of the string
strlen:
	addi $v0, $zero, 0
loop:
	lb $t0, 0($a0)
	beqz $t0, exit
	addi $v0, $v0, 1
	addi $a0, $a0, 1
	j loop
exit:
	jr $ra
