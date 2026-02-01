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
void draw_card(uint8_t x, uint8_t y, Card* card) {
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
    
    // Draw card border (simple box) using console
    gotoxy(x, y);
    printf("+--+");
    
    gotoxy(x, y+1);
    printf("|%c|", rank_char);
    
    gotoxy(x, y+2);
    printf("|%c|", suit_char);
    
    gotoxy(x, y+3);
    printf("+--+");
}

void draw_hand(Card* hand) {
    uint8_t i;
    uint8_t x_pos;
    
    // Draw 5 cards in a row
    for (i = 0; i < HAND_SIZE; i++) {
        x_pos = 2 + (i * 5); // 5 tiles per card with spacing (4 for card + 1 space)
        draw_card(x_pos, 8, &hand[i]);
        
        // Draw selection indicator if selected
        if (hand[i].selected) {
            gotoxy(x_pos+1, 7);
            printf("^");
        } else {
            gotoxy(x_pos+1, 7);
            printf(" ");
        }
    }
}
