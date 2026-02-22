#include "shop.h"
#include "cards.h"
#include <gbdk/emu_debug.h>

void init_shop(Game* game, ShopItem* items, uint8_t blind_level) {
    uint8_t i, j;
    // Seed shared RNG so shop items vary each run
    seed_rng_from_hw();

    // Track owned joker types so we don't offer them
    uint8_t used_joker[6] = {0}; // index by JokerType (0..5)
    uint8_t avail[5];
    uint8_t avail_count = 0;

    for (i = 0; i < MAX_JOKERS; i++) {
        if (game->jokers[i].active) {
            uint8_t t = game->jokers[i].type;
            if (t <= JOKER_FACE_BONUS) used_joker[t] = 1;
        }
    }

    // Build available joker list (types 1..5)
    for (i = 1; i <= JOKER_FACE_BONUS; i++) {
        if (!used_joker[i]) {
            avail[avail_count++] = (uint8_t)i;
        }
    }

    // Prepare up to two joker items from available types
    ShopItem tmp[SHOP_ITEMS];
    uint8_t tmp_count = 0;

    uint8_t jokers_to_place = (avail_count >= 2) ? 2 : avail_count;
    for (i = 0; i < jokers_to_place; i++) {
        // pick random from avail
        uint8_t idx = random_byte() % avail_count;
        uint8_t chosen = avail[idx];
        // remove chosen from avail
        for (j = idx; j + 1 < avail_count; j++) avail[j] = avail[j+1];
        avail_count--;

        tmp[tmp_count].type = SHOP_ITEM_JOKER;
        tmp[tmp_count].joker = (JokerType)chosen;
        tmp[tmp_count].cost = DEFAULT_JOKER_COST;
        tmp_count++;
    }

    // One utility item: choose HAND, DISCARD or REROLL
    {
        uint8_t choice = random_byte() % 3; // 0..2
        if (choice == 0) tmp[tmp_count].type = SHOP_ITEM_HAND;
        else if (choice == 1) tmp[tmp_count].type = SHOP_ITEM_DISCARD;
        else tmp[tmp_count].type = SHOP_ITEM_REROLL;
        tmp[tmp_count].joker = JOKER_NONE;
        tmp[tmp_count].cost = (blind_level * DEFAULT_UTILITY_COST);
        tmp_count++;
    }

    // If we couldn't place two jokers (not enough available), fill remaining slots with utilities
    while (tmp_count < SHOP_ITEMS) {
        uint8_t choice = random_byte() % 3;
        if (choice == 0) tmp[tmp_count].type = SHOP_ITEM_HAND;
        else if (choice == 1) tmp[tmp_count].type = SHOP_ITEM_DISCARD;
        else tmp[tmp_count].type = SHOP_ITEM_REROLL;
        tmp[tmp_count].joker = JOKER_NONE;
        tmp[tmp_count].cost = (blind_level * DEFAULT_UTILITY_COST);
        tmp_count++;
    }

    // Shuffle tmp into items
    for (i = 0; i < SHOP_ITEMS; i++) items[i] = tmp[i];
    // simple Fisher-Yates shuffle for 3 items
    for (i = SHOP_ITEMS - 1; i > 0; i--) {
        j = random_byte() % (i + 1);
        ShopItem t = items[i];
        items[i] = items[j];
        items[j] = t;
    }

    // Debug: list generated shop items
    for (i = 0; i < SHOP_ITEMS; i++) {
        if (items[i].type == SHOP_ITEM_JOKER) {
            EMU_printf("shop[%d]=JOKER type=%d cost=%d\n", i, items[i].joker, items[i].cost);
        } else if (items[i].type == SHOP_ITEM_HAND) {
            EMU_printf("shop[%d]=+1_HAND cost=%d\n", i, items[i].cost);
        } else {
            EMU_printf("shop[%d]=OTHER type=%d cost=%d\n", i, items[i].type, items[i].cost);
        }
    }
}

uint8_t purchase_item(Game* game, ShopItem* item) {
    uint8_t i;
    
    // Check if player has enough money
    if (game->money < item->cost) {
        EMU_printf("Cannot afford item: cost=%d money=%d\n", item->cost, game->money);
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
                EMU_printf("Purchased joker: slot %d type %d\n", i, item->joker);
                return 1;
            }
        }
        EMU_printf("Purchase failed: no space for joker\n");
        return 0; // No space for joker
    } else if (item->type == SHOP_ITEM_HAND) {
        // Give extra hand immediately
        game->hands_left++;
        game->money -= item->cost;
        EMU_printf("Purchased +1 HAND: hands_left=%d\n", game->hands_left);
        return 1;
    } else if (item->type == SHOP_ITEM_DISCARD) {
        // Give extra discard
        game->discards_left++;
        game->money -= item->cost;
        EMU_printf("Purchased +1 DISCARD: discards_left=%d\n", game->discards_left);
        return 1;
    } else if (item->type == SHOP_ITEM_REROLL) {
        // Reroll / extra hand (simplified)
        game->hands_left++;
        game->money -= item->cost;
        EMU_printf("Purchased REROLL\n");
        return 1;
    }
    
    return 0;
}
