# Linux-MIPS-utils
Collection of examples/exercises of MIPS assembly programming for Linux.

## Code etiquette
- use 0b for masks and binary literals
- use `addi $x, $zero, n` instead of `li $x, n` when `n < 2^16`.
- use macros for syscall (see `src/as/syscalls.asm`)
- use unsigned operations when dealing with memory (stack)
