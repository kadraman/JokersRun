#ifndef GAME_H
#define GAME_H

#include "gametypes.h"
#include "shop.h"

// Game initialization
void init_game(Game* game);

// Main game loop
void run_game(void);

// State handlers
void handle_blind_select(Game* game);
void handle_play_hand(Game* game);
void handle_scoring(Game* game);
void handle_shop(Game* game, ShopItem* items);

#endif // GAME_H
