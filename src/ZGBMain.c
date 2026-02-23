#include "ZGBMain.h"

UINT8 next_state = StateTitleScreen;

UINT8 GetTileReplacement(UINT8* tile_ptr, UINT8* tile) {
    (void)tile;
    *tile = *tile_ptr;
    return 255u;
}
