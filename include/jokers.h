#ifndef JOKERS_H
#define JOKERS_H

#include "gametypes.h"

// Apply joker modifiers to hand score
void apply_jokers(HandScore* score, Card* hand, Joker* jokers);

// Get joker name for display
const char* get_joker_name(JokerType type);

#endif // JOKERS_H
