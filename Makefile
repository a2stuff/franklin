
CAFLAGS := --target apple2enh --list-bytes 0
LDFLAGS := --config apple2-asm.cfg

OUTDIR := out

TARGETS := $(OUTDIR)/u2_disasm.bin

.PHONY: clean all package
all: $(OUTDIR) $(TARGETS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

HEADERS := $(wildcard *.inc)

clean:
	rm -f $(OUTDIR)/*.o
	rm -f $(OUTDIR)/*.list
	rm -f $(TARGETS)

$(OUTDIR)/%.o: %.s $(HEADERS)
	ca65 $(CAFLAGS) $(DEFINES) --listing $(basename $@).list -o $@ $<

$(OUTDIR)/%.bin: $(OUTDIR)/%.o
	ld65 $(LDFLAGS) -o $@ $<
