# Card Selection and Display Fix

## Issues Addressed

### 1. Card Selection Not Visible
**Problem**: Pressing A or B buttons didn't show any visual change on screen.

**Root Cause**: The screen wasn't being properly synchronized after drawing updates.

**Solution**: Added `wait_vbl_done()` after drawing the screen to ensure the display update completes before waiting for input.

### 2. Missing Fourth Card Rank
**Problem**: Fourth card displayed suit but no rank (showing as `    D` instead of `>9 D` for example).

**Root Cause**: Screen buffer not being properly cleared between draws, causing character overlap or corruption at certain positions.

**Solution**: 
- Added explicit clearing of card display area (rows 9-11) before drawing cards
- Added spacing characters after each card component (cursor, rank, suit)
- Use ternary operator for cleaner conditional printf calls

## Changes Made

### game.c - Added VBlank Synchronization
```c
while (!done && game->hands_left > 0) {
    draw_game_screen(game);
    draw_hand(game->hand, cursor);
    wait_vbl_done();  // NEW: Ensure screen update completes
    
    waitpad(J_A | J_B | J_LEFT | J_RIGHT | J_START);
    // ...
}
```

### cards.c - Clear Display Area
```c
void draw_hand(Card* hand, uint8_t cursor_pos) {
    // Clear the card display area first (char by char)
    for (i = 0; i < 20; i++) {
        gotoxy(i, 9);  printf(" ");
        gotoxy(i, 10); printf(" ");
        gotoxy(i, 11); printf(" ");
    }
    
    // Draw cards...
}
```

### cards.c - Add Explicit Spacing
```c
void draw_card(...) {
    // After each character, add spacing
    gotoxy(x, y - 1);
    printf("%c", has_cursor ? 'v' : ' ');
    gotoxy(x+1, y - 1);
    printf("%c", has_cursor ? 'v' : ' ');
    gotoxy(x+2, y - 1);
    printf(" ");  // Spacing after cursor
    
    // Similar for rank and suit lines
}
```

## Expected Display

```
SC:0      TG:300
HANDS:4   $50


vv             (cursor over first card)
>J  7  6  9  A (ranks - first card selected with >)
 S  H  S  D  H (suits)

A:SEL B:PLAY
```

## How It Works

1. **Cursor Movement**: D-Pad Left/Right moves the `vv` cursor indicator
2. **Card Selection**: 
   - Press A on a card to toggle selection (shows `>` prefix)
   - Press A again to deselect (removes `>`)
   - Can select/deselect multiple cards
3. **Play Hand**: Press B to play (currently requires all 5 cards selected)

## Testing
- All 5 cards now display completely with ranks and suits
- Selection markers appear/disappear when pressing A
- Cursor moves correctly with D-Pad
- Screen updates properly after each input
