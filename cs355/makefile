#from mrbook.org/tutorials/make/
CC=gcc
CFLAGS=-c -Wall 
LDFLAGS= -lm
SOURCES=singleServerQueue.c random.c arrival.c departure.c stats.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=hello

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS) 

.c.o:
	$(CC) $(CFLAGS) $< -o $@

