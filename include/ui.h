#ifndef UI_H
#define UI_H

#include "gametypes.h"
#include "shop.h"

// Initialize graphics
void init_graphics(void);

// UI drawing functions
void draw_title_screen(void);
void draw_blind_screen(uint8_t level, uint16_t target);
void draw_game_screen(Game* game);
void draw_shop_screen(Game* game, ShopItem* items, uint8_t cursor);
void draw_score_screen(HandScore* score, uint16_t total);

// Utility text drawing
void print_text(uint8_t x, uint8_t y, const char* text);
//void print_text(uint8_t x, uint8_t y, const char* text);
//void print_number(uint8_t x, uint8_t y, uint16_t num);
void print_number(uint8_t x, uint8_t y, uint16_t num);
#endif // UI_H
