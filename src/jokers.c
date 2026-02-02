#include "jokers.h"

static uint8_t all_same_suit(Card* hand) {
    uint8_t i;
    Suit first_suit = hand[0].suit;
    for (i = 1; i < HAND_SIZE; i++) {
        if (hand[i].suit != first_suit) return 0;
    }
    return 1;
}

static uint8_t count_face_cards(Card* hand) {
    uint8_t count = 0;
    uint8_t i;
    for (i = 0; i < HAND_SIZE; i++) {
        if (hand[i].rank >= RANK_JACK) count++;
    }
    return count;
}

void apply_jokers(HandScore* score, Card* hand, Joker* jokers) {
    uint8_t i;
    
    for (i = 0; i < MAX_JOKERS; i++) {
        if (!jokers[i].active) continue;
        
        switch (jokers[i].type) {
            case JOKER_MULTIPLIER:
                // Add +4 to multiplier
                score->multiplier += 4;
                break;
                
            case JOKER_CHIP_BONUS:
                // Add +50 chips
                score->chips += 50;
                break;
                
            case JOKER_SUIT_BOOST:
                // x2 multiplier if all cards same suit
                if (all_same_suit(hand)) {
                    score->multiplier *= 2;
                }
                break;
                
            case JOKER_LUCKY:
                // Random bonus - deterministic placeholder using joker slot index
                // TODO: Replace with proper RNG for true randomness
                score->multiplier += 1 + (i % 3);
                break;
                
            case JOKER_FACE_BONUS:
                // +10 chips per face card
                score->chips += count_face_cards(hand) * 10;
                break;
                
            default:
                break;
        }
    }
}

const char* get_joker_name(JokerType type) {
    switch (type) {
        case JOKER_MULTIPLIER:  return "Mult +4";
        case JOKER_CHIP_BONUS:  return "Chips +50";
        case JOKER_SUIT_BOOST:  return "Flush x2";
        case JOKER_LUCKY:       return "Lucky";
        case JOKER_FACE_BONUS:  return "Face Bonus";
        default:                return "Unknown";
    }
}
