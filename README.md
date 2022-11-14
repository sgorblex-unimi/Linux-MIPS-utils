# Linux-MIPS-utils
Collection of examples/exercises of MIPS assembly programming for Linux.

## TODO
Programs that we would like to implement (or merge if someone makes a pull request):

### Coreutils
- [ ] chown/chmod (use of syscalls)
- [ ] wc (efficient IO)
- [ ] head/tail
- [ ] xargs (use of command line arguments)
- [ ] mktemp (use of random)

### Syscalls inspired by MARS
- [ ] print_float (way harder than it looks) - see print_float_wip branch


## Code etiquette
- use 0b for masks and binary literals
- use `addi $x, $zero, n` instead of `li $x, n` when `n < 2^16`.
- use macros for syscall (see `src/as/syscalls.asm`)
- use unsigned operations when dealing with memory (stack)
