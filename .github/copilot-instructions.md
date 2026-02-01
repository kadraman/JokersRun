# GitHub Copilot Instructions for JokersRun

## Project Overview

JokersRun is a poker-themed roguelike deck-building game for the GameBoy Color, written using GBDK (GameBoy Development Kit). The project combines classic poker mechanics with roguelike elements in a retro gaming format.

## Development Environment

- **Target Platform**: GameBoy Color
- **Development Kit**: GBDK (GameBoy Development Kit)
- **Language**: C (for GameBoy Color)
- **Build System**: GBDK toolchain

## Code Style and Conventions

### General Guidelines

- Follow standard C coding conventions for embedded systems
- Keep memory usage minimal - GameBoy Color has limited RAM
- Optimize for performance on 8-bit hardware
- Use clear, descriptive variable and function names
- Comment complex logic, especially hardware-specific code

### GameBoy-Specific Guidelines

- Be mindful of tile-based graphics (8x8 pixel tiles)
- Consider VRAM access limitations during display updates
- Use appropriate memory banks for ROM data
- Follow GameBoy Color hardware constraints (palette limitations, sprite limits, etc.)
- Optimize for the GameBoy's 4MHz CPU

### Naming Conventions

- Use snake_case for function and variable names
- Use UPPER_CASE for constants and macros
- Prefix hardware register access with clear identifiers
- Use meaningful names that reflect game mechanics (e.g., `deal_card`, `shuffle_deck`)

## Architecture

### Game Structure

- **Deck Building**: Poker-themed card mechanics
- **Roguelike Elements**: Procedural generation, permadeath, runs
- **GameBoy Integration**: Hardware-specific rendering and input handling

### Key Components

When working on this project, consider:

- Card rendering and animation systems
- Deck management and poker hand evaluation
- Roguelike progression and randomization
- GameBoy hardware sprite and tile management
- Input handling for GameBoy controls
- Save/load systems using GameBoy SRAM

## Testing

- Test on actual GameBoy Color hardware or accurate emulators
- Verify performance on target hardware
- Check for memory leaks and buffer overflows
- Validate game mechanics and balance

## Build and Deployment

- Use GBDK compilation tools
- Generate `.gb` or `.gbc` ROM files
- Test ROM files in emulators and on hardware

## Important Notes

- Always consider the hardware limitations of the GameBoy Color
- Prioritize performance and memory efficiency
- Maintain compatibility with GameBoy Color specifications
- Keep the poker theme and roguelike mechanics balanced and fun
- Document any hardware-specific optimizations or workarounds

## Resources

- GBDK Documentation: https://gbdk-2020.github.io/gbdk-2020/
- GameBoy Color Technical Reference
- Poker hand rankings and rules
- Roguelike game design principles
