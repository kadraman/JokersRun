#ifndef GAMETYPES_H
#define GAMETYPES_H

#include <gb/gb.h>
#include <stdint.h>

// Card definitions
#define SUITS 4
#define RANKS 13
#define DECK_SIZE 52
#define HAND_SIZE 5

typedef enum {
    SUIT_HEARTS = 0,
    SUIT_DIAMONDS,
    SUIT_CLUBS,
    SUIT_SPADES
} Suit;

typedef enum {
    RANK_2 = 0, RANK_3, RANK_4, RANK_5, RANK_6,
    RANK_7, RANK_8, RANK_9, RANK_10,
    RANK_JACK, RANK_QUEEN, RANK_KING, RANK_ACE
} Rank;

typedef struct {
    Suit suit;
    Rank rank;
    uint8_t selected;
} Card;

// Poker hand types
typedef enum {
    HAND_HIGH_CARD = 0,
    HAND_PAIR,
    HAND_TWO_PAIR,
    HAND_THREE_KIND,
    HAND_STRAIGHT,
    HAND_FLUSH,
    HAND_FULL_HOUSE,
    HAND_FOUR_KIND,
    HAND_STRAIGHT_FLUSH,
    HAND_ROYAL_FLUSH
} HandType;

typedef struct {
    HandType type;
    uint16_t chips;
    uint8_t multiplier;
} HandScore;

// Joker definitions
#define MAX_JOKERS 5

typedef enum {
    JOKER_NONE = 0,
    JOKER_MULTIPLIER,    // +4 multiplier
    JOKER_CHIP_BONUS,    // +50 chips
    JOKER_SUIT_BOOST,    // x2 if all same suit
    JOKER_LUCKY,         // Random bonus
    JOKER_FACE_BONUS     // Bonus for face cards
} JokerType;

typedef struct {
    JokerType type;
    uint8_t active;
} Joker;

// Game state
typedef enum {
    STATE_BLIND_SELECT = 0,
    STATE_PLAY_HAND,
    STATE_SCORING,
    STATE_SHOP,
    STATE_GAME_OVER
} GameState;

typedef struct {
    GameState state;
    uint8_t blind_level;
    uint16_t target_score;
    uint16_t current_score;
    uint8_t hands_left;
    uint8_t discards_left;
    uint16_t money;
    Joker jokers[MAX_JOKERS];
    Card deck[DECK_SIZE];
    Card hand[HAND_SIZE];
} Game;

#endif // GAMETYPES_H
