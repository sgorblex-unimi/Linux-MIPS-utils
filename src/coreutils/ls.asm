	.data
dir: 	.asciiz "."

# flags for open:
# O_RDONLY          = 00000000
# (O_DIRECTORY)

.macro sc num
	addi $v0, $zero, \num
	syscall
.endm

.macro open
	sc 4005
.endm

.macro read
	sc 4003
.endm

.macro write
	sc 4004
.endm

.macro exit
	move $a0, $zero
	sc 4001
.endm

.macro getdents
	sc 4141
.endm

.macro pop reg
	lw \reg, 0($sp)
	addi $sp, $sp, 4
.endm

aa: .asciiz "AAAAAAAAA\n"
.macro test
	li $a0, 1
	la $a1, aa
	li $a2, 10
	write
.endm

nl:	.ascii "\n"
tab:	.ascii "\t"
.macro printchar charaddr
	li $a0, 1
	la $a1, \charaddr
	li $a2, 1
	write
.endm

.macro prbrk
	add $a0, $zero, $zero
	addi $v0, $zero, 4045
	syscall
	move $a0, $v0
	jal print_int
	printchar nl
.endm

.set BUFSIZE,1024

	.text
.globl __start
# TODO:
# - check errors in calls
# - filetype (define?)
# - better usage of registers (s)
__start:
	pop $t1
	addi $s0, $s0, -1		# number of files in s0
	pop $t0				# ignoring first argument

	beq $t1, 1, cwd
	pop $a0				# ignoring first argument
	j open
cwd:
	la $a0, dir

open:
	move $a1, $zero
	open

	move $s0, $v0 			# file descriptor in s0

	addi $a0, $zero, BUFSIZE
	jal sbrk

	move $s2, $v0  			# buffer in s2

	bufloop:
		move $a0, $s0
		move $a1, $s2
		addi $a2, $zero, BUFSIZE
		getdents
		beqz $v0, end
		move $s3, $v0 		# bytes read in s3

		move $s4, $zero 	# position in buffer in s4

		loopfiles:
			bge $s4, $s3, endloopfiles
			add $s5, $s2, $s4

			lw $a0, 0($s5) 		# inode number
			jal print_int
			printchar tab
			addi $a0, $s5, 10 	# filename
			jal print_asciiz
			printchar nl
			lw $t0, 8($s5) 		# reclen
			srl $t0, $t0, 16
			add $s4, $s4, $t0
			j loopfiles

		endloopfiles:
			j bufloop

	end:
		exit
