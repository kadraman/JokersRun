#!/bin/bash
# Quick build test script for Chroma Cards: Joker's Run

echo "Testing build for Chroma Cards: Joker's Run"
echo "============================================"
echo ""

# Check if GBDK is available
if [ ! -d "gbdk" ]; then
    echo "ERROR: GBDK not found in ./gbdk/"
    echo "Please download GBDK-2020 and extract to ./gbdk/"
    exit 1
fi

# Set up PATH
export PATH=$PATH:$(pwd)/gbdk/bin

echo "Cleaning previous build..."
make clean

echo ""
echo "Building game..."
make

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Build successful!"
    echo ""
    echo "Output: chromacards.gbc"
    ls -lh chromacards.gbc
    file chromacards.gbc
    echo ""
    echo "You can now run chromacards.gbc in a GBC emulator!"
else
    echo ""
    echo "✗ Build failed!"
    exit 1
fi
