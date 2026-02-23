#!/bin/bash
# Build script for Chroma Cards: Joker's Run (CrossZGB Edition)

echo "Building Chroma Cards: Joker's Run (CrossZGB)"
echo "==============================================="
echo ""

# Check if ZGB_PATH is set
if [ -z "$ZGB_PATH" ]; then
    echo "ERROR: ZGB_PATH environment variable is not set."
    echo "Please install CrossZGB and set ZGB_PATH to its 'common' directory."
    echo "  Example: export ZGB_PATH=/path/to/CrossZGB/common"
    echo "  See: https://github.com/gbdk-2020/CrossZGB"
    exit 1
fi

echo "Using CrossZGB at: $ZGB_PATH"
echo ""

echo "Cleaning previous build..."
make clean

echo ""
echo "Building game..."
make

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Build successful!"
    echo ""
    echo "Output: build/gbc/JokersRun.gbc"
    if [ -f "build/gbc/JokersRun.gbc" ]; then
        ls -lh build/gbc/JokersRun.gbc
    fi
    echo ""
    echo "You can now run the .gbc file in a GBC emulator!"
else
    echo ""
    echo "✗ Build failed!"
    exit 1
fi

