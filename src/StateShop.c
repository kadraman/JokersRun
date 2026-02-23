#include "Banks/SetAutoBank.h"

#include "ZGBMain.h"
#include "game.h"
#include "cards.h"
#include "ui.h"
#include <gbdk/emu_debug.h>

static uint8_t cursor;
static uint8_t last_keys;

void START() {
    EMU_printf("Entering shop: money=%d\n", game.money);
    cursor = 0;
    last_keys = 0xFF;
    init_shop(&game, shop_items, game.blind_level);
    draw_shop_screen(&game, shop_items, cursor);
}

void UPDATE() {
    uint8_t just_pressed = keys & (uint8_t)~last_keys;
    uint8_t needs_redraw = 0;
    last_keys = keys;

    if (just_pressed & J_UP) {
        if (cursor > 0) { cursor--; needs_redraw = 1; }
    } else if (just_pressed & J_DOWN) {
        if (cursor < SHOP_ITEMS - 1) { cursor++; needs_redraw = 1; }
    } else if (just_pressed & J_A) {
        purchase_item(&game, &shop_items[cursor]);
        needs_redraw = 1;
    } else if (just_pressed & J_B) {
        uint8_t _i;
        EMU_printf("After shop: hands=%d money=%d\n", game.hands_left, game.money);
        for (_i = 0; _i < MAX_JOKERS; _i++) {
            EMU_printf(" joker[%d]=active=%d type=%d\n",
                       _i, game.jokers[_i].active, game.jokers[_i].type);
        }

        game.blind_level++;
        game.target_score += (game.blind_level * 50);
        game.current_score = 0;
        game.hands_left = 4 + game.extra_hands;
        game.discards_left = 5 + game.extra_discards;

        deal_hand(game.deck, game.hand, &deck_pos);

        SetState(StateBlindSelect);
        return;
    }

    if (needs_redraw) {
        draw_shop_screen(&game, shop_items, cursor);
    }
}
