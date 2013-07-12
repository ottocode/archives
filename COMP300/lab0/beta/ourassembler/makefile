#from mrbook.org/tutorials/make/
CC=gcc
CFLAGS=-c -Wall 
LDFLAGS= -lm
SOURCES= ourass.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=hello

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS) 

.c.o:
	$(CC) $(CFLAGS) $< -o $@

