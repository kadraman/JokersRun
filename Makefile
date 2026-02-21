# Makefile for Chroma Cards: Joker's Run (GBC)

# GBDK path - use environment variable or default to ./gbdk
GBDK_HOME ?= ./gbdk

# Emulicious executable (can be overridden via env or CLI)
EMULICIOUS ?= Emulicious.exe

# Compiler and tools
CC = $(GBDK_HOME)/bin/lcc
CFLAGS = -Iinclude

# Target
TARGET = chromacards.gbc

# Source files
SOURCES = src/main.c src/cards.c src/poker.c src/jokers.c src/shop.c src/ui.c src/game.c src/tiles.c

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

# Run ROM in Emulicious
run: $(TARGET)
ifeq ($(OS),Windows_NT)
	# Use PowerShell Start-Process to reliably launch GUI apps from Make
	powershell -NoProfile -Command Start-Process -FilePath "$(EMULICIOUS)" -ArgumentList "$(TARGET)"
else
	$(EMULICIOUS) "$(TARGET)" &
endif

.PHONY: all clean run
