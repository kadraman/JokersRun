#ifndef CARDS_H
#define CARDS_H

#include "gametypes.h"

// Initialize and shuffle deck
void init_deck(Card* deck);
void shuffle_deck(Card* deck);

// Deal cards from deck to hand
void deal_hand(Card* deck, Card* hand, uint8_t* deck_pos);

// Card drawing functions
void draw_card(uint8_t x, uint8_t y, Card* card);
void draw_hand(Card* hand);

#endif // CARDS_H
