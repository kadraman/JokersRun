#include "Banks/SetAutoBank.h"

#include "ZGBMain.h"
#include "game.h"
#include "ui.h"
#include <gbdk/emu_debug.h>

static uint8_t last_keys;

void START() {
    EMU_printf("Entering blind select: level=%d target=%d\n",
               game.blind_level, game.target_score);
    draw_blind_screen(game.blind_level, game.target_score);
    last_keys = 0xFF;
}

void UPDATE() {
    uint8_t just_pressed = keys & (uint8_t)~last_keys;
    last_keys = keys;

    if (just_pressed & J_START) {
        SetState(StatePlayHand);
    }
}
