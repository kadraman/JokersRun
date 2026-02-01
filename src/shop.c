#include "shop.h"
#include <rand.h>

static uint8_t shop_rng = 42;

static uint8_t shop_random(void) {
    shop_rng = (shop_rng * 73 + 17) & 0xFF;
    return shop_rng;
}

void init_shop(ShopItem* items, uint8_t blind_level) {
    uint8_t i;
    
    for (i = 0; i < SHOP_ITEMS; i++) {
        uint8_t item_type = shop_random() % 2;
        
        if (item_type == 0) {
            // Joker
            items[i].type = SHOP_ITEM_JOKER;
            items[i].joker = (shop_random() % 4) + 1; // JOKER_MULTIPLIER to JOKER_FACE_BONUS
            items[i].cost = 50 + (blind_level * 10);
        } else {
            // Extra hand/discard (simplified as reroll for now)
            items[i].type = SHOP_ITEM_REROLL;
            items[i].joker = JOKER_NONE;
            items[i].cost = 25 + (blind_level * 5);
        }
    }
}

uint8_t purchase_item(Game* game, ShopItem* item) {
    uint8_t i;
    
    // Check if player has enough money
    if (game->money < item->cost) {
        return 0; // Cannot afford
    }
    
    // Process purchase
    if (item->type == SHOP_ITEM_JOKER) {
        // Find empty joker slot
        for (i = 0; i < MAX_JOKERS; i++) {
            if (!game->jokers[i].active) {
                game->jokers[i].type = item->joker;
                game->jokers[i].active = 1;
                game->money -= item->cost;
                return 1;
            }
        }
        return 0; // No space for joker
    } else if (item->type == SHOP_ITEM_REROLL) {
        // Give extra hand
        game->hands_left++;
        game->money -= item->cost;
        return 1;
    }
    
    return 0;
}
