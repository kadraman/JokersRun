#include "Banks/SetAutoBank.h"

#include "ZGBMain.h"
#include "game.h"
#include "poker.h"
#include "jokers.h"
#include "cards.h"
#include "ui.h"
#include <gbdk/emu_debug.h>

static uint8_t last_keys;

void START() {
    HandScore score;
    uint16_t total;

    EMU_printf("Entering scoring: target=%d\n", game.target_score);

    score = evaluate_hand(game.hand);
    apply_jokers(&score, game.hand, game.jokers);
    total = score.chips * score.multiplier;
    game.current_score += total;

    EMU_printf("Hand score: chips=%d multiplier=%d total=%d current=%d\n",
               score.chips, score.multiplier, total, game.current_score);

    draw_score_screen(&score, total, game.hand);

    last_keys = 0xFF;
}

void UPDATE() {
    uint8_t just_pressed = keys & (uint8_t)~last_keys;
    last_keys = keys;

    if (just_pressed & J_A) {
        if (game.current_score >= game.target_score) {
            game.money += SCORE_BLIND_BONUS;
            game.money += game.hands_left;
            EMU_printf("Reward: +%d blind, +%d hands. Total: %d\n",
                       SCORE_BLIND_BONUS, game.hands_left, game.money);
            SetState(StateShop);
        } else {
            deal_hand(game.deck, game.hand, &deck_pos);
            SetState(StatePlayHand);
        }
    }
}
