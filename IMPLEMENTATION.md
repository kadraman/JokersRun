# Implementation Summary: Chroma Cards: Joker's Run

## Overview
Successfully converted a Game Boy Color poker roguelike game from plain GBDK-2020 to CrossZGB, a multi-platform game engine built on top of GBDK-2020. The game logic and rendering are unchanged; the conversion maps the original blocking state machine to CrossZGB's per-frame state system.

## CrossZGB Engine Integration

### Build System
- **Engine**: [CrossZGB](https://github.com/gbdk-2020/CrossZGB/) (built on GBDK-2020)
- **Build**: `make` with `ZGB_PATH` pointing to CrossZGB `common/` directory
- **Targets**: `gbc` (Game Boy Color)
- **Makefile**: Delegates to `$(ZGB_PATH)/src/MakefileCommon`

### CrossZGB State System
Each game state is a separate `.c` file with `START()` and `UPDATE()` functions:
- `START()` is called once when the state is entered
- `UPDATE()` is called every frame until `SetState()` transitions to a new state
- States share data via the global `game` and `deck_pos` variables

### State Files (`src/`)
| File | CrossZGB State | Responsibility |
|------|---------------|----------------|
| `StateTitleScreen.c` | StateTitleScreen | Show title, wait for START → init game |
| `StateBlindSelect.c` | StateBlindSelect | Show blind info, wait for START → play |
| `StatePlayHand.c` | StatePlayHand | Card navigation, selection, discard, play |
| `StateScoring.c` | StateScoring | Evaluate hand, show score, advance |
| `StateShop.c` | StateShop | Shop navigation, purchases, advance blind |
| `StateGameOver.c` | StateGameOver | Show result, press START to restart |

### Input Handling
The original code used blocking `waitpad()` calls. In CrossZGB, `UPDATE()` is called once per frame, so input uses edge detection:
```c
static uint8_t last_keys;
uint8_t just_pressed = keys & (uint8_t)~last_keys;
if (just_pressed & J_A) { /* action */ }
last_keys = keys;
```

### Engine Entry Point (`src/ZGBMain.c`)
```c
#include "ZGBMain.h"
UINT8 next_state = StateTitleScreen;
```

### State Registration (`include/ZGBMain.h`)
```c
#define STATES \
_STATE(StateTitleScreen)\
_STATE(StateBlindSelect)\
_STATE(StatePlayHand)\
_STATE(StateScoring)\
_STATE(StateShop)\
_STATE(StateGameOver)\
STATE_DEF_END

#define SPRITES \
SPRITE_DEF_END
```

## Core Features

### 1. Game Boy Color Target
- ✅ Targets GBC via CrossZGB `TARGETS = gbc`
- ✅ Uses GBC-specific features (color palettes)
- ✅ 160×144 tile-based UI

### 2. Poker Hand Evaluation
Complete poker hand detection system:
- ✅ High Card (5 chips, x1)
- ✅ Pair (10 chips, x2)
- ✅ Two Pair (20 chips, x2)
- ✅ Three of a Kind (30 chips, x3)
- ✅ Straight (30 chips, x4)
- ✅ Flush (35 chips, x4)
- ✅ Full House (40 chips, x4)
- ✅ Four of a Kind (60 chips, x7)
- ✅ Straight Flush (100 chips, x8)
- ✅ Royal Flush (100 chips, x8)

### 3. Joker Modifier System
5 unique joker types:
- ✅ **JOKER_MULTIPLIER**: +4 multiplier
- ✅ **JOKER_CHIP_BONUS**: +50 base chips
- ✅ **JOKER_SUIT_BOOST**: x2 multiplier if all same suit
- ✅ **JOKER_LUCKY**: +1-3 random multiplier
- ✅ **JOKER_FACE_BONUS**: +10 chips per face card

### 4. Shop System
- ✅ 3 shop items per visit
- ✅ Random joker selection (no duplicates)
- ✅ Extra hand / discard purchases
- ✅ Dynamic pricing based on blind level

## Code Structure

### Source Files (`src/`)
- **ZGBMain.c**: CrossZGB entry point
- **StateTitleScreen.c**: Title screen CrossZGB state
- **StateBlindSelect.c**: Blind select CrossZGB state
- **StatePlayHand.c**: Card play CrossZGB state
- **StateScoring.c**: Scoring CrossZGB state
- **StateShop.c**: Shop CrossZGB state
- **StateGameOver.c**: Game over CrossZGB state
- **game.c**: Global game data (`game`, `deck_pos`, `shop_items`) and `init_game()`
- **cards.c**: Deck management, shuffling, card rendering
- **poker.c**: Hand evaluation, scoring
- **jokers.c**: Joker effects
- **shop.c**: Shop item generation and purchase
- **ui.c**: Screen rendering, palette setup, text display
- **tiles.c**: Tile bitmap data

### Header Files (`include/`)
- **ZGBMain.h**: CrossZGB state/sprite registration
- **gametypes.h**: Core data structures (`Card`, `Game`, `HandScore`, etc.)
- **game.h**: Global game state declarations (`game`, `deck_pos`, `shop_items`)
- **cards.h**, **poker.h**, **jokers.h**, **shop.h**, **ui.h**, **tiles.h**: Module headers

## Controls

| Button | Action |
|--------|--------|
| D-Pad Left/Right | Navigate cards in hand |
| D-Pad Up | Select current card |
| D-Pad Down | Deselect current card |
| D-Pad Up/Down | Navigate shop items |
| A | Play selected hand / confirm purchase |
| B | Discard selected cards / exit shop |
| START | Advance screens |

## Known Limitations & Future Enhancements

### Current Limitations
1. No sprite cursor (uses text markers for selection)
2. No sound/music
3. Cards use ASCII rendering
4. No save system

### Potential Enhancements
1. Add proper tile-based card graphics
2. Implement cursor sprite with CrossZGB sprite system
3. Add sound effects using CrossZGB audio support
4. Implement more joker types
5. Add persistent high scores using SRAM

## Conclusion

The game has been successfully converted from a custom GBDK blocking loop to the CrossZGB engine's per-frame state architecture:
- ✅ CrossZGB state files for each game phase
- ✅ Non-blocking per-frame `UPDATE()` logic
- ✅ Shared global game data across all states
- ✅ CrossZGB Makefile build system
- ✅ All original game mechanics preserved

