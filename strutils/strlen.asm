# requires:
	# a0 = base address of asciiz string
# effects:
	# v0 = length of the string

	.text
	.globl strlen
strlen:
	li $v0, 0
loop:
	lb $t0, 0($a0)
	beqz $t0, exit
	addi $v0, $v0, 1
	addi $a0, $a0, 1
	j loop
exit:
	jr $ra
