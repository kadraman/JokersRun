#ifndef GAME_H
#define GAME_H

#include "gametypes.h"
#include "shop.h"

#define SCORE_BLIND_BONUS 5

// Global game state shared across all CrossZGB states
extern Game game;
extern uint8_t deck_pos;
extern ShopItem shop_items[SHOP_ITEMS];

// Game initialization
void init_game(Game* game);

#endif // GAME_H
