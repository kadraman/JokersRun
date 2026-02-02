# Game Features - Chroma Cards: Joker's Run

## Core Gameplay

### Poker Hands (10 Types)
All standard poker hands are fully implemented with proper detection:

| Hand | Base Chips | Base Multiplier | Example |
|------|------------|-----------------|---------|
| Royal Flush | 100 | 8x | 10♠ J♠ Q♠ K♠ A♠ |
| Straight Flush | 100 | 8x | 5♥ 6♥ 7♥ 8♥ 9♥ |
| Four of a Kind | 60 | 7x | 7♦ 7♣ 7♥ 7♠ 2♣ |
| Full House | 40 | 4x | K♠ K♥ K♦ 3♣ 3♠ |
| Flush | 35 | 4x | 2♦ 5♦ 8♦ J♦ A♦ |
| Straight | 30 | 4x | 4♣ 5♦ 6♥ 7♠ 8♣ |
| Three of a Kind | 30 | 3x | 9♥ 9♦ 9♠ 4♣ 2♠ |
| Two Pair | 20 | 2x | J♠ J♣ 5♥ 5♦ K♠ |
| Pair | 10 | 2x | Q♦ Q♣ 7♥ 3♠ 2♣ |
| High Card | 5 | 1x | A♠ K♦ 8♣ 5♥ 2♠ |

### Scoring System
**Final Score = Base Chips × Multiplier × Joker Modifiers**

Example:
- Hand: Full House (40 chips × 4 mult = 160 base)
- + Multiplier Joker (+4 mult) = 40 chips × 8 mult = 320
- + Chip Bonus Joker (+50 chips) = 90 chips × 8 mult = 720
- **Total: 720 points**

## Joker System

### 5 Unique Jokers

#### 1. Mult +4
- **Effect**: Adds +4 to multiplier
- **Best for**: Any hand type
- **Cost**: $50 + (blind level × $10)
- **Example**: Pair (10 × 2) becomes (10 × 6) = 60 points

#### 2. Chips +50
- **Effect**: Adds +50 to base chips
- **Best for**: High multiplier hands (flushes, straights)
- **Cost**: $50 + (blind level × $10)
- **Example**: Straight (30 × 4) becomes (80 × 4) = 320 points

#### 3. Flush x2
- **Effect**: Doubles multiplier if all cards same suit
- **Best for**: Flush-focused strategy
- **Cost**: $50 + (blind level × $10)
- **Example**: Flush (35 × 4) becomes (35 × 8) = 280 points

#### 4. Lucky
- **Effect**: Adds random multiplier bonus (+1 to +3)
- **Best for**: Any strategy, adds variance
- **Cost**: $50 + (blind level × $10)
- **Example**: Three Kind (30 × 3) becomes (30 × 5) = 150 points

#### 5. Face Bonus
- **Effect**: +10 chips per face card (J, Q, K)
- **Best for**: High card/pair strategies
- **Cost**: $50 + (blind level × $10)
- **Example**: Pair of Kings with 2 other faces = (10+30) × 2 = 80 points

### Joker Stacking
- Maximum 5 jokers active simultaneously
- Effects stack multiplicatively and additively
- Strategic selection is key to success

## Progression System

### Blind Levels
Each blind increases in difficulty:

| Blind | Target Score | Shop Joker Cost | Extra Hand Cost |
|-------|--------------|-----------------|-----------------|
| 1 | 300 | $50 | $25 |
| 2 | 550 | $60 | $30 |
| 3 | 850 | $70 | $35 |
| 4 | 1,200 | $80 | $40 |
| 5 | 1,600 | $90 | $45 |
| n | 300 + (n-1)×250 + (n-1)×50 | $50+n×$10 | $25+n×$5 |

### Resource Management
- **Starting Money**: $50
- **Money Gain**: (Score ÷ 10) per hand
- **Hands per Blind**: 4 (can purchase more)
- **Discards**: 3 per blind (not yet implemented)

### Win Condition
- Complete all hands in a blind
- Reach or exceed target score
- Earn money and proceed to shop

### Lose Condition
- Use all hands without reaching target
- Game Over screen displays highest blind reached

## Shop System

### Shop Interface
- 3 random items per visit
- Navigate with D-Pad Up/Down
- Purchase with A button
- Exit with B button

### Available Items
1. **Random Joker** - One of 5 joker types
2. **Extra Hand** - +1 hand for current blind

### Shop Strategy Tips
- Buy multiplier jokers early for consistent gains
- Save money for powerful joker combinations
- Extra hands provide safety net for bad luck
- Flush x2 requires consistent suit hands

## Control Scheme

### Main Game (Hand Selection)
- **Left/Right**: Select card position
- **A Button**: Toggle card selection
- **B Button**: Play all selected cards
- **START**: Skip to shop (if target met)

### Shop
- **Up/Down**: Navigate items
- **A Button**: Purchase selected item
- **B Button**: Exit shop and continue

### Blind Screen
- **START**: Begin blind

### Score Screen
- **A Button**: Continue to next state

## Visual Design

### Color Palettes
The game uses 4 background color palettes:

1. **Palette 0** - Default UI (grays, white)
2. **Palette 1** - Red suits (hearts, diamonds)
3. **Palette 2** - Black suits (clubs, spades)
4. **Palette 3** - Blue highlights (selection, UI accent)

### Card Display
Cards are rendered as ASCII-style tiles:
```
+---+
| K |
| H |
+---+
```
- Top line: Box border
- Middle line: Rank (2-9, T, J, Q, K, A)
- Bottom line: Suit (H, D, C, S)

### Screen Layouts

#### Title Screen
```
CHROMA CARDS
JOKER'S RUN

Press START
```

#### Blind Screen
```
BLIND 3

TARGET:
850

Press START
```

#### Game Screen
```
SCORE: 450    TARGET: 850
HANDS: 3      MONEY: $75

[Selected cards shown here]

JOKERS: Mult+4  Chips+50
```

#### Shop Screen
```
      SHOP
MONEY: $125

> Mult +4      $70
  Lucky        $70
  +1 Hand      $35

A:Buy B:Exit
```

#### Score Screen
```
   Full House

CHIPS: 40
MULT: x8

SCORE: 320

Press A
```

## Technical Specifications

### Performance
- **Frame Rate**: 60 FPS (VBlank synced)
- **CPU Mode**: GBC double-speed when available
- **Memory Usage**: ~10KB ROM, minimal RAM
- **VRAM Usage**: Background tiles only

### Compatibility
- ✅ Game Boy Color (hardware)
- ✅ GBC emulators (BGB, SameBoy, mGBA)
- ❌ Original Game Boy (requires color)
- ❌ Super Game Boy (GBC exclusive)

## Strategy Guide

### Early Game (Blinds 1-2)
- Focus on consistent hands (pairs, two pair)
- Purchase Mult +4 or Chip Bonus jokers
- Don't overspend - save for mid-game

### Mid Game (Blinds 3-4)
- Build joker synergies
- Consider Flush x2 if getting consistent suits
- Buy extra hands if needed for safety

### Late Game (Blind 5+)
- Maximum joker count (5) is critical
- Strategic hand selection becomes vital
- Balance risk/reward of going for big hands

### Optimal Joker Combinations
1. **Multiplier Stack**: 2-3 Mult +4 jokers = massive multiplier
2. **Flush Focus**: Flush x2 + Chip Bonus + Mult +4
3. **Face Card Build**: Face Bonus + pair strategy
4. **Balanced**: Mix of chip and mult bonuses

## Future Enhancement Ideas

### Planned Features
- Proper tile-based card graphics
- Animated cursor sprite
- Sound effects and music
- Card discard mechanic
- More joker varieties
- Boss blinds
- Persistent high scores
- Multiple difficulty modes

### Community Suggestions Welcome!
This is an open-source project - contributions and ideas are appreciated!

---

**Have fun playing Chroma Cards: Joker's Run!**
