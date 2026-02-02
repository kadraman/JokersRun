# Chroma Cards: Joker's Run

A Balatro-inspired poker roguelike for the Game Boy Color, developed using GBDK-2020.

## Description

Chroma Cards: Joker's Run is a tile-based poker roguelike designed specifically for the Game Boy Color. Navigate through increasingly difficult blinds by playing poker hands, collecting joker modifiers, and shopping for upgrades!

## Features

- **Poker Hand Evaluation**: Full poker hand detection including:
  - High Card, Pair, Two Pair
  - Three of a Kind, Straight, Flush
  - Full House, Four of a Kind
  - Straight Flush, Royal Flush

- **Scoring System**: Chips × Multiplier calculation
  - Each hand type has base chips and multiplier values
  - Jokers can modify these values

- **Joker System**: 5 different joker types that modify your scores:
  - **Mult +4**: Adds +4 to multiplier
  - **Chips +50**: Adds +50 base chips
  - **Flush x2**: Doubles multiplier if all cards are same suit
  - **Lucky**: Adds random multiplier bonus
  - **Face Bonus**: +10 chips per face card (J, Q, K)

- **Shop System**: Purchase jokers and extra hands between blinds
- **Progressive Difficulty**: Target scores increase with each blind
- **GBC Optimized**: Uses 4 background palettes and tile-based rendering
- **Minimal VRAM Usage**: Efficient sprite and tile management

## Game Loop

1. **Blind Selection**: View your target score for the round
2. **Play Hands**: Select all 5 cards and submit to evaluate
3. **Scoring**: See your poker hand and score calculation
4. **Shop**: Purchase jokers or extra hands with earned money
5. **Repeat**: Progress to next blind with increased difficulty

## Controls

- **D-Pad**: Navigate menus and select cards
- **A Button**: Select/toggle items, confirm
- **B Button**: Play hand, exit shop
- **START**: Advance screens, skip to shop if target met

## Building

### Prerequisites

- GBDK-2020 (download and extract to `gbdk/` directory, or use included copy)
- Make

### Compile

```bash
make clean
make
```

This will produce `chromacards.gbc` which can be run on:
- Real Game Boy Color hardware (via flashcart)
- GBC emulators (BGB, SameBoy, mGBA, etc.)

## Project Structure

```
JokersRun/
├── src/
│   ├── main.c       # Entry point
│   ├── game.c       # Main game loop and state machine
│   ├── cards.c      # Card management and rendering
│   ├── poker.c      # Poker hand evaluation
│   ├── jokers.c     # Joker modifier system
│   ├── shop.c       # Shop mechanics
│   └── ui.c         # UI rendering and GBC palettes
├── include/
│   ├── gametypes.h  # Core data structures
│   ├── game.h       # Game state management
│   ├── cards.h      # Card operations
│   ├── poker.h      # Poker evaluation
│   ├── jokers.h     # Joker system
│   ├── shop.h       # Shop system
│   └── ui.h         # UI functions
├── Makefile
└── README.md
```

## Technical Details

- **Platform**: Game Boy Color (GBC) exclusive
- **Resolution**: 160×144 pixels
- **Rendering**: Tile-based background for all UI elements
- **Sprites**: Reserved for cursor/highlights only
- **Palettes**: 4 background palettes, 4 sprite palettes
- **Memory**: Optimized for GBC VRAM constraints
- **ROM Size**: 32KB (256Kbit)

## Gameplay Tips

- Focus on building multiplier with jokers early on
- Flush x2 joker is powerful if you can consistently get flushes
- Save money to buy multiple jokers in later shops
- Each blind gets progressively harder - plan your joker strategy!

## Credits

Developed with GBDK-2020 (https://github.com/gbdk-2020/gbdk-2020)

Inspired by Balatro by LocalThunk

## License

See LICENSE file for details.
