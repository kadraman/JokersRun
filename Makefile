# Makefile for Chroma Cards: Joker's Run (GBC)

# GBDK path - use environment variable or default to ./gbdk
GBDK_HOME ?= ./gbdk

# Emulicious executable (can be overridden via env or CLI)
EMULICIOUS ?= Emulicious.exe

# Compiler and tools
CC = $(GBDK_HOME)/bin/lcc
CFLAGS = -Iinclude -debug
LDFLAGS = -debug -Wl-m -Wl-j

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

# Target
TARGET := $(BIN_DIR)/chromacards.gbc

# Source and object files
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Build target
all: $(TARGET)

$(TARGET): $(OBJECTS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) *.map *.sym *.lst

# Run ROM in Emulicious
run: $(TARGET)
ifeq ($(OS),Windows_NT)
	# Use PowerShell Start-Process to reliably launch GUI apps from Make
	powershell -NoProfile -Command Start-Process -FilePath "$(EMULICIOUS)" -ArgumentList "$(TARGET)"
else
	$(EMULICIOUS) "$(TARGET)" &
endif

.PHONY: all clean run
