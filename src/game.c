#include "game.h"
#include "cards.h"
#include "poker.h"
#include "jokers.h"
#include "ui.h"
#include <gb/gb.h>
#include <gbdk/console.h>
#include <gbdk/emu_debug.h>


static uint8_t deck_pos = 0;

void init_game(Game* game) {
    uint8_t i;
    
    game->state = STATE_BLIND_SELECT;
    game->blind_level = 1;
    //game->target_score = 300; // Starting target for blind 1
    game->target_score = 100;
    game->current_score = 0;
    game->hands_left = 4;
    game->discards_left = 5;
    game->extra_hands = 0;
    game->extra_discards = 0;
    game->money = 0;
    
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
    EMU_printf("Entering blind select: level=%d target=%d\n", game->blind_level, game->target_score);
    draw_blind_screen(game->blind_level, game->target_score);
    
    // Wait for START button
    waitpad(J_START);
    waitpadup();
    
    game->state = STATE_PLAY_HAND;
}

void handle_play_hand(Game* game) {
    EMU_printf("Entering play hand: score=%d target=%d hands_left=%d discards_left=%d\n", game->current_score, game->target_score, game->hands_left, game->discards_left);
    uint8_t cursor = 0;
    uint8_t done = 0;
    
    while (!done && game->hands_left > 0) {
        draw_game_screen(game);
        draw_hand(game->hand, cursor);  // Pass cursor position
        wait_vbl_done();  // Ensure screen update completes
        
        waitpad(J_A | J_B | J_LEFT | J_RIGHT | J_START | J_UP | J_DOWN);

        if (joypad() & J_LEFT) {
            if (cursor > 0) cursor--;
            waitpadup();
            delay(100);
        } else if (joypad() & J_RIGHT) {
            if (cursor < HAND_SIZE - 1) cursor++;
            waitpadup();
            delay(100);
        } else if (joypad() & J_UP) {
            // Select current card
            game->hand[cursor].selected = 1;
            waitpadup();
            delay(100);
        } else if (joypad() & J_DOWN) {
            // Deselect current card
            game->hand[cursor].selected = 0;
            waitpadup();
            delay(100);
        } else if (joypad() & J_B) {
            // Discard selected cards (draw replacements)
            if (game->discards_left > 0) {
                uint8_t selected_count = 0;
                uint8_t i;
                for (i = 0; i < HAND_SIZE; i++) {
                    if (game->hand[i].selected) selected_count++;
                }

                if (selected_count > 0) {
                    for (i = 0; i < HAND_SIZE; i++) {
                        if (game->hand[i].selected) {
                            if (deck_pos >= DECK_SIZE) {
                                deck_pos = 0;
                                shuffle_deck(game->deck);
                            }
                            game->hand[i] = game->deck[deck_pos];
                            game->hand[i].selected = 0;
                            deck_pos++;
                        }
                    }
                    game->discards_left--;
                }
            }
            waitpadup();
            delay(100);
        } else if (joypad() & J_A) {
            // Play hand (evaluate current hand)
            game->hands_left--;
            game->state = STATE_SCORING;
            done = 1;
            waitpadup();
            delay(100);
        } else if (joypad() & J_B) {
            // No-op (reserved)
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
    EMU_printf("Entering scoring: target=%d\n", game->target_score);
    HandScore score;
    uint16_t total;
    
    score = evaluate_hand(game->hand);
    
    // Apply joker modifiers
    apply_jokers(&score, game->hand, game->jokers);
    
    // Calculate total
    total = score.chips * score.multiplier;
    game->current_score += total;
    EMU_printf("Hand score: chips=%d multiplier=%d total=%d current_score=%d\n", score.chips, score.multiplier, total, game->current_score);
   
    draw_score_screen(&score, total, game->hand);
    
    // Wait for A button
    waitpad(J_A);
    waitpadup();
    
    // Check if target met
    if (game->current_score >= game->target_score) {
        // TODO: Money display
        // Give money reward
        game->money += SCORE_BLIND_BONUS; // for defeating blind
        game->money += game->hands_left; // small bonus for having extra hands left
        //game->money += game->discards_left; // small bonus for having discards left
        EMU_printf("Reward: +%d for blind, +%d for hands left\n", SCORE_BLIND_BONUS, game->hands_left);
        EMU_printf("Total money now: %d\n", game->money);
        game->state = STATE_SHOP;
    } else {
        // Deal new hand
        deal_hand(game->deck, game->hand, &deck_pos);
        game->state = STATE_PLAY_HAND;
    }
}

void handle_shop(Game* game, ShopItem* items) {
    EMU_printf("Entering shop: money=%d\n", game->money);
    uint8_t cursor = 0;
    uint8_t done = 0;
    
    init_shop(game, items, game->blind_level);
    
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

    // Debug: print hands and joker state after shop
    EMU_printf("After shop: hands_left=%d money=%d\n", game->hands_left, game->money);
    for (uint8_t _i = 0; _i < MAX_JOKERS; _i++) {
        EMU_printf(" joker[%d]=active=%d type=%d\n", _i, game->jokers[_i].active, game->jokers[_i].type);
    }

    // Advance to next blind
    game->blind_level++;
    game->target_score += (game->blind_level * 50);
    /*{
        const uint16_t blind_targets[] = {300, 550, 850, 1200, 1600};
        if (game->blind_level <= sizeof(blind_targets)/sizeof(blind_targets[0])) {
            game->target_score = blind_targets[game->blind_level - 1];
        } else {
            * fallback formula for higher blinds *
            game->target_score = 300 + (game->blind_level - 1) * 300;
        }
    }*/
    game->current_score = 0;
    game->hands_left = 4 + game->extra_hands; // Start with base hands plus any extras from shop
    game->discards_left = 5 + game->extra_discards; // Start with base discards plus any extras from shop
    
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
