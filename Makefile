# Makefile for Chroma Cards: Joker's Run (GBC)

# GBDK path
GBDK_HOME = ./gbdk

# Compiler and tools
CC = $(GBDK_HOME)/bin/lcc
CFLAGS = -Iinclude

# Target
TARGET = chromacards.gbc

# Source files
SOURCES = src/main.c src/cards.c src/poker.c src/jokers.c src/shop.c src/ui.c src/game.c

# Object files
OBJECTS = $(SOURCES:.c=.o)

# Build target
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) -Wl-yt0x1B -Wl-ya4 -o $(TARGET) $(OBJECTS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJECTS) $(TARGET) *.map *.sym *.lst

.PHONY: all clean
