.text

.globl strcomp
strcomp:
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
