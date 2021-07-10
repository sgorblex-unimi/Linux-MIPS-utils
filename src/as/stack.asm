.macro push reg
	addi $sp, $sp, -4
	sw \reg, 0($sp)
.endm

.macro pop reg
	lw \reg, 0($sp)
	addi $sp, $sp, 4
.endm
