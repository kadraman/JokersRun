#ifndef POKER_H
#define POKER_H

#include "gametypes.h"

// Evaluate poker hand
HandScore evaluate_hand(Card* hand);

// Get base chips and multiplier for hand type
uint16_t get_base_chips(HandType type);
uint8_t get_base_multiplier(HandType type);

// Hand name for display
const char* get_hand_name(HandType type);

#endif // POKER_H
