#include "cards.h"
#include <gb/gb.h>
#include <gbdk/console.h>
#include <stdio.h>
#include <rand.h>

// Simple RNG state
static uint16_t rng_seed = 12345;

// Simple random number generator
static uint8_t random_byte(void) {
    rng_seed = (rng_seed * 1103515245 + 12345) & 0x7FFF;
    return (uint8_t)(rng_seed >> 8);
}

void init_deck(Card* deck) {
    uint8_t i = 0;
    uint8_t suit, rank;
    
    for (suit = 0; suit < SUITS; suit++) {
        for (rank = 0; rank < RANKS; rank++) {
            deck[i].suit = suit;
            deck[i].rank = rank;
            deck[i].selected = 0;
            i++;
        }
    }
}

void shuffle_deck(Card* deck) {
    uint8_t i, j;
    Card temp;
    
    // Fisher-Yates shuffle
    for (i = DECK_SIZE - 1; i > 0; i--) {
        j = random_byte() % (i + 1);
        
        // Swap deck[i] and deck[j]
        temp = deck[i];
        deck[i] = deck[j];
        deck[j] = temp;
    }
}

void deal_hand(Card* deck, Card* hand, uint8_t* deck_pos) {
    uint8_t i;
    
    for (i = 0; i < HAND_SIZE; i++) {
        if (*deck_pos >= DECK_SIZE) {
            *deck_pos = 0; // Reshuffle if needed
            shuffle_deck(deck);
        }
        hand[i] = deck[*deck_pos];
        hand[i].selected = 0;
        (*deck_pos)++;
    }
}

// Tile positions for card graphics (simple ASCII-style)
// Using background tiles, not sprites
void draw_card(uint8_t x, uint8_t y, Card* card, uint8_t is_selected, uint8_t has_cursor) {
    char rank_char, suit_char;
    
    // Convert rank to character
    if (card->rank <= 8) {
        rank_char = '2' + card->rank;
    } else if (card->rank == RANK_10) {
        rank_char = 'T';
    } else if (card->rank == RANK_JACK) {
        rank_char = 'J';
    } else if (card->rank == RANK_QUEEN) {
        rank_char = 'Q';
    } else if (card->rank == RANK_KING) {
        rank_char = 'K';
    } else {
        rank_char = 'A';
    }
    
    // Convert suit to character
    switch (card->suit) {
        case SUIT_HEARTS:   suit_char = 'H'; break;
        case SUIT_DIAMONDS: suit_char = 'D'; break;
        case SUIT_CLUBS:    suit_char = 'C'; break;
        case SUIT_SPADES:   suit_char = 'S'; break;
        default:            suit_char = '?'; break;
    }
    
    // Draw cursor above card
    gotoxy(x, y - 1);
    if (has_cursor) {
        printf("vv");  // Cursor indicator
    } else {
        printf("  ");
    }
    
    // Draw card (2 chars wide + 1 for selection marker)
    gotoxy(x, y);
    if (is_selected) {
        printf(">%c%c", rank_char, suit_char);  // > shows selected
    } else {
        printf(" %c%c", rank_char, suit_char);
    }
}

void draw_hand(Card* hand, uint8_t cursor_pos) {
    uint8_t i;
    uint8_t x_pos;
    
    // Draw 5 cards in a row (3 chars per card + 1 space = 4 chars each)
    // Total: 5 cards × 4 = 20 chars (fits perfectly in 20-char screen)
    for (i = 0; i < HAND_SIZE; i++) {
        x_pos = 1 + (i * 4); // 4 chars per card (3 for card + 1 space)
        draw_card(x_pos, 10, &hand[i], hand[i].selected, (i == cursor_pos));
    }
}
