#ifndef SHOP_H
#define SHOP_H

#include "gametypes.h"

#define SHOP_ITEMS 3
#define DEFAULT_JOKER_COST 5
#define DEFAULT_UTILITY_COST 5

typedef enum {
    SHOP_ITEM_JOKER = 0,
    SHOP_ITEM_HAND,
    SHOP_ITEM_DISCARD,
    SHOP_ITEM_REROLL
} ShopItemType;

typedef struct {
    ShopItemType type;
    JokerType joker;
    uint16_t cost;
} ShopItem;

// Initialize shop with random items (avoid already-owned jokers)
void init_shop(Game* game, ShopItem* items, uint8_t blind_level);

// Process shop purchase
uint8_t purchase_item(Game* game, ShopItem* item);

#endif // SHOP_H
