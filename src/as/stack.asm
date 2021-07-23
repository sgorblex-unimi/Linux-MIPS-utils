.macro push reg
	addiu $sp, $sp, -4
	sw \reg, 0($sp)
.endm

.macro pop reg
	lw \reg, 0($sp)
	addiu $sp, $sp, 4
.endm
