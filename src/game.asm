;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14228 (Linux)
;--------------------------------------------------------
	.module game
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cls
	.globl _print_number
	.globl _print_text
	.globl _draw_score_screen
	.globl _draw_shop_screen
	.globl _draw_game_screen
	.globl _draw_blind_screen
	.globl _draw_title_screen
	.globl _init_graphics
	.globl _apply_jokers
	.globl _evaluate_hand
	.globl _draw_hand
	.globl _deal_hand
	.globl _shuffle_deck
	.globl _init_deck
	.globl _purchase_item
	.globl _init_shop
	.globl _waitpadup
	.globl _waitpad
	.globl _joypad
	.globl _delay
	.globl _init_game
	.globl _handle_blind_select
	.globl _handle_play_hand
	.globl _handle_scoring
	.globl _handle_shop
	.globl _run_game
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_deck_pos:
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/game.c:11: void init_game(Game* game) {
;	---------------------------------
; Function init_game
; ---------------------------------
_init_game::
	dec	sp
	ld	c, e
	ld	b, d
;src/game.c:14: game->state = STATE_BLIND_SELECT;
	xor	a, a
	ld	(bc), a
;src/game.c:15: game->blind_level = 1;
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	(hl), #0x01
;src/game.c:16: game->target_score = 300;
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	a, #0x2c
	ld	(hl+), a
	ld	(hl), #0x01
;src/game.c:17: game->current_score = 0;
	ld	hl, #0x0004
	add	hl, bc
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/game.c:18: game->hands_left = 4;
	ld	hl, #0x0006
	add	hl, bc
	ld	(hl), #0x04
;src/game.c:19: game->discards_left = 3;
	ld	hl, #0x0007
	add	hl, bc
	ld	(hl), #0x03
;src/game.c:20: game->money = 50;
	ld	hl, #0x0008
	add	hl, bc
	ld	a, #0x32
	ld	(hl+), a
	ld	(hl), #0x00
;src/game.c:23: for (i = 0; i < MAX_JOKERS; i++) {
	ld	hl, #0x000a
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	(hl), #0x00
00102$:
;src/game.c:24: game->jokers[i].type = JOKER_NONE;
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, de
;src/game.c:25: game->jokers[i].active = 0;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/game.c:23: for (i = 0; i < MAX_JOKERS; i++) {
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00102$
;src/game.c:29: init_deck(game->deck);
	ld	hl, #0x0014
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	push	de
	call	_init_deck
	pop	de
	push	de
	call	_shuffle_deck
	pop	de
	pop	bc
;src/game.c:31: deck_pos = 0;
	ld	hl, #_deck_pos
	ld	(hl), #0x00
;src/game.c:34: deal_hand(game->deck, game->hand, &deck_pos);
	ld	hl, #0x00b0
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_deck_pos
	push	hl
	call	_deal_hand
;src/game.c:35: }
	inc	sp
	ret
;src/game.c:37: void handle_blind_select(Game* game) {
;	---------------------------------
; Function handle_blind_select
; ---------------------------------
_handle_blind_select::
	dec	sp
	ld	c, e
	ld	b, d
;src/game.c:38: draw_blind_screen(game->blind_level, game->target_score);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	e, c
	ld	d, b
	inc	de
	ld	a, (de)
	push	hl
	ldhl	sp,	#2
	ld	(hl), a
	pop	hl
	push	bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (hl)
	call	_draw_blind_screen
	pop	bc
;src/game.c:41: waitpad(J_START);
	ld	a, #0x80
	call	_waitpad
;src/game.c:42: waitpadup();
	call	_waitpadup
;src/game.c:44: game->state = STATE_PLAY_HAND;
	ld	a, #0x01
	ld	(bc), a
;src/game.c:45: }
	inc	sp
	ret
;src/game.c:47: void handle_play_hand(Game* game) {
;	---------------------------------
; Function handle_play_hand
; ---------------------------------
_handle_play_hand::
	add	sp, #-22
	ld	c, e
	ld	b, d
;src/game.c:48: uint8_t cursor = 0;
	ldhl	sp,	#19
	ld	(hl), #0x00
;src/game.c:49: uint8_t done = 0;
	ldhl	sp,	#2
	ld	(hl), #0x00
;src/game.c:51: while (!done && game->hands_left > 0) {
	ld	hl, #0x0006
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	hl, #0x00b0
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	hl, #0x0004
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	hl, #0x0002
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
00127$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jp	NZ, 00129$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jp	Z, 00129$
;src/game.c:52: draw_game_screen(game);
	push	bc
	ld	e, c
	ld	d, b
	call	_draw_game_screen
	pop	bc
;src/game.c:53: draw_hand(game->hand);
	ld	hl, #0x00b0
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	call	_draw_hand
	pop	bc
;src/game.c:55: waitpad(J_A | J_B | J_LEFT | J_RIGHT | J_START);
	ld	a, #0xb3
	call	_waitpad
;src/game.c:57: if (joypad() & J_LEFT) {
	call	_joypad
	bit	1, a
	jr	Z, 00124$
;src/game.c:58: if (cursor > 0) cursor--;
	ldhl	sp,	#19
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	dec	(hl)
00102$:
;src/game.c:59: waitpadup();
	call	_waitpadup
;src/game.c:60: delay(100);
	push	bc
	ld	de, #0x0064
	call	_delay
	pop	bc
	jr	00127$
00124$:
;src/game.c:61: } else if (joypad() & J_RIGHT) {
	call	_joypad
	rrca
	jr	NC, 00121$
;src/game.c:62: if (cursor < HAND_SIZE - 1) cursor++;
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00104$
	inc	(hl)
00104$:
;src/game.c:63: waitpadup();
	call	_waitpadup
;src/game.c:64: delay(100);
	push	bc
	ld	de, #0x0064
	call	_delay
	pop	bc
	jr	00127$
00121$:
;src/game.c:65: } else if (joypad() & J_A) {
	call	_joypad
	bit	4, a
	jr	Z, 00118$
;src/game.c:67: game->hand[cursor].selected = !game->hand[cursor].selected;
	ldhl	sp,	#19
	ld	a, (hl)
	ld	e, a
	add	a, a
	add	a, e
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, (de)
	sub	a,#0x01
	ld	a, #0x00
	rla
	ld	(de), a
;src/game.c:68: waitpadup();
	call	_waitpadup
;src/game.c:69: delay(100);
	push	bc
	ld	de, #0x0064
	call	_delay
	pop	bc
	jp	00127$
00118$:
;src/game.c:70: } else if (joypad() & J_B) {
	call	_joypad
	bit	5, a
	jr	Z, 00115$
;src/game.c:75: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#20
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00133$:
;src/game.c:76: if (game->hand[i].selected) selected_count++;
	ldhl	sp,	#21
	ld	a, (hl)
	ld	e, a
	add	a, a
	add	a, e
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00134$
	ldhl	sp,	#20
	inc	(hl)
00134$:
;src/game.c:75: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#21
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00133$
;src/game.c:79: if (selected_count == HAND_SIZE) {
	dec	hl
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00109$
;src/game.c:81: game->hands_left--;
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	dec	a
	push	af
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	pop	af
	ld	(hl), a
;src/game.c:82: game->state = STATE_SCORING;
	ld	a, #0x02
	ld	(bc), a
;src/game.c:83: done = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
00109$:
;src/game.c:85: waitpadup();
	call	_waitpadup
;src/game.c:86: delay(100);
	push	bc
	ld	de, #0x0064
	call	_delay
	pop	bc
	jp	00127$
00115$:
;src/game.c:87: } else if (joypad() & J_START) {
	call	_joypad
	rlca
	jp	NC,00127$
;src/game.c:89: if (game->current_score >= game->target_score) {
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ldhl	sp,	#20
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00111$
;src/game.c:90: game->state = STATE_SHOP;
	ld	a, #0x03
	ld	(bc), a
;src/game.c:91: done = 1;
	ldhl	sp,	#2
	ld	(hl), #0x01
00111$:
;src/game.c:93: waitpadup();
	call	_waitpadup
	jp	00127$
00129$:
;src/game.c:97: if (game->hands_left == 0 && game->current_score < game->target_score) {
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00135$
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#20
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#20
	ld	e, l
	ld	d, h
	ldhl	sp,	#18
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	NC, 00135$
;src/game.c:98: game->state = STATE_GAME_OVER;
	ld	a, #0x04
	ld	(bc), a
00135$:
;src/game.c:100: }
	add	sp, #22
	ret
;src/game.c:102: void handle_scoring(Game* game) {
;	---------------------------------
; Function handle_scoring
; ---------------------------------
_handle_scoring::
	add	sp, #-20
	ldhl	sp,	#18
	ld	a, e
	ld	(hl+), a
;src/game.c:106: score = evaluate_hand(game->hand);
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00b0
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#4
	push	hl
	call	_evaluate_hand
	ldhl	sp,	#4
	ld	c, l
	ld	b, h
	ld	de, #0x0004
	push	de
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/game.c:109: apply_jokers(&score, game->hand, game->jokers);
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	push	hl
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_apply_jokers
;src/game.c:112: total = score.chips * score.multiplier;
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#3
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;src/game.c:113: game->current_score += total;
	call	__mulint
	ldhl	sp,	#10
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#10
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#12
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/game.c:116: game->money += (total / 10);
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	bc, #0x000a
	call	__divuint
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, (hl)
	add	a, c
	ld	c, a
	ld	a, e
	adc	a, b
	ld	b, a
	ldhl	sp,	#14
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/game.c:118: draw_score_screen(&score, total);
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_draw_score_screen
;src/game.c:121: waitpad(J_A);
	ld	a, #0x10
	call	_waitpad
;src/game.c:122: waitpadup();
	call	_waitpadup
;src/game.c:125: if (game->current_score >= game->target_score) {
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	inc	hl
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	jr	C, 00102$
;src/game.c:126: game->state = STATE_SHOP;
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
	jr	00104$
00102$:
;src/game.c:129: deal_hand(game->deck, game->hand, &deck_pos);
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, #_deck_pos
	push	bc
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_deal_hand
;src/game.c:130: game->state = STATE_PLAY_HAND;
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
00104$:
;src/game.c:132: }
	add	sp, #20
	ret
;src/game.c:134: void handle_shop(Game* game, ShopItem* items) {
;	---------------------------------
; Function handle_shop
; ---------------------------------
_handle_shop::
	add	sp, #-9
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/game.c:135: uint8_t cursor = 0;
	ldhl	sp,	#8
	ld	(hl), #0x00
;src/game.c:136: uint8_t done = 0;
	ldhl	sp,	#1
	ld	(hl), #0x00
;src/game.c:138: init_shop(items, game->blind_level);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_init_shop
;src/game.c:140: while (!done) {
00116$:
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jp	NZ, 00118$
;src/game.c:141: draw_shop_screen(game, items, cursor);
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_draw_shop_screen
;src/game.c:143: waitpad(J_A | J_B | J_UP | J_DOWN);
	ld	a, #0x3c
	call	_waitpad
;src/game.c:145: if (joypad() & J_UP) {
	call	_joypad
	bit	2, a
	jr	Z, 00114$
;src/game.c:146: if (cursor > 0) cursor--;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	dec	(hl)
00102$:
;src/game.c:147: waitpadup();
	call	_waitpadup
;src/game.c:148: delay(100);
	ld	de, #0x0064
	call	_delay
	jr	00116$
00114$:
;src/game.c:149: } else if (joypad() & J_DOWN) {
	call	_joypad
	bit	3, a
	jr	Z, 00111$
;src/game.c:150: if (cursor < SHOP_ITEMS - 1) cursor++;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00104$
	inc	(hl)
00104$:
;src/game.c:151: waitpadup();
	call	_waitpadup
;src/game.c:152: delay(100);
	ld	de, #0x0064
	call	_delay
	jr	00116$
00111$:
;src/game.c:153: } else if (joypad() & J_A) {
	call	_joypad
	bit	4, a
	jr	Z, 00108$
;src/game.c:155: purchase_item(game, &items[cursor]);
	ldhl	sp,	#8
	ld	a, (hl)
	ld	d, #0x00
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_purchase_item
;src/game.c:156: waitpadup();
	call	_waitpadup
;src/game.c:157: delay(100);
	ld	de, #0x0064
	call	_delay
	jr	00116$
00108$:
;src/game.c:158: } else if (joypad() & J_B) {
	call	_joypad
	bit	5, a
	jp	Z,00116$
;src/game.c:160: done = 1;
	ldhl	sp,	#1
	ld	(hl), #0x01
;src/game.c:161: waitpadup();
	call	_waitpadup
	jp	00116$
00118$:
;src/game.c:166: game->blind_level++;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
;src/game.c:167: game->target_score += 200 + (game->blind_level * 50);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc,#0x00c8
	add	hl,bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, c
	ld	h, b
	add	hl, de
	ld	c, l
	ld	b, h
	pop	hl
	push	hl
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/game.c:168: game->current_score = 0;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	inc	bc
	ld	(bc), a
;src/game.c:169: game->hands_left = 4;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	(hl), #0x04
;src/game.c:170: game->discards_left = 3;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	(hl), #0x03
;src/game.c:173: deal_hand(game->deck, game->hand, &deck_pos);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00b0
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_deck_pos
	push	hl
	call	_deal_hand
;src/game.c:175: game->state = STATE_BLIND_SELECT;
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/game.c:176: }
	add	sp, #9
	ret
;src/game.c:178: void run_game(void) {
;	---------------------------------
; Function run_game
; ---------------------------------
_run_game::
	add	sp, #-128
	add	sp, #-75
;src/game.c:182: init_graphics();
	call	_init_graphics
;src/game.c:185: draw_title_screen();
	call	_draw_title_screen
;src/game.c:186: waitpad(J_START);
	ld	a, #0x80
	call	_waitpad
;src/game.c:187: waitpadup();
	call	_waitpadup
;src/game.c:190: init_game(&game);
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_init_game
;src/game.c:193: while (game.state != STATE_GAME_OVER) {
00107$:
	ldhl	sp,	#0
	ld	a, (hl)
	cp	a, #0x04
	jr	Z, 00109$
;src/game.c:194: switch (game.state) {
	or	a, a
	jr	Z, 00101$
	cp	a, #0x01
	jr	Z, 00102$
	cp	a, #0x02
	jr	Z, 00103$
	sub	a, #0x03
	jr	Z, 00104$
	jr	00105$
;src/game.c:195: case STATE_BLIND_SELECT:
00101$:
;src/game.c:196: handle_blind_select(&game);
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_handle_blind_select
;src/game.c:197: break;
	jr	00107$
;src/game.c:199: case STATE_PLAY_HAND:
00102$:
;src/game.c:200: handle_play_hand(&game);
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_handle_play_hand
;src/game.c:201: break;
	jr	00107$
;src/game.c:203: case STATE_SCORING:
00103$:
;src/game.c:204: handle_scoring(&game);
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_handle_scoring
;src/game.c:205: break;
	jr	00107$
;src/game.c:207: case STATE_SHOP:
00104$:
;src/game.c:208: handle_shop(&game, shop_items);
	ld	hl, #191
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_handle_shop
;src/game.c:209: break;
	jr	00107$
;src/game.c:211: default:
00105$:
;src/game.c:212: game.state = STATE_GAME_OVER;
	ldhl	sp,	#0
	ld	(hl), #0x04
;src/game.c:214: }
	jr	00107$
00109$:
;src/game.c:218: cls();
	call	_cls
;src/game.c:219: print_text(5, 8, "GAME OVER");
	ld	de, #___str_0
	push	de
	ld	e, #0x08
	ld	a, #0x05
	call	_print_text
;src/game.c:220: print_text(3, 10, "BLIND:");
	ld	de, #___str_1
	push	de
	ld	e, #0x0a
	ld	a, #0x03
	call	_print_text
;src/game.c:221: print_number(10, 10, game.blind_level);
	ldhl	sp,	#1
	ld	c, (hl)
	ld	b, #0x00
	push	bc
	ld	a,#0x0a
	ld	e,a
	call	_print_number
;src/game.c:222: }
	add	sp, #127
	add	sp, #76
	ret
___str_0:
	.ascii "GAME OVER"
	.db 0x00
___str_1:
	.ascii "BLIND:"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__deck_pos:
	.db #0x00	; 0
	.area _CABS (ABS)
