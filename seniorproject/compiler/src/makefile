#from mrbook.org/tutorials/make/
CC=gcc
CFLAGS=-c -Wall 
LDFLAGS= -lm
SOURCES=noc.c\
	utility/utility.c \
	frontend/scanner.c frontend/parser.c frontend/parser_stackops.c \
	initializeNOCC.c \
	backend/irgen.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=noc
all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS) 

.c.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f *.o; rm frontend/*.o; rm utility/*.o; rm *.o; rm backend/*.o
	rm $(EXECUTABLE)

valgrind:
	myvalgrind ./a.out

fresh:
	make clean; make; ./noc
