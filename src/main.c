#include <gb/gb.h>
#include "game.h"
#include "ui.h"

void main(void) {
    // Set GBC mode
    if (_cpu == CGB_TYPE) {
        cpu_fast();
    }
    
    // Run the game
    run_game();
    
    // Infinite loop after game ends
    while(1) {
        wait_vbl_done();
    }
}
