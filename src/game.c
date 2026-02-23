#include "game.h"
#include "cards.h"
#include "jokers.h"
#include "ui.h"
#include <gbdk/emu_debug.h>

// Global game state shared across all CrossZGB states
Game game;
uint8_t deck_pos = 0;
ShopItem shop_items[SHOP_ITEMS];

void init_game(Game* g) {
    uint8_t i;

    g->blind_level = 1;
    g->target_score = 100;
    g->current_score = 0;
    g->hands_left = 4;
    g->discards_left = 5;
    g->extra_hands = 0;
    g->extra_discards = 0;
    g->money = 0;

    for (i = 0; i < MAX_JOKERS; i++) {
        g->jokers[i].type = JOKER_NONE;
        g->jokers[i].active = 0;
    }

    init_deck(g->deck);
    shuffle_deck(g->deck);
    deck_pos = 0;

    deal_hand(g->deck, g->hand, &deck_pos);
}
