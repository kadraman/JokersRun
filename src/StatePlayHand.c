#include "Banks/SetAutoBank.h"

#include "ZGBMain.h"
#include "game.h"
#include "cards.h"
#include "ui.h"
#include <gbdk/emu_debug.h>

static uint8_t cursor;
static uint8_t last_keys;

void START() {
    EMU_printf("Entering play hand: score=%d target=%d hands=%d discards=%d\n",
               game.current_score, game.target_score,
               game.hands_left, game.discards_left);
    cursor = 0;
    last_keys = 0xFF;
    draw_game_screen(&game);
    draw_hand(game.hand, cursor);
}

void UPDATE() {
    uint8_t just_pressed = keys & (uint8_t)~last_keys;
    uint8_t needs_redraw = 0;
    uint8_t i;

    if (just_pressed & J_LEFT) {
        if (cursor > 0) { cursor--; needs_redraw = 1; }
    } else if (just_pressed & J_RIGHT) {
        if (cursor < HAND_SIZE - 1) { cursor++; needs_redraw = 1; }
    } else if (just_pressed & J_UP) {
        game.hand[cursor].selected = 1;
        needs_redraw = 1;
    } else if (just_pressed & J_DOWN) {
        game.hand[cursor].selected = 0;
        needs_redraw = 1;
    } else if (just_pressed & J_B) {
        if (game.discards_left > 0) {
            uint8_t selected_count = 0;
            for (i = 0; i < HAND_SIZE; i++) {
                if (game.hand[i].selected) selected_count++;
            }
            if (selected_count > 0) {
                for (i = 0; i < HAND_SIZE; i++) {
                    if (game.hand[i].selected) {
                        if (deck_pos >= DECK_SIZE) {
                            deck_pos = 0;
                            shuffle_deck(game.deck);
                        }
                        game.hand[i] = game.deck[deck_pos];
                        game.hand[i].selected = 0;
                        deck_pos++;
                    }
                }
                game.discards_left--;
                needs_redraw = 1;
            }
        }
    } else if (just_pressed & J_A) {
        game.hands_left--;
        SetState(StateScoring);
        return;
    } else if (just_pressed & J_START) {
        if (game.current_score >= game.target_score) {
            SetState(StateShop);
            return;
        }
    }

    last_keys = keys;

    if (game.hands_left == 0 && game.current_score < game.target_score) {
        SetState(StateGameOver);
        return;
    }

    if (needs_redraw) {
        draw_game_screen(&game);
        draw_hand(game.hand, cursor);
    }
}
