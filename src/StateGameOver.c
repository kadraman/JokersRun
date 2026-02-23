#include "Banks/SetAutoBank.h"

#include "ZGBMain.h"
#include "game.h"
#include "ui.h"

static uint8_t last_keys;

void START() {
    cls();
    print_text(5, 8, "GAME OVER");
    print_text(3, 10, "BLIND:");
    print_number(10, 10, game.blind_level);
    print_text(3, 13, "PRESS START");
    last_keys = 0xFF;
}

void UPDATE() {
    uint8_t just_pressed = keys & (uint8_t)~last_keys;
    last_keys = keys;

    if (just_pressed & J_START) {
        SetState(StateTitleScreen);
    }
}
