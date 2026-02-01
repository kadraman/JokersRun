# Game Screen Layout Fix

## Issues Fixed

### 1. Cards Off Screen
**Problem**: Cards were 4 characters wide (`+--+`) with 5-character spacing, requiring 25 characters on a 20-character screen.

**Solution**: Redesigned cards to be compact (3 characters: space/cursor + rank + suit)
- Format: ` RS` or `>RS` (where R=rank, S=suit, > indicates selected)
- 5 cards × 4 chars (3 for card + 1 space) = 20 chars total

### 2. Missing Cursor
**Problem**: Cursor position was tracked but not displayed to the user.

**Solution**: Added visual cursor indicator
- `vv` appears above the currently selected card position
- `>` prefix shows which cards are selected for play
- D-Pad Left/Right moves cursor
- A button toggles selection

### 3. Information Overflow
**Problem**: Labels were too long, causing text wrapping and poor layout.

**Solution**: Abbreviated labels and combined info on same lines
- `SCORE:` → `SC:` (Score)
- `TARGET:` → `TG:` (Target)
- Combined score/target on line 1
- Combined hands/money on line 2

## New Game Screen Layout

```
SC:0      TG:300
HANDS:4   $50



      vv
 2H  3S >7D  KC  AH


JOKER:Mult+4
A:SEL B:PLAY
```

### Layout Breakdown (20×18 characters)

```
Row 1:  SC:0      TG:300     (Score and Target)
Row 2:  HANDS:4   $50        (Hands left and Money)
Row 3-8: [empty space]
Row 9:       vv              (Cursor indicator)
Row 10:  2H  3S >7D  KC  AH (Cards: 5×4 chars = 20)
Row 11-13: [empty space]
Row 14: JOKER:Mult+4         (Active jokers)
Row 15: [joker names cont.]
Row 16: [empty]
Row 17: A:SEL B:PLAY         (Controls)
Row 18: [empty]
```

## Card Display Format

Each card occupies 3 characters:
1. **Position 1**: Space (` `) or Selection marker (`>`)
2. **Position 2**: Rank (`2`-`9`, `T`, `J`, `Q`, `K`, `A`)
3. **Position 3**: Suit (`H`, `D`, `C`, `S`)

Examples:
- ` 2H` = Unselected 2 of Hearts
- `>7D` = Selected 7 of Diamonds
- ` KC` = Unselected King of Clubs

## Cursor Navigation

- **Cursor indicator**: `vv` appears above current card
- **D-Pad Left**: Move cursor left
- **D-Pad Right**: Move cursor right
- **A button**: Toggle selection of card under cursor
- **B button**: Play all selected cards (must select all 5)

## Technical Changes

### cards.c
- `draw_card()`: Now takes `is_selected` and `has_cursor` parameters
- `draw_hand()`: Now takes `cursor_pos` parameter
- Compact 3-char card format instead of 4×4 box

### ui.c
- `draw_game_screen()`: Abbreviated labels, combined info lines
- Added control instructions at bottom

### game.c
- `handle_play_hand()`: Pass cursor position to `draw_hand()`

## Testing Notes

All 5 cards now fit on screen properly:
- Card 1: columns 1-3
- Card 2: columns 5-7
- Card 3: columns 9-11
- Card 4: columns 13-15
- Card 5: columns 17-19
- Total: 19 characters (fits in 20-char screen)

Cursor is visible and functional:
- Moves with D-Pad
- Shows current position
- Selection state persists independently
