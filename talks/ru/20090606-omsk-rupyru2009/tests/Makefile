c/%: c/%.c
	$(CROSS_PREFIX)gcc $($(notdir $@)_LIBS) -O2 -o $@ $^

PROGS=dd hello pidgits import interp import_mem

pidgits_LIBS=-lgmp
import_LIBS=-lz -lexpat

all: $(addprefix c/,$(PROGS))

clean:
	-rm $(addprefix c/,$(PROGS))
