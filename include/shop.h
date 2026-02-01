#ifndef SHOP_H
#define SHOP_H

#include "gametypes.h"

#define SHOP_ITEMS 3

typedef enum {
    SHOP_ITEM_JOKER = 0,
    SHOP_ITEM_CARD,
    SHOP_ITEM_REROLL
} ShopItemType;

typedef struct {
    ShopItemType type;
    JokerType joker;
    uint16_t cost;
} ShopItem;

// Initialize shop with random items
void init_shop(ShopItem* items, uint8_t blind_level);

// Process shop purchase
uint8_t purchase_item(Game* game, ShopItem* item);

#endif // SHOP_H
