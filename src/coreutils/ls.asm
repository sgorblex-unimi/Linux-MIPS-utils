.include "stack.asm"
.include "syscalls.asm"
.include "dirent.asm"


	.data

nl:	.ascii "\n"
tab:	.ascii "\t"


	.bss

.macro printchar charaddr
	li $a0, 1
	la $a1, \charaddr
	li $a2, 1
	write
.endm

.set	BUFSIZE,1024


	.data
ST_UNKN:	.asciiz	"?????\t"
ST_FIFO:	.asciiz	"FIFO\t"
ST_CHR:		.asciiz	"char dev"
ST_DIR:		.asciiz	"directory"
ST_BLK:		.asciiz	"block dev"
ST_REG:		.asciiz	"regular\t"
ST_LNK:		.asciiz	"symlink\t"
ST_SOCK:	.asciiz	"socket\t"
ST_WHT:		.asciiz	"whiteout"

dir: 	.asciiz "."
errmsg: .asciiz "ERROR: cannot open the specified directory.\n"


	.text
.globl __start
# TODO:
# - check errors in calls
# - better usage of registers (s)
# - fix flags (see under)
#
# flags for open:
# O_RDONLY          = 00000000
# (O_DIRECTORY)
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

	bnez $a3, error

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

		move $s4, $zero 	# relative position in buffer in s4

		loopfiles:
			bge $s4, $s3, endloopfiles
			add $s5, $s2, $s4

			lw $a0, 0($s5) 		# inode number
			jal print_int
			printchar tab
			lw $t0, 8($s5) 		# reclen
			srl $t0, $t0, 16
			add $s4, $s4, $t0
			add $t0, $s2, $s4
			lb $t0, -1($t0)
			beq $t0, DT_FIFO, FIFO
			beq $t0, DT_CHR, CHR
			beq $t0, DT_DIR, DIR
			beq $t0, DT_BLK, BLK
			beq $t0, DT_REG, REG
			beq $t0, DT_LNK, LNK
			beq $t0, DT_SOCK, SOCK
			beq $t0, DT_WHT, WHT
			la $a0, DT_UNKN
			j filetype
		FIFO:
			la $a0, ST_FIFO
			j filetype
		CHR:
			la $a0, ST_CHR
			j filetype
		DIR:
			la $a0, ST_DIR
			j filetype
		BLK:
			la $a0, ST_BLK
			j filetype
		REG:
			la $a0, ST_REG
			j filetype
		LNK:
			la $a0, ST_LNK
			j filetype
		SOCK:
			la $a0, ST_SOCK
			j filetype
		WHT:
			la $a0, ST_WHT

		filetype:
			jal print_asciiz
			printchar tab

			addi $a0, $s5, 10 	# filename
			jal print_asciiz
			printchar nl
			j loopfiles

		endloopfiles:
			j bufloop

	end:
		exit 0

	error:
		la $a0, errmsg
		jal print_asciiz
		exit 1
