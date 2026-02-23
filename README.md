# Chroma Cards: Joker's Run

A Balatro-inspired poker roguelike for the Game Boy Color, built with [CrossZGB](https://github.com/gbdk-2020/CrossZGB/).

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
2. **Play Hands**: Select cards and submit to evaluate your poker hand
3. **Scoring**: See your poker hand and score calculation
4. **Shop**: Purchase jokers or extra hands with earned money
5. **Repeat**: Progress to next blind with increased difficulty

## Controls

- **D-Pad Left/Right**: Navigate cards in hand
- **D-Pad Up**: Select current card
- **D-Pad Down**: Deselect current card
- **D-Pad Up/Down**: Navigate shop items
- **A Button**: Play selected hand, confirm purchase
- **B Button**: Discard selected cards, exit shop
- **START**: Advance screens

## Building

### Prerequisites

- [CrossZGB](https://github.com/gbdk-2020/CrossZGB/releases/latest) installed with `ZGB_PATH` set to the `common` directory
- Make

```bash
# Set ZGB_PATH (Linux/macOS)
export ZGB_PATH=/path/to/CrossZGB/common

# Set ZGB_PATH (Windows)
set ZGB_PATH=C:\path\to\CrossZGB\common
```

### Compile

```bash
make clean
make
```

This will produce `build/gbc/JokersRun.gbc` which can be run on:
- Real Game Boy Color hardware (via flashcart)
- GBC emulators (BGB, SameBoy, mGBA, etc.)

## Project Structure

```
JokersRun/
├── src/
│   ├── ZGBMain.c           # CrossZGB entry point (initial state)
│   ├── StateTitleScreen.c  # Title screen state
│   ├── StateBlindSelect.c  # Blind selection state
│   ├── StatePlayHand.c     # Card play state
│   ├── StateScoring.c      # Scoring state
│   ├── StateShop.c         # Shop state
│   ├── StateGameOver.c     # Game over state
│   ├── game.c              # Global game data and initialization
│   ├── cards.c             # Card management and rendering
│   ├── poker.c             # Poker hand evaluation
│   ├── jokers.c            # Joker modifier system
│   ├── shop.c              # Shop mechanics
│   ├── ui.c                # UI rendering and GBC palettes
│   └── tiles.c             # Tile bitmap data
├── include/
│   ├── ZGBMain.h           # CrossZGB state/sprite registration
│   ├── gametypes.h         # Core data structures
│   ├── game.h              # Global game state declarations
│   ├── cards.h             # Card operations
│   ├── poker.h             # Poker evaluation
│   ├── jokers.h            # Joker system
│   ├── shop.h              # Shop system
│   ├── ui.h                # UI functions
│   └── tiles.h             # Tile constants
├── Makefile
└── README.md
```

## Technical Details

- **Engine**: [CrossZGB](https://github.com/gbdk-2020/CrossZGB/) (built on GBDK-2020)
- **Platform**: Game Boy Color (GBC)
- **Resolution**: 160×144 pixels
- **Rendering**: Tile-based background for all UI elements
- **Sprites**: Reserved for future cursor/highlights
- **Palettes**: 4 background palettes, 4 sprite palettes
- **Memory**: Optimized for GBC VRAM constraints

## CrossZGB Architecture

Each game phase is a CrossZGB state with `START()` (called on entry) and `UPDATE()` (called every frame):

| State | Description |
|-------|-------------|
| `StateTitleScreen` | Logo display, waits for START |
| `StateBlindSelect` | Shows blind target, waits for START |
| `StatePlayHand` | Card selection and hand playing |
| `StateScoring` | Evaluates hand, shows score |
| `StateShop` | Browse and purchase upgrades |
| `StateGameOver` | Displays final blind reached |

## Gameplay Tips

- Focus on building multiplier with jokers early on
- Flush x2 joker is powerful if you can consistently get flushes
- Save money to buy multiple jokers in later shops
- Each blind gets progressively harder - plan your joker strategy!

## Credits

Built with [CrossZGB](https://github.com/gbdk-2020/CrossZGB/) — a multi-platform game engine for Game Boy, based on GBDK-2020.

Inspired by Balatro by LocalThunk

## License

See LICENSE file for details.

