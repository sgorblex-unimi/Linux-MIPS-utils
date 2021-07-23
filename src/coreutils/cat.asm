.include "syscalls.asm"

.set BUFSIZE,1024

	.data

errmsg: .ascii "ERROR: cannot open one of the specified files.\n"


	.text

.globl __start
__start:
	lw $s0, 0($sp)
	addi $s0, $s0, -1			# s0: number of remaining files
	beqz $s0, stdin
	addiu $s1, $sp, 8			# s1: secondary stack pointer (array of filenames)

	addi $sp, $sp, -BUFSIZE

	loopfiles:
		beqz $s0, end
		addi $s0, $s0, -1
		lw $a0, 0($s1)				# a0: filename
		addiu $s1, $s1, 4
		move $a1, $zero				# open flags
		open
		bnez $a3, error
		move $s2, $v0 				# s2: file descriptor
		loopbuffer:
			move $a0, $s2
			move $a1, $sp
			addi $a2, $zero, BUFSIZE
			read
			beqz $v0, postloopbuffer

			addi $a0, $zero, 1
			move $a1, $sp
			move $a2, $v0
			write
			j loopbuffer
	postloopbuffer:
		j loopfiles

	stdin:
		addi $s2, $zero, 0
		j loopbuffer

	end:
		exit 0

	error:
		addi $a0, $zero, 1
		la $a1, errmsg
		addi $a2, $zero, 47
		write
		exit 1
