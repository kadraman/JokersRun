#include "game.h"
#include "cards.h"
#include "poker.h"
#include "jokers.h"
#include "ui.h"
#include <gb/gb.h>
#include <gbdk/console.h>

static uint8_t deck_pos = 0;

void init_game(Game* game) {
    uint8_t i;
    
    game->state = STATE_BLIND_SELECT;
    game->blind_level = 1;
    game->target_score = 300;
    game->current_score = 0;
    game->hands_left = 4;
    game->discards_left = 3;
    game->money = 50;
    
    // Initialize jokers
    for (i = 0; i < MAX_JOKERS; i++) {
        game->jokers[i].type = JOKER_NONE;
        game->jokers[i].active = 0;
    }
    
    // Initialize deck
    init_deck(game->deck);
    shuffle_deck(game->deck);
    deck_pos = 0;
    
    // Deal initial hand
    deal_hand(game->deck, game->hand, &deck_pos);
}

void handle_blind_select(Game* game) {
    draw_blind_screen(game->blind_level, game->target_score);
    
    // Wait for START button
    waitpad(J_START);
    waitpadup();
    
    game->state = STATE_PLAY_HAND;
}

void handle_play_hand(Game* game) {
    uint8_t cursor = 0;
    uint8_t done = 0;
    
    while (!done && game->hands_left > 0) {
        draw_game_screen(game);
        draw_hand(game->hand, cursor);  // Pass cursor position
        
        waitpad(J_A | J_B | J_LEFT | J_RIGHT | J_START);
        
        if (joypad() & J_LEFT) {
            if (cursor > 0) cursor--;
            waitpadup();
            delay(100);
        } else if (joypad() & J_RIGHT) {
            if (cursor < HAND_SIZE - 1) cursor++;
            waitpadup();
            delay(100);
        } else if (joypad() & J_A) {
            // Toggle selection
            game->hand[cursor].selected = !game->hand[cursor].selected;
            waitpadup();
            delay(100);
        } else if (joypad() & J_B) {
            // Play selected cards
            uint8_t selected_count = 0;
            uint8_t i;
            
            for (i = 0; i < HAND_SIZE; i++) {
                if (game->hand[i].selected) selected_count++;
            }
            
            if (selected_count == HAND_SIZE) {
                // Evaluate hand
                game->hands_left--;
                game->state = STATE_SCORING;
                done = 1;
            }
            waitpadup();
            delay(100);
        } else if (joypad() & J_START) {
            // Skip to shop if target met
            if (game->current_score >= game->target_score) {
                game->state = STATE_SHOP;
                done = 1;
            }
            waitpadup();
        }
    }
    
    if (game->hands_left == 0 && game->current_score < game->target_score) {
        game->state = STATE_GAME_OVER;
    }
}

void handle_scoring(Game* game) {
    HandScore score;
    uint16_t total;
    
    score = evaluate_hand(game->hand);
    
    // Apply joker modifiers
    apply_jokers(&score, game->hand, game->jokers);
    
    // Calculate total
    total = score.chips * score.multiplier;
    game->current_score += total;
    
    // Give money reward
    game->money += (total / 10);
    
    draw_score_screen(&score, total);
    
    // Wait for A button
    waitpad(J_A);
    waitpadup();
    
    // Check if target met
    if (game->current_score >= game->target_score) {
        game->state = STATE_SHOP;
    } else {
        // Deal new hand
        deal_hand(game->deck, game->hand, &deck_pos);
        game->state = STATE_PLAY_HAND;
    }
}

void handle_shop(Game* game, ShopItem* items) {
    uint8_t cursor = 0;
    uint8_t done = 0;
    
    init_shop(items, game->blind_level);
    
    while (!done) {
        draw_shop_screen(game, items, cursor);
        
        waitpad(J_A | J_B | J_UP | J_DOWN);
        
        if (joypad() & J_UP) {
            if (cursor > 0) cursor--;
            waitpadup();
            delay(100);
        } else if (joypad() & J_DOWN) {
            if (cursor < SHOP_ITEMS - 1) cursor++;
            waitpadup();
            delay(100);
        } else if (joypad() & J_A) {
            // Try to purchase
            purchase_item(game, &items[cursor]);
            waitpadup();
            delay(100);
        } else if (joypad() & J_B) {
            // Exit shop
            done = 1;
            waitpadup();
        }
    }
    
    // Advance to next blind
    game->blind_level++;
    game->target_score += 200 + (game->blind_level * 50);
    game->current_score = 0;
    game->hands_left = 4;
    game->discards_left = 3;
    
    // Deal new hand
    deal_hand(game->deck, game->hand, &deck_pos);
    
    game->state = STATE_BLIND_SELECT;
}

void run_game(void) {
    Game game;
    ShopItem shop_items[SHOP_ITEMS];
    
    init_graphics();
    
    // Title screen
    draw_title_screen();
    waitpad(J_START);
    waitpadup();
    
    // Initialize game
    init_game(&game);
    
    // Main game loop
    while (game.state != STATE_GAME_OVER) {
        switch (game.state) {
            case STATE_BLIND_SELECT:
                handle_blind_select(&game);
                break;
                
            case STATE_PLAY_HAND:
                handle_play_hand(&game);
                break;
                
            case STATE_SCORING:
                handle_scoring(&game);
                break;
                
            case STATE_SHOP:
                handle_shop(&game, shop_items);
                break;
                
            default:
                game.state = STATE_GAME_OVER;
                break;
        }
    }
    
    // Game over screen
    cls();
    print_text(5, 8, "GAME OVER");
    print_text(3, 10, "BLIND:");
    print_number(10, 10, game.blind_level);
}
