# Quick Start Guide - Chroma Cards: Joker's Run

## Getting Started in 5 Minutes

### 1. Build the Game

```bash
# Option A: Use the build script
./build.sh

# Option B: Use make directly
make clean
make
```

**Output**: `chromacards.gbc` (32KB Game Boy Color ROM)

### 2. Run the Game

#### On an Emulator (Recommended)
Download a Game Boy Color emulator:
- **BGB** (Windows): https://bgb.bircd.org/
- **SameBoy** (Windows/Mac/Linux): https://sameboy.github.io/
- **mGBA** (All platforms): https://mgba.io/

Then: **File → Open ROM → Select chromacards.gbc**

#### On Real Hardware
- Copy `chromacards.gbc` to a flashcart (e.g., EverDrive-GB)
- Insert into Game Boy Color
- Power on and play!

### 3. Learn to Play

#### First Blind (Tutorial)
1. **Title Screen**: Press START
2. **Blind 1**: Target is 300 points. Press START to begin.
3. **Card Selection**: 
   - Use LEFT/RIGHT to select cards
   - Press A to select all 5 cards
   - Press B to play your hand
4. **Scoring**: See your poker hand and earned points
5. **Repeat**: Play up to 4 hands to reach 300 points
6. **Shop**: Spend money to buy jokers!

#### Core Strategy
- **Round 1-2**: Get 1-2 jokers, focus on consistent hands (pairs)
- **Round 3+**: Build joker combos, aim for big multipliers
- **Winning**: Each blind gets harder - collect jokers to keep up!

### 4. Understanding Scoring

**Score = Chips × Multiplier**

Example hands:
- **Pair**: 10 chips × 2 mult = **20 points**
- **Two Pair**: 20 chips × 2 mult = **40 points**
- **Flush**: 35 chips × 4 mult = **140 points**
- **Straight Flush**: 100 chips × 8 mult = **800 points**

With jokers:
- **Pair + Mult+4 Joker**: 10 chips × 6 mult = **60 points**
- **Flush + Chips+50 + Mult+4**: 85 chips × 8 mult = **680 points**

### 5. Joker Quick Reference

| Joker | Effect | Best For |
|-------|--------|----------|
| **Mult +4** | +4 multiplier | Everything |
| **Chips +50** | +50 base chips | High mult hands |
| **Flush x2** | x2 mult (if flush) | Flush strategy |
| **Lucky** | +1-3 mult random | Any strategy |
| **Face Bonus** | +10 chips per face card | Pair/high card |

### 6. Control Cheat Sheet

| Screen | Controls |
|--------|----------|
| **Card Selection** | LEFT/RIGHT: navigate, A: select, B: play |
| **Shop** | UP/DOWN: navigate, A: buy, B: exit |
| **Other Screens** | A or START: continue |

## Common Questions

### Q: How do I select cards to play?
**A**: Press A on each of the 5 cards to select them all, then press B to evaluate.

### Q: What should I buy first?
**A**: "Mult +4" is the most consistent early joker. Buy 2-3 of them!

### Q: How do I get more money?
**A**: Score more points! You get (score ÷ 10) money per hand.

### Q: Can I discard cards?
**A**: Not yet - discarding isn't implemented. You must play all 5 cards.

### Q: What's the highest score possible?
**A**: With 5 Mult+4 jokers: Royal Flush = 100 × (8 + (5 × 4)) = **2,800 points**!

### Q: Does the game save?
**A**: Not yet - the game resets when you power off.

## Tips for New Players

1. **Don't Skip Pairs**: Even pairs are worth playing - they give money!
2. **Multipliers Stack**: 3× Mult+4 jokers = base mult + 12!
3. **Save Early Money**: Don't buy everything in shop 1-2
4. **Watch Your Hands**: You only get 4 hands per blind
5. **Read the Shop**: Joker costs increase each blind

## Tips for Advanced Players

1. **Joker Combos**: Flush x2 + multiple Mult+4 = massive scores
2. **Efficient Spending**: Calculate joker ROI before buying
3. **Risk Management**: Buy extra hands if target is tight
4. **Late Game Strategy**: All 5 joker slots should be filled
5. **Perfect Blind**: Try to max score on easy blinds for money buffer

## Building from Source

### Prerequisites
- GBDK-2020 (included in `gbdk/` directory)
- Make
- Bash (for build.sh script)

### Build Commands
```bash
make clean    # Remove build artifacts
make          # Compile the game
./build.sh    # Automated build with verification
```

### Modifying the Game
All source code is in `src/` and headers in `include/`:
- `main.c` - Entry point
- `game.c` - Main game loop
- `poker.c` - Hand evaluation
- `jokers.c` - Joker effects
- `shop.c` - Shop system
- `ui.c` - Display rendering
- `cards.c` - Card management

After editing, run `make` to rebuild.

## Need Help?

- **README.md**: Full project documentation
- **FEATURES.md**: Complete feature list and strategies
- **IMPLEMENTATION.md**: Technical implementation details
- **GitHub Issues**: Report bugs or request features

## Have Fun!

Enjoy playing **Chroma Cards: Joker's Run** - the poker roguelike for Game Boy Color!

Good luck reaching the highest blind!
