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

dir: 		.asciiz "."
errmsg: 	.asciiz "ERROR: cannot open the specified directory.\n"


	.text

.globl __start
# TODO:
# - check errors in calls
# - fix flags (see under)
#
# flags for open:
# O_RDONLY          = 00000000
# (O_DIRECTORY) note: this is probably not needed if checking getdents errors
__start:
	lw $t0, 0($sp)			# t0: number of arguments
	beq $t0, 1, cwd
	lw $a0, 8($sp)			# a0: directory path

	addi $sp, $sp, 12		# stack cleanup
	j open
cwd:
	la $a0, dir
open:
	move $a1, $zero
	open
	bnez $a3, error
	move $s0, $v0 			# file descriptor in s0

	addi $sp, $sp, BUFSIZE		# buffer in stack (base address in sp)

	bufloop:
		move $a0, $s0
		move $a1, $sp
		addi $a2, $zero, BUFSIZE
		getdents
		beqz $v0, end
		move $s1, $v0 			# s1: bytes read by getdents

		move $s2, $zero 		# s2: relative position in buffer

		loopfiles:
			bge $s2, $s1, endloopfiles
			add $s3, $sp, $s2		# s3: current entry address in buffer

			lw $a0, 0($s3) 
			jal print_int			# print inode number
			printchar tab
			lh $t0, 8($s3) 			# reclen (record size)
			add $s2, $s2, $t0
			add $t0, $sp, $s2
			lb $t0, -1($t0)			# filetype code
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
			jal print_asciiz		# print filetype
			printchar tab

			addi $a0, $s3, 10 
			jal print_asciiz		# print filename
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
