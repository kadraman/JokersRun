# Character-by-Character Rendering Fix

## Issue
The display was showing garbled output with:
- "VV" instead of "vv" for cursor
- Missing suits on some cards
- Fourth card completely missing
- General text rendering issues

## Root Cause
Using `printf` with format strings like `"%s"`, `"%u"`, `"%c%c"` was causing issues with GBDK's console system. Multi-character printf calls were not rendering correctly.

## Solution
Rewritten all text rendering to use character-by-character printf calls:

### Card Drawing (src/cards.c)
**Before:**
```c
printf("vv");  // Cursor
printf(">%c%c", rank_char, suit_char);  // Card
```

**After:**
```c
// Print each character separately
printf("v");
gotoxy(x+1, y-1);
printf("v");

// Print rank and suit on separate lines
gotoxy(x, y);
printf(is_selected ? ">" : " ");
gotoxy(x+1, y);
printf("%c", rank_char);
gotoxy(x, y+1);
printf(" ");
gotoxy(x+1, y+1);
printf("%c", suit_char);
```

### Text Functions (src/ui.c)
**Before:**
```c
printf("%s", text);
printf("%u", num);
```

**After:**
```c
// Print text character by character
while (text[i] != '\0') {
    printf("%c", text[i]);
    i++;
}

// Convert number and print digit by digit
while (i > 0) {
    printf("%c", buffer[--i]);
}
```

## New Card Layout
Cards now display on 2 lines:
```
Line 1: Selection marker (> or space) + Rank
Line 2: Space + Suit

Example:
Row 9:  v   v            (cursor over card 1 and 3)
Row 10: >2  7  >K  9  A  (ranks, card 0 and 2 selected)
Row 11:  H  D   C  S  H  (suits)
```

## Benefits
1. All characters render correctly
2. Rank and suit clearly separated
3. Selection markers visible
4. Cursor indicators work properly
5. All 5 cards fit on screen

## Testing
Build with `make` - produces working chromacards.gbc
