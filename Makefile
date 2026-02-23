# Makefile for Chroma Cards: Joker's Run (GBC) - CrossZGB Edition
#
# Requires CrossZGB installed with ZGB_PATH environment variable set.
# See: https://github.com/gbdk-2020/CrossZGB
#
# Usage:
#   export ZGB_PATH=/path/to/CrossZGB/common
#   make

# Project name (no spaces or special characters)
PROJECT_NAME = JokersRun

# Target platforms (gbc = Game Boy Color)
TARGETS = gbc

# Build all targets by default
all: $(TARGETS)

# Build type: Debug or Release
BUILD_TYPE = Debug

# Number of ROM banks (A = Automatic)
N_BANKS = A

# Default hardware sprite size (8x8 for this tile-based UI game)
DEFAULT_SPRITES_SIZE = SPRITES_8x8

# Source and include directories (relative to this Makefile)
SRCDIRS = src
INCDIRS = include

# Include the CrossZGB common Makefile
include $(ZGB_PATH)/src/MakefileCommon
