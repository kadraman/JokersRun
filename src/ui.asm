;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14228 (Linux)
;--------------------------------------------------------
	.module ui
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cls
	.globl _set_sprite_palette
	.globl _set_bkg_palette
	.globl _get_hand_name
	.globl _get_joker_name
	.globl _set_bkg_tiles
	.globl _sprite_palette
	.globl _bg_palette
	.globl _init_graphics
	.globl _print_text
	.globl _print_number
	.globl _draw_title_screen
	.globl _draw_blind_screen
	.globl _draw_game_screen
	.globl _draw_shop_screen
	.globl _draw_score_screen
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
;src/ui.c:31: void init_graphics(void) {
;	---------------------------------
; Function init_graphics
; ---------------------------------
_init_graphics::
;src/ui.c:33: set_bkg_palette(0, 4, bg_palette);
	ld	de, #_bg_palette
	push	de
	ld	hl, #0x400
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/ui.c:34: set_sprite_palette(0, 4, sprite_palette);
	ld	de, #_sprite_palette
	push	de
	ld	hl, #0x400
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/ui.c:37: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;src/ui.c:38: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/ui.c:39: }
	ret
_bg_palette:
	.dw #0x7fff
	.dw #0x56b5
	.dw #0x294a
	.dw #0x0000
	.dw #0x7fff
	.dw #0x295f
	.dw #0x0015
	.dw #0x0000
	.dw #0x7fff
	.dw #0x294a
	.dw #0x14a5
	.dw #0x0000
	.dw #0x7fff
	.dw #0x7e8a
	.dw #0x5545
	.dw #0x2800
_sprite_palette:
	.dw #0x03ff
	.dw #0x02bf
	.dw #0x0155
	.dw #0x00aa
	.dw #0x7fff
	.dw #0x56b5
	.dw #0x294a
	.dw #0x0000
	.dw #0x7fff
	.dw #0x56b5
	.dw #0x294a
	.dw #0x0000
	.dw #0x7fff
	.dw #0x56b5
	.dw #0x294a
	.dw #0x0000
;src/ui.c:41: void print_text(uint8_t x, uint8_t y, const char* text) {
;	---------------------------------
; Function print_text
; ---------------------------------
_print_text::
	dec	sp
	dec	sp
	ldhl	sp,	#1
	ld	(hl-), a
	ld	(hl), e
;src/ui.c:43: while (text[i] != '\0' && i < 20) {
	ld	c, #0x00
00102$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00105$
	ld	a, c
	sub	a, #0x14
	jr	NC, 00105$
;src/ui.c:44: set_bkg_tiles(x + i, y, 1, 1, (unsigned char*)&text[i]);
	ldhl	sp,	#1
	ld	a, (hl)
	add	a, c
	push	de
	ld	h, #0x01
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ld	h, #0x01
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ldhl	sp,	#4
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/ui.c:45: i++;
	inc	c
	jr	00102$
00105$:
;src/ui.c:47: }
	inc	sp
	inc	sp
	pop	hl
	pop	af
	jp	(hl)
;src/ui.c:49: void print_number(uint8_t x, uint8_t y, uint16_t num) {
;	---------------------------------
; Function print_number
; ---------------------------------
_print_number::
	add	sp, #-18
	ldhl	sp,	#16
	ld	(hl-), a
	ld	(hl), e
;src/ui.c:54: if (num == 0) {
	ldhl	sp,	#21
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00106$
;src/ui.c:55: buffer[0] = '0';
	ldhl	sp,	#0
;src/ui.c:56: buffer[1] = '\0';
	ld	a, #0x30
	ld	(hl+), a
	ld	(hl), #0x00
;src/ui.c:57: len = 1;
	jp	00107$
00106$:
;src/ui.c:59: uint16_t temp = num;
	ldhl	sp,	#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;src/ui.c:63: while (temp > 0) {
	ldhl	sp,	#17
	ld	(hl), #0x00
00101$:
	ld	a, d
	or	a, e
	jr	Z, 00118$
;src/ui.c:64: digits[len++] = temp % 10;
	push	de
	push	hl
	ld	hl, #10
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#19
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#17
	inc	(hl)
	ldhl	sp,	#13
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	bc, #0x000a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/ui.c:65: temp /= 10;
	ld	bc, #0x000a
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__divuint
	ld	e, c
	ld	d, b
	jr	00101$
00118$:
	ldhl	sp,	#17
	ld	c, (hl)
;src/ui.c:68: for (i = 0; i < len; i++) {
	ld	b, #0x00
00109$:
	ld	a, b
	sub	a, c
	jr	NC, 00104$
;src/ui.c:69: buffer[i] = '0' + digits[len - 1 - i];
	ld	e, b
	ld	d, #0x00
	ld	hl, #0
	add	hl, sp
	add	hl, de
	ld	a, c
	dec	a
	ld	e, b
	sub	a, e
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	push	hl
	push	af
	ld	hl, #10
	add	hl, sp
	pop	af
	ld	a, l
	pop	hl
	add	a, e
	ld	e, a
	push	hl
	push	af
	ld	hl, #10
	add	hl, sp
	pop	af
	ld	a, h
	pop	hl
	adc	a, d
	ld	d, a
	ld	a, (de)
	add	a, #0x30
	ld	(hl), a
;src/ui.c:68: for (i = 0; i < len; i++) {
	inc	b
	jr	00109$
00104$:
;src/ui.c:71: buffer[len] = '\0';
	ld	e, c
	ld	d, #0x00
	ld	hl, #0
	add	hl, sp
	add	hl, de
	ld	(hl), #0x00
00107$:
;src/ui.c:74: print_text(x, y, buffer);
	ld	hl, #0
	add	hl, sp
	push	hl
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl)
	call	_print_text
;src/ui.c:75: }
	add	sp, #18
	pop	hl
	pop	af
	jp	(hl)
;src/ui.c:77: void draw_title_screen(void) {
;	---------------------------------
; Function draw_title_screen
; ---------------------------------
_draw_title_screen::
;src/ui.c:78: cls();
	call	_cls
;src/ui.c:79: print_text(3, 5, "CHROMA CARDS");
	ld	de, #___str_0
	push	de
	ld	e, #0x05
	ld	a, #0x03
	call	_print_text
;src/ui.c:80: print_text(3, 7, "JOKER'S RUN");
	ld	de, #___str_1
	push	de
	ld	e, #0x07
	ld	a, #0x03
	call	_print_text
;src/ui.c:81: print_text(3, 12, "Press START");
	ld	de, #___str_2
	push	de
	ld	e, #0x0c
	ld	a, #0x03
	call	_print_text
;src/ui.c:82: }
	ret
___str_0:
	.ascii "CHROMA CARDS"
	.db 0x00
___str_1:
	.ascii "JOKER'S RUN"
	.db 0x00
___str_2:
	.ascii "Press START"
	.db 0x00
;src/ui.c:84: void draw_blind_screen(uint8_t level, uint16_t target) {
;	---------------------------------
; Function draw_blind_screen
; ---------------------------------
_draw_blind_screen::
	ld	c, a
;src/ui.c:85: cls();
	push	bc
	push	de
	call	_cls
	ld	hl, #___str_3
	push	hl
	ld	a,#0x05
	ld	e,a
	call	_print_text
	pop	de
	pop	bc
;src/ui.c:87: print_number(11, 5, level);
	ld	b, #0x00
	push	de
	push	bc
	ld	e, #0x05
	ld	a, #0x0b
	call	_print_number
	ld	bc, #___str_4
	push	bc
	ld	e, #0x08
	ld	a, #0x05
	call	_print_text
	ld	e, #0x09
	ld	a, #0x05
	call	_print_number
;src/ui.c:90: print_text(4, 14, "Press START");
	ld	de, #___str_5
	push	de
	ld	e, #0x0e
	ld	a, #0x04
	call	_print_text
;src/ui.c:91: }
	ret
___str_3:
	.ascii "BLIND "
	.db 0x00
___str_4:
	.ascii "TARGET:"
	.db 0x00
___str_5:
	.ascii "Press START"
	.db 0x00
;src/ui.c:93: void draw_game_screen(Game* game) {
;	---------------------------------
; Function draw_game_screen
; ---------------------------------
_draw_game_screen::
	dec	sp
	dec	sp
;src/ui.c:94: cls();
	push	de
	call	_cls
	ld	de, #___str_6
	push	de
	ld	a,#0x01
	ld	e,a
	call	_print_text
	pop	bc
;src/ui.c:98: print_number(8, 1, game->current_score);
	ld	hl, #0x0004
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	hl
	ld	e, #0x01
	ld	a, #0x08
	call	_print_number
	ld	de, #___str_7
	push	de
	ld	e, #0x02
	ld	a, #0x01
	call	_print_text
	pop	bc
;src/ui.c:101: print_number(9, 2, game->target_score);
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
	push	bc
	push	hl
	ld	e, #0x02
	ld	a, #0x09
	call	_print_number
	ld	de, #___str_8
	push	de
	ld	e, #0x04
	ld	a, #0x01
	call	_print_text
	pop	bc
;src/ui.c:105: print_number(8, 4, game->hands_left);
	ld	hl, #0x0006
	add	hl, bc
	ld	e, (hl)
	ld	d, #0x00
	push	bc
	push	de
	ld	e, #0x04
	ld	a, #0x08
	call	_print_number
	ld	de, #___str_9
	push	de
	ld	e, #0x05
	ld	a, #0x01
	call	_print_text
	pop	bc
;src/ui.c:108: print_number(9, 5, game->money);
	ld	hl, #0x0008
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	bc
	push	hl
	ld	e, #0x05
	ld	a, #0x09
	call	_print_number
	pop	bc
;src/ui.c:111: if (game->jokers[0].active || game->jokers[1].active) {
	ld	hl, #0x000a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	inc	de
	ld	a, (de)
	or	a, a
	jr	NZ, 00104$
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, (de)
	or	a, a
	jr	Z, 00111$
00104$:
;src/ui.c:112: print_text(1, 14, "JOKERS:");
	push	bc
	ld	de, #___str_10
	push	de
	ld	e, #0x0e
	ld	a, #0x01
	call	_print_text
	pop	bc
;src/ui.c:113: uint8_t x = 1;
	ldhl	sp,	#0
;src/ui.c:115: for (i = 0; i < MAX_JOKERS && x < 15; i++) {
	ld	a, #0x01
	ld	(hl+), a
	ld	(hl), #0x00
00109$:
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x05
	jr	NC, 00111$
	dec	hl
	ld	a, (hl)
	sub	a, #0x0f
	jr	NC, 00111$
;src/ui.c:116: if (game->jokers[i].active) {
	inc	hl
	ld	a, (hl)
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	e, l
	ld	d, h
	inc	de
	ld	a, (de)
	or	a, a
	jr	Z, 00110$
;src/ui.c:117: const char* name = get_joker_name(game->jokers[i].type);
	ld	e, (hl)
	push	bc
	ld	a, e
	call	_get_joker_name
	push	bc
	ld	e, #0x0f
	ldhl	sp,	#4
	ld	a, (hl)
	call	_print_text
	pop	bc
;src/ui.c:119: x += 6;
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0x06
	ld	(hl), a
00110$:
;src/ui.c:115: for (i = 0; i < MAX_JOKERS && x < 15; i++) {
	ldhl	sp,	#1
	inc	(hl)
	jr	00109$
00111$:
;src/ui.c:125: }
	inc	sp
	inc	sp
	ret
___str_6:
	.ascii "SCORE:"
	.db 0x00
___str_7:
	.ascii "TARGET:"
	.db 0x00
___str_8:
	.ascii "HANDS:"
	.db 0x00
___str_9:
	.ascii "MONEY:$"
	.db 0x00
___str_10:
	.ascii "JOKERS:"
	.db 0x00
;src/ui.c:127: void draw_shop_screen(Game* game, ShopItem* items, uint8_t cursor) {
;	---------------------------------
; Function draw_shop_screen
; ---------------------------------
_draw_shop_screen::
	add	sp, #-4
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/ui.c:128: cls();
	push	de
	call	_cls
	ld	bc, #___str_11
	push	bc
	ld	e, #0x02
	ld	a, #0x06
	call	_print_text
	ld	bc, #___str_12
	push	bc
	ld	e, #0x04
	ld	a, #0x01
	call	_print_text
	pop	de
;src/ui.c:131: print_number(9, 4, game->money);
	ld	hl, #0x0008
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #0x04
	ld	a, #0x09
	call	_print_number
;src/ui.c:134: uint8_t y = 7;
	ldhl	sp,	#0
	ld	(hl), #0x07
;src/ui.c:136: for (i = 0; i < SHOP_ITEMS; i++) {
	ldhl	sp,	#3
	ld	(hl), #0x00
00108$:
;src/ui.c:137: if (cursor == i) {
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#3
	sub	a, (hl)
	jr	NZ, 00102$
;src/ui.c:138: print_text(1, y, ">");
	ld	de, #___str_13
	push	de
	ldhl	sp,	#2
	ld	e, (hl)
	ld	a, #0x01
	call	_print_text
	jr	00103$
00102$:
;src/ui.c:140: print_text(1, y, " ");
	ld	de, #___str_14
	push	de
	ldhl	sp,	#2
	ld	e, (hl)
	ld	a, #0x01
	call	_print_text
00103$:
;src/ui.c:143: if (items[i].type == SHOP_ITEM_JOKER) {
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	d, #0x00
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00105$
;src/ui.c:144: const char* name = get_joker_name(items[i].joker);
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	e, (hl)
	push	bc
	ld	a, e
	call	_get_joker_name
	push	bc
	ldhl	sp,	#4
	ld	e, (hl)
	ld	a, #0x03
	call	_print_text
	pop	bc
	jr	00106$
00105$:
;src/ui.c:147: print_text(3, y, "+1 Hand");
	push	bc
	ld	de, #___str_15
	push	de
	ldhl	sp,	#4
	ld	e, (hl)
	ld	a, #0x03
	call	_print_text
	pop	bc
00106$:
;src/ui.c:150: print_text(11, y, "$");
	push	bc
	ld	de, #___str_16
	push	de
	ldhl	sp,	#4
	ld	e, (hl)
	ld	a, #0x0b
	call	_print_text
;src/ui.c:151: print_number(12, y, items[i].cost);
	pop	hl
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ldhl	sp,	#2
	ld	e, (hl)
	ld	a, #0x0c
	call	_print_number
;src/ui.c:153: y += 2;
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0x02
	ld	(hl), a
;src/ui.c:136: for (i = 0; i < SHOP_ITEMS; i++) {
	ldhl	sp,	#3
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jp	C, 00108$
;src/ui.c:156: print_text(1, 15, "A:Buy B:Exit");
	ld	de, #___str_17
	push	de
	ld	e, #0x0f
	ld	a, #0x01
	call	_print_text
;src/ui.c:157: }
	add	sp, #4
	pop	hl
	inc	sp
	jp	(hl)
___str_11:
	.ascii "SHOP"
	.db 0x00
___str_12:
	.ascii "MONEY:$"
	.db 0x00
___str_13:
	.ascii ">"
	.db 0x00
___str_14:
	.ascii " "
	.db 0x00
___str_15:
	.ascii "+1 Hand"
	.db 0x00
___str_16:
	.ascii "$"
	.db 0x00
___str_17:
	.ascii "A:Buy B:Exit"
	.db 0x00
;src/ui.c:159: void draw_score_screen(HandScore* score, uint16_t total) {
;	---------------------------------
; Function draw_score_screen
; ---------------------------------
_draw_score_screen::
	add	sp, #-4
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	inc	sp
	inc	sp
	push	bc
;src/ui.c:160: cls();
	call	_cls
;src/ui.c:162: print_text(3, 5, get_hand_name(score->type));
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	call	_get_hand_name
	push	bc
	ld	e, #0x05
	ld	a, #0x03
	call	_print_text
;src/ui.c:164: print_text(3, 8, "CHIPS:");
	ld	de, #___str_18
	push	de
	ld	e, #0x08
	ld	a, #0x03
	call	_print_text
;src/ui.c:165: print_number(10, 8, score->chips);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #0x08
	ld	a, #0x0a
	call	_print_number
;src/ui.c:167: print_text(3, 9, "MULT: x");
	ld	de, #___str_19
	push	de
	ld	e, #0x09
	ld	a, #0x03
	call	_print_text
;src/ui.c:168: print_number(11, 9, score->multiplier);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	b, #0x00
	ld	c, a
	push	bc
	ld	e, #0x09
	ld	a, #0x0b
	call	_print_number
;src/ui.c:170: print_text(3, 11, "SCORE:");
	ld	de, #___str_20
	push	de
	ld	e, #0x0b
	ld	a, #0x03
	call	_print_text
;src/ui.c:171: print_number(10, 11, total);
	pop	de
	push	de
	push	de
	ld	e, #0x0b
	ld	a, #0x0a
	call	_print_number
;src/ui.c:173: print_text(3, 14, "Press A");
	ld	de, #___str_21
	push	de
	ld	e, #0x0e
	ld	a, #0x03
	call	_print_text
;src/ui.c:174: }
	add	sp, #4
	ret
___str_18:
	.ascii "CHIPS:"
	.db 0x00
___str_19:
	.ascii "MULT: x"
	.db 0x00
___str_20:
	.ascii "SCORE:"
	.db 0x00
___str_21:
	.ascii "Press A"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
