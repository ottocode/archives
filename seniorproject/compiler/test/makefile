#from mrbook.org/tutorials/make/
CC=gcc
CFLAGS=-c -Wall 
LDFLAGS=
SOURCES=testbench.c scannertest.c parsertest.c \
	../src/utility/utility.c \
	../src/frontend/scanner.c ../src/frontend/parser.c ../src/frontend/parser_stackops.c \
	../src/initializeNOCC.c \
	../src/backend/syndirtranslation.c \
	../src/backend/irgen.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=a.out

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS) 

.c.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f *.o; rm ../src/frontend/*.o; rm ../src/utility/*.o; rm ../src/*.o; rm ../src/backend/*.o
	rm $(EXECUTABLE)

valgrind:
	myvalgrind ./a.out

fresh:
	make clean; make; ./a.out

base:
	make clean; make; ./a.out files/parse1file.c

cast:
	make clean; make; ./a.out files/casttest.c

pointer:
	make clean; make; ./a.out files/pointertest.c

jump:
	make clean; make; ./a.out files/jumptest.c

undeclared:
	make clean; make; ./a.out files/undeclaredtest.c

array:
	make clean; make; ./a.out files/arraytest.c
