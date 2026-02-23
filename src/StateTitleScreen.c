#include "Banks/SetAutoBank.h"

#include "ZGBMain.h"
#include "game.h"
#include "ui.h"

static uint8_t last_keys;

void START() {
    init_graphics();
    draw_title_screen();
    last_keys = 0xFF;
}

void UPDATE() {
    uint8_t just_pressed = keys & (uint8_t)~last_keys;
    last_keys = keys;

    if (just_pressed & J_START) {
        init_game(&game);
        SetState(StateBlindSelect);
    }
}
