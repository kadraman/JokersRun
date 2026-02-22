#include "poker.h"
#include <string.h>

// Hand evaluation helpers
static uint8_t count_rank(Card* hand, Rank rank) {
    uint8_t count = 0;
    uint8_t i;
    for (i = 0; i < HAND_SIZE; i++) {
        if (hand[i].rank == rank) count++;
    }
    return count;
}

static uint8_t is_flush(Card* hand) {
    uint8_t i;
    Suit first_suit = hand[0].suit;
    for (i = 1; i < HAND_SIZE; i++) {
        if (hand[i].suit != first_suit) return 0;
    }
    return 1;
}

static uint8_t is_straight(Card* hand) {
    uint8_t ranks[HAND_SIZE];
    uint8_t i, j, temp;
    
    // Copy and sort ranks
    for (i = 0; i < HAND_SIZE; i++) {
        ranks[i] = hand[i].rank;
    }
    
    // Bubble sort
    for (i = 0; i < HAND_SIZE - 1; i++) {
        for (j = 0; j < HAND_SIZE - i - 1; j++) {
            if (ranks[j] > ranks[j + 1]) {
                temp = ranks[j];
                ranks[j] = ranks[j + 1];
                ranks[j + 1] = temp;
            }
        }
    }
    
    // Check for consecutive ranks
    for (i = 0; i < HAND_SIZE - 1; i++) {
        if (ranks[i + 1] != ranks[i] + 1) {
            // Check for Ace-low straight (A-2-3-4-5)
            if (i == 3 && ranks[0] == RANK_2 && ranks[4] == RANK_ACE) {
                return 1;
            }
            return 0;
        }
    }
    return 1;
}

HandScore evaluate_hand(Card* hand) {
    HandScore score;
    uint8_t rank_counts[RANKS];
    uint8_t i;
    uint8_t pairs = 0, threes = 0, fours = 0;
    
    // Initialize rank counts
    for (i = 0; i < RANKS; i++) {
        rank_counts[i] = 0;
    }
    
    // Count each rank
    for (i = 0; i < HAND_SIZE; i++) {
        rank_counts[hand[i].rank]++;
    }
    
    // Analyze counts
    for (i = 0; i < RANKS; i++) {
        if (rank_counts[i] == 2) pairs++;
        else if (rank_counts[i] == 3) threes++;
        else if (rank_counts[i] == 4) fours++;
    }
    
    // Determine hand type
    uint8_t flush = is_flush(hand);
    uint8_t straight = is_straight(hand);
    
    if (straight && flush) {
        // Check for royal flush (10-J-Q-K-A)
        uint8_t has_ten = 0, has_ace = 0;
        for (i = 0; i < HAND_SIZE; i++) {
            if (hand[i].rank == RANK_10) has_ten = 1;
            if (hand[i].rank == RANK_ACE) has_ace = 1;
        }
        if (has_ten && has_ace) {
            score.type = HAND_ROYAL_FLUSH;
        } else {
            score.type = HAND_STRAIGHT_FLUSH;
        }
    } else if (fours) {
        score.type = HAND_FOUR_KIND;
    } else if (threes && pairs) {
        score.type = HAND_FULL_HOUSE;
    } else if (flush) {
        score.type = HAND_FLUSH;
    } else if (straight) {
        score.type = HAND_STRAIGHT;
    } else if (threes) {
        score.type = HAND_THREE_KIND;
    } else if (pairs >= 2) {
        score.type = HAND_TWO_PAIR;
    } else if (pairs == 1) {
        score.type = HAND_PAIR;
    } else {
        score.type = HAND_HIGH_CARD;
    }
    
    score.chips = get_base_chips(score.type);
    score.multiplier = get_base_multiplier(score.type);
    
    return score;
}

uint16_t get_base_chips(HandType type) {
    switch (type) {
        case HAND_ROYAL_FLUSH:      return 100;
        case HAND_STRAIGHT_FLUSH:   return 100;
        case HAND_FOUR_KIND:        return 60;
        case HAND_FULL_HOUSE:       return 40;
        case HAND_FLUSH:            return 35;
        case HAND_STRAIGHT:         return 30;
        case HAND_THREE_KIND:       return 30;
        case HAND_TWO_PAIR:         return 20;
        case HAND_PAIR:             return 10;
        case HAND_HIGH_CARD:        return 5;
        default:                    return 0;
    }
}

uint8_t get_base_multiplier(HandType type) {
    switch (type) {
        case HAND_ROYAL_FLUSH:      return 8;
        case HAND_STRAIGHT_FLUSH:   return 8;
        case HAND_FOUR_KIND:        return 7;
        case HAND_FULL_HOUSE:       return 4;
        case HAND_FLUSH:            return 4;
        case HAND_STRAIGHT:         return 4;
        case HAND_THREE_KIND:       return 3;
        case HAND_TWO_PAIR:         return 2;
        case HAND_PAIR:             return 2;
        case HAND_HIGH_CARD:        return 1;
        default:                    return 1;
    }
}

const char* get_hand_name(HandType type) {
    switch (type) {
        case HAND_ROYAL_FLUSH:      return "ROYAL FLUSH";
        case HAND_STRAIGHT_FLUSH:   return "STRAIGHT FLUSH";
        case HAND_FOUR_KIND:        return "FOUR OF A KIND";
        case HAND_FULL_HOUSE:       return "FULL HOUSE";
        case HAND_FLUSH:            return "FLUSH";
        case HAND_STRAIGHT:         return "STRAIGHT";
        case HAND_THREE_KIND:       return "THREE OF A KIND";
        case HAND_TWO_PAIR:         return "TWO PAIR";
        case HAND_PAIR:             return "PAIR";
        case HAND_HIGH_CARD:        return "HIGH CARD";
        default:                    return "UNKNOWN HAND";
    }
}
