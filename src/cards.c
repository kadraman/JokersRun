#include "cards.h"
#include <gb/gb.h>
#include <gbdk/console.h>
#include <stdio.h>
#include "tiles.h"
#include "ui.h"
#include <rand.h>

// RNG seed — initialize at shuffle-time using hardware timer/input
static uint16_t rng_seed;

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
    // Seed RNG from hardware divider and current input so order varies each run
    rng_seed = (uint16_t)DIV_REG ^ ((uint16_t)joypad() << 8);

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
    // Map ranks 2-9 to '2'..'9', handle 10..A explicitly
    if (card->rank <= RANK_9) {
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
    
    // Draw cursor above card (use lowercase v) using print_text so tiles are used
    if (has_cursor) {
        print_text(x, y - 1, "V");
        print_text(x+1, y - 1, "V");
        print_text(x+2, y - 1, "V");
    } else {
        print_text(x, y - 1, " ");
        print_text(x+1, y - 1, " ");
        print_text(x+2, y - 1, " ");
    }
    
    // Draw card on two lines for better visibility
    // Line 1: Rank — use print_text so ASCII tiles are used. Show brackets when selected.
    char rank_buf[4];
    if (is_selected) {
        rank_buf[0] = '<';
        rank_buf[1] = rank_char;
        rank_buf[2] = '>';
        rank_buf[3] = '\0';
        print_text(x, y, rank_buf);
    } else {
        rank_buf[0] = ' ';
        rank_buf[1] = rank_char;
        rank_buf[2] = ' ';
        rank_buf[3] = '\0';
        print_text(x, y, rank_buf);
    }
    
    // Line 2: Suit below rank — use card tiles (TILE_SPADE, etc.)
    UINT8 suit_tile;
    switch (card->suit) {
        case SUIT_HEARTS:   suit_tile = TILE_HEART; break;
        case SUIT_DIAMONDS: suit_tile = TILE_DIAMOND; break;
        case SUIT_CLUBS:    suit_tile = TILE_CLUB; break;
        case SUIT_SPADES:   suit_tile = TILE_SPADE; break;
        default:            suit_tile = TILE_BACK; break;
    }
    UINT8 space_tile = TILE_ASCII_BASE + (' ' - 32);
    set_bkg_tiles(x, y+1, 1, 1, &space_tile);
    set_bkg_tiles(x+1, y+1, 1, 1, &suit_tile);
    set_bkg_tiles(x+2, y+1, 1, 1, &space_tile);

    // Line 3: selection indicator below card using ASCII '*' tile
    //UINT8 sel_tile = is_selected ? (TILE_ASCII_BASE + ('*' - 32)) : (TILE_ASCII_BASE + (' ' - 32));
    //set_bkg_tiles(x+1, y+2, 1, 1, &sel_tile);
}

void draw_hand(Card* hand, uint8_t cursor_pos) {
    uint8_t i;
    uint8_t x_pos;
    
    // Clear the card display area first (background tiles)
    UINT8 space_tile = TILE_ASCII_BASE + (' ' - 32);
    for (i = 0; i < 20; i++) {
        set_bkg_tiles(i, 9, 1, 1, &space_tile);
        set_bkg_tiles(i, 10, 1, 1, &space_tile);
        set_bkg_tiles(i, 11, 1, 1, &space_tile);
        set_bkg_tiles(i, 12, 1, 1, &space_tile);
    }
    
    // Draw 5 cards in a row with explicit spacing
    for (i = 0; i < HAND_SIZE; i++) {
        x_pos = 1 + (i * 4); // 4 chars per card slot
        draw_card(x_pos, 10, &hand[i], hand[i].selected, (i == cursor_pos));
    }
}
