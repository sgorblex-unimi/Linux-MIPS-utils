.include "stack.asm"
.include "syscalls.asm"

.set BUFSIZE,1024

	.data

errmsg: .ascii "ERROR: cannot open one of the specified files.\n"


	.text

.globl __start
# TODO:
# - standard input when no files specified
__start:
	pop $s0
	addi $s0, $s0, -1			# number of files in s0
	pop $t0					# ignoring first argument

	addi $a0, $zero, BUFSIZE
	jal sbrk                        	
	move $s1, $v0  				# buffer address in s1

	loopfiles:
		beqz $s0, end
		pop $a0				# filename in t0
		move $a1, $zero			# open flags
		open
		bnez $a3, error
		move $s2, $v0 			# file descriptor in s2
		loopbuffer:
			move $a0, $s2
			move $a1, $s1
			addi $a2, $zero, BUFSIZE
			read
			move $s3, $v0

			addi $a0, $zero, 1
			move $a1, $s1
			move $a2, $s3
			write

			beq $s3, BUFSIZE, loopbuffer
		addi $s0, $s0, -1
		j loopfiles
	end:
		exit 0

	error:
		addi $a0, $zero, 1
		la $a1, errmsg
		addi $a2, $zero, 47
		write
		exit 1
