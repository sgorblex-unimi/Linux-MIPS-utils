AS	= as
ASFLAGS = -I src/as

LINKER  = ld
LFLAGS  =

OBJDIR  = obj
BINDIR  = bin
SRCDIR  = src

SRCDIR_COREUTILS := $(SRCDIR)/coreutils
SRCDIR_MARS	 := $(SRCDIR)/mars-syscalls
SRCDIR_STRUTILS	 := $(SRCDIR)/strutils
SRC_COREUTILS	 := $(wildcard $(SRCDIR_COREUTILS)/*.asm)
SRC_MARS	 := $(wildcard $(SRCDIR_MARS)/*.asm)
SRC_STRUTILS	 := $(wildcard $(SRCDIR_STRUTILS)/*.asm)
OBJ_COREUTILS	 := $(SRC_COREUTILS:$(SRCDIR_COREUTILS)/%.asm=$(OBJDIR)/%.o)
OBJ_MARS	 := $(SRC_MARS:$(SRCDIR_MARS)/%.asm=$(OBJDIR)/%.o)
OBJ_STRUTILS	 := $(SRC_STRUTILS:$(SRCDIR_STRUTILS)/%.asm=$(OBJDIR)/%.o)
PROGRAMS	 := ls cat
BINARIES	 := $(PROGRAMS:%=$(BINDIR)/%)

all: $(BINARIES)

$(shell mkdir -p $(BINDIR) $(OBJDIR))

LS_DEPS := ls.o print_asciiz.o print_int.o strlen.o
$(BINDIR)/ls: $(LS_DEPS:%=$(OBJDIR)/%)
	$(LINKER) $(LFLAGS) $(LS_DEPS:%=$(OBJDIR)/%) -o $@

CAT_DEPS := cat.o
$(BINDIR)/cat: $(CAT_DEPS:%=$(OBJDIR)/%)
	$(LINKER) $(LFLAGS) $(CAT_DEPS:%=$(OBJDIR)/%) -o $@

MKDIR_DEPS := mkdir.o
$(BINDIR)/mkdir: $(MKDIR_DEPS:%=$(OBJDIR)/%)
	$(LINKER) $(LFLAGS) $(MKDIR_DEPS:%=$(OBJDIR)/%) -o $@

$(OBJ_COREUTILS): $(OBJDIR)/%.o : $(SRCDIR_COREUTILS)/%.asm
	$(AS) $(ASFLAGS) $< -o $@

$(OBJ_MARS): $(OBJDIR)/%.o : $(SRCDIR_MARS)/%.asm
	$(AS) $(ASFLAGS) $< -o $@

$(OBJ_STRUTILS): $(OBJDIR)/%.o : $(SRCDIR_STRUTILS)/%.asm
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	$(rm) $(OBJDIR)/*.o

.PHONY: remove
remove: clean
	$(rm) $(BINDIR)/$(BINARIES)
