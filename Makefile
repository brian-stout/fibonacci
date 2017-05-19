ASFLAGS += -W
CFLAGS += -O1 -masm=intel -fno-asynchronous-unwind-tables

BIN=fibonacci
OBJS=fibonacci.o

%.s: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -S -o $@ $^

fibonacci: fibonacci.o

clean:
	$(RM) $(OBJS) ($BIN)
