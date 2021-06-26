	.text

	.globl strcmp
# strcmp(a0, a1) compares the two zero-terminated strings whose base addresses are contained in a0 and a1.
#
# Parameters:
# a0 = base address of the first string
# a1 = base address of the second string
#
# Return values:
# v0 = 0 if the two strings are equals, a positive value if the first string is lexically greater than the second one, a negative value otherwise.
strcmp:
	loop:
		lb $t0, 0($a0)
		lb $t1, 0($a1)
		sub $v0, $t0, $t1
		beqz $t0, end
		beqz $t1, end
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		beqz $v0, loop
	end:
		jr $ra
