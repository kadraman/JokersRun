#include "ui.h"
#include "jokers.h"
#include "poker.h"
#include <gb/gb.h>
#include <gb/cgb.h>
#include <gbdk/console.h>
#include <gbdk/font.h>
#include <stdio.h>
#include "tiles.h"

// Maximum characters per line for the GBC text console (screen is 20 tiles wide)
#define MAX_TEXT_LENGTH 20

extern const unsigned char tiles[];

// Background palette data (GBC)
const palette_color_t bg_palette[] = {
    // Palette 0 - Default UI
    RGB(31, 31, 31), RGB(21, 21, 21), RGB(10, 10, 10), RGB(0, 0, 0),
    // Palette 1 - Red (Hearts/Diamonds)
    RGB(31, 31, 31), RGB(31, 10, 10), RGB(21, 0, 0), RGB(0, 0, 0),
    // Palette 2 - Black (Clubs/Spades)
    RGB(31, 31, 31), RGB(10, 10, 10), RGB(5, 5, 5), RGB(0, 0, 0),
    // Palette 3 - Blue (UI highlights)
    RGB(31, 31, 31), RGB(10, 20, 31), RGB(5, 10, 21), RGB(0, 0, 10)
};

// Sprite palette data (GBC)
const palette_color_t sprite_palette[] = {
    // Palette 0 - Cursor
    RGB(31, 31, 0), RGB(31, 21, 0), RGB(21, 10, 0), RGB(10, 5, 0),
    // Palette 1-3 - Unused
    RGB(31, 31, 31), RGB(21, 21, 21), RGB(10, 10, 10), RGB(0, 0, 0),
    RGB(31, 31, 31), RGB(21, 21, 21), RGB(10, 10, 10), RGB(0, 0, 0),
    RGB(31, 31, 31), RGB(21, 21, 21), RGB(10, 10, 10), RGB(0, 0, 0)
};

void init_graphics(void) {
    // Initialize font and console
    font_init();
    font_set(font_load(font_min));
    
    // Set up GBC palettes
    set_bkg_palette(0, 4, bg_palette);
    set_sprite_palette(0, 4, sprite_palette);

    // Load tile data for text and UI elements
    set_bkg_data(0, 67, tiles);
    
    
    // Enable background and window
    SHOW_BKG;
    DISPLAY_ON;
}

void print_text(uint8_t x, uint8_t y, const char* text)
{
    while(*text)
    {
        char c = *text;
        if(c >= 32 && c <= 127)
        {
            UINT8 tile = c - 32;  // map ASCII 32..127 to tiles
            set_bkg_tiles(x++, y, 1, 1, &tile);
        }
        text++;
    }
}

/* Assumes TILE_ASCII_BASE maps '0'..'9' starting at ASCII 48 */
void print_number(uint8_t x, uint8_t y, uint16_t num)
{
    char buf[6]; // max 5 digits for UINT16 + null
    uint8_t i = 0;

    // Handle zero explicitly
    if(num == 0)
    {
        uint8_t tile = TILE_ASCII_BASE + ('0' - 32);
        set_bkg_tiles(x, y, 1, 1, &tile);
        return;
    }

    // Convert number to decimal digits in reverse
    while(num > 0 && i < 5)
    {
        buf[i++] = (num % 10) + '0';
        num /= 10;
    }

    // Print digits in correct order
    for(uint8_t j = 0; j < i; j++)
    {
        uint8_t tile = TILE_ASCII_BASE + (buf[i - j - 1] - 32);
        set_bkg_tiles(x + j, y, 1, 1, &tile);
    }
}

void draw_title_screen(void) {
    cls();
    print_text(3, 5, "CHROMA CARDS");
    print_text(3, 7, "JOKER'S RUN");
    print_text(3, 12, "PRESS START");
}

void draw_blind_screen(uint8_t level, uint16_t target) {
    cls();
    print_text(5, 5, "BLIND:");
    print_number(11, 5, level);
    print_text(5, 8, "TARGET:");
    print_number(5, 9, target);
    print_text(4, 14, "PRESS START");
}

void draw_game_screen(Game* game) {
    cls();
    
    // Draw score and target on same line to save space
    print_text(1, 1, "SC:");
    print_number(4, 1, game->current_score);
    
    print_text(10, 1, "TG:");
    print_number(13, 1, game->target_score);
    
    // Draw hands and money on same line
    print_text(1, 2, "HANDS:");
    print_number(7, 2, game->hands_left);
    
    print_text(10, 2, "$");
    print_number(11, 2, game->money);
    
    // Cards will be drawn at row 10 by draw_hand()
    
    // Draw jokers at bottom if any
    if (game->jokers[0].active || game->jokers[1].active) {
        print_text(1, 14, "JOKER:");
        uint8_t x = 1;
        uint8_t i;
        for (i = 0; i < MAX_JOKERS && x < 18; i++) {
            if (game->jokers[i].active) {
                const char* name = get_joker_name(game->jokers[i].type);
                print_text(x, 15, name);
                x += 7;
                if (x + 7 > 20) break; // Stop if next joker won't fit
            }
        }
    }
    
    // Instructions
    print_text(1, 17, "A:SEL B:PLAY");
}

void draw_shop_screen(Game* game, ShopItem* items, uint8_t cursor) {
    cls();
    print_text(6, 2, "SHOP");
    print_text(1, 4, "MONEY:$");
    print_number(9, 4, game->money);
    
    uint8_t i;
    uint8_t y = 7;
    
    for (i = 0; i < SHOP_ITEMS; i++) {
        if (cursor == i) {
            print_text(1, y, ">");
        } else {
            print_text(1, y, " ");
        }
        
        if (items[i].type == SHOP_ITEM_JOKER) {
            const char* name = get_joker_name(items[i].joker);
            print_text(3, y, name);
        } else {
            print_text(3, y, "+1 HAND");
        }
        
        print_text(11, y, "$");
        print_number(12, y, items[i].cost);
        
        y += 2;
    }
    
    print_text(1, 15, "A:Buy B:Exit");
}

void draw_score_screen(HandScore* score, uint16_t total) {
    cls();
    
    print_text(3, 5, get_hand_name(score->type));
    
    print_text(3, 8, "CHIPS:");
    print_number(10, 8, score->chips);
    
    print_text(3, 9, "MULT: X");
    print_number(11, 9, score->multiplier);
    
    print_text(3, 11, "SCORE:");
    print_number(10, 11, total);
    
    print_text(3, 14, "PRESS A");
}
