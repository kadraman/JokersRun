#include "cards.h"
#include <gb/gb.h>
#include <gbdk/console.h>
#include <stdio.h>
#include "tiles.h"
#include "ui.h"
#include <rand.h>
#include <gbdk/emu_debug.h>

// RNG seed — initialize at shuffle-time using hardware timer/input
static uint16_t rng_seed;

// Simple random number generator (exported for shared use)
uint8_t random_byte(void) {
    rng_seed = (rng_seed * 1103515245 + 12345) & 0x7FFF;
    return (uint8_t)(rng_seed >> 8);
}

// Seed RNG from hardware sources (divider register + input)
void seed_rng_from_hw(void) {
    rng_seed = (uint16_t)DIV_REG ^ ((uint16_t)joypad() << 8);
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

    // Seed RNG from hardware sources
    seed_rng_from_hw();

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
    
    // If the card is selected, draw it one row higher
    int8_t y_offset = is_selected ? -1 : 0;
    uint8_t rank_y = y + y_offset;

    // Draw cursor as flank markers above the card (left '>' and right '<')
    // Place markers within the card width to avoid colliding with neighboring cards.
    int8_t marker_y = rank_y - 1;
    if (has_cursor) {
        print_text(x, marker_y, ">");
        print_text(x + 2, marker_y, "<");
    } else {
        // Clear marker positions
        print_text(x, marker_y, " ");
        print_text(x + 2, marker_y, " ");
    }

    // Draw card on two lines for better visibility
    // Line 1: Rank — always show with padding; selection is indicated by vertical offset
    char rank_buf[4];
    rank_buf[0] = ' ';
    rank_buf[1] = rank_char;
    rank_buf[2] = ' ';
    rank_buf[3] = '\0';
    print_text(x, rank_y, rank_buf);

    // Line 2: Suit below rank
    uint8_t suit_tile;
    switch (card->suit) {
        case SUIT_HEARTS:   suit_tile = TILE_HEART; break;
        case SUIT_DIAMONDS: suit_tile = TILE_DIAMOND; break;
        case SUIT_CLUBS:    suit_tile = TILE_CLUB; break;
        case SUIT_SPADES:   suit_tile = TILE_SPADE; break;
        default:            suit_tile = TILE_BACK; break;
    }
    uint8_t space_tile = TILE_ASCII_BASE + (' ' - 32);
    set_bkg_tiles(x, rank_y + 1, 1, 1, &space_tile);
    set_bkg_tiles(x+1, rank_y + 1, 1, 1, &suit_tile);
    set_bkg_tiles(x+2, rank_y + 1, 1, 1, &space_tile);

    // Line 3: selection indicator below card using ASCII '*' tile
    //uint8_t sel_tile = is_selected ? (TILE_ASCII_BASE + ('*' - 32)) : (TILE_ASCII_BASE + (' ' - 32));
    //set_bkg_tiles(x+1, y+2, 1, 1, &sel_tile);
}

void draw_hand(Card* hand, uint8_t cursor_pos) {
    uint8_t i;
    uint8_t x_pos;
    
    // Clear the card display area first (background tiles)
    uint8_t space_tile = TILE_ASCII_BASE + (' ' - 32);
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

// Draw a hand at the given rank row but do not show selection offsets
// or cursor markers. Useful for score/preview screens where positions
// should be static.
void draw_hand_no_select_at(Card* hand, uint8_t rank_y) {
    uint8_t i;
    uint8_t x_pos;

    // Clear the display area around the hand (marker row, rank row, suit row, selector row)
    uint8_t space_tile = TILE_ASCII_BASE + (' ' - 32);
    for (i = 0; i < 20; i++) {
        set_bkg_tiles(i, rank_y - 1, 1, 1, &space_tile);
        set_bkg_tiles(i, rank_y,     1, 1, &space_tile);
        set_bkg_tiles(i, rank_y + 1, 1, 1, &space_tile);
        set_bkg_tiles(i, rank_y + 2, 1, 1, &space_tile);
    }

    for (i = 0; i < HAND_SIZE; i++) {
        x_pos = 1 + (i * 4);
        draw_card(x_pos, rank_y, &hand[i], 0, 0);
    }
}
