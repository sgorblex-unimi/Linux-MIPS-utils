# sc(num) calls the system call of code num
.macro sc num
	addi $v0, $zero, \num
	syscall
.endm

.macro exit code
	addi $a0, $zero, \code
	sc 4001
.endm

.macro read
	sc 4003
.endm

.macro write
	sc 4004
.endm

.macro open
	sc 4005
.endm

.macro brk
	sc 4045
.endm

.macro getdents
	sc 4141
.endm
