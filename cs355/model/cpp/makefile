#from mrbook.org/tutorials/make/
CC=g++
CFLAGS=-c -Wall 
LDFLAGS= -lm 
SOURCES= Service.cpp Customer.cpp Probability.cpp Category.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=hello

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS) 

.c.o:
	$(CC) $(CFLAGS) $< -o $@

