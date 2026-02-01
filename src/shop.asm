;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14228 (Linux)
;--------------------------------------------------------
	.module shop
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _init_shop
	.globl _purchase_item
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
_shop_rng:
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
;src/shop.c:6: static uint8_t shop_random(void) {
;	---------------------------------
; Function shop_random
; ---------------------------------
_shop_random:
;src/shop.c:7: shop_rng = (shop_rng * 73 + 17) & 0xFF;
	ld	hl, #_shop_rng
	ld	a, (hl)
	ld	c, a
	add	a, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, c
	add	a, #0x11
;src/shop.c:8: return shop_rng;
	ld	(hl), a
;src/shop.c:9: }
	ret
;src/shop.c:11: void init_shop(ShopItem* items, uint8_t blind_level) {
;	---------------------------------
; Function init_shop
; ---------------------------------
_init_shop::
	add	sp, #-10
	ldhl	sp,	#7
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
	ld	(hl), a
;src/shop.c:14: for (i = 0; i < SHOP_ITEMS; i++) {
	ldhl	sp,	#9
	ld	(hl), #0x00
00105$:
;src/shop.c:15: uint8_t item_type = shop_random() % 2;
	call	_shop_random
	and	a, #0x01
	ld	e, a
;src/shop.c:19: items[i].type = SHOP_ITEM_JOKER;
	ldhl	sp,	#9
	ld	c, (hl)
	ld	b, #0x00
;src/shop.c:21: items[i].cost = 50 + (blind_level * 10);
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
;src/shop.c:19: items[i].type = SHOP_ITEM_JOKER;
	sla	c
	rl	b
	sla	c
	rl	b
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
;src/shop.c:20: items[i].joker = (shop_random() % 4) + 1; // JOKER_MULTIPLIER to JOKER_FACE_BONUS
	ld	c,l
	ld	b,h
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
;src/shop.c:21: items[i].cost = 50 + (blind_level * 10);
	ld	hl, #0x0002
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
;src/shop.c:17: if (item_type == 0) {
	ld	a, e
;src/shop.c:19: items[i].type = SHOP_ITEM_JOKER;
	or	a,a
	jr	NZ, 00102$
	ld	(bc), a
;src/shop.c:20: items[i].joker = (shop_random() % 4) + 1; // JOKER_MULTIPLIER to JOKER_FACE_BONUS
	call	_shop_random
	and	a, #0x03
	ld	c, a
	inc	c
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/shop.c:21: items[i].cost = 50 + (blind_level * 10);
	pop	bc
	push	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #0x0032
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jr	00106$
00102$:
;src/shop.c:24: items[i].type = SHOP_ITEM_REROLL;
	ld	a, #0x02
	ld	(bc), a
;src/shop.c:25: items[i].joker = JOKER_NONE;
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/shop.c:26: items[i].cost = 25 + (blind_level * 5);
	pop	bc
	push	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #0x0019
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00106$:
;src/shop.c:14: for (i = 0; i < SHOP_ITEMS; i++) {
	ldhl	sp,	#9
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jp	C, 00105$
;src/shop.c:29: }
	add	sp, #10
	ret
;src/shop.c:31: uint8_t purchase_item(Game* game, ShopItem* item) {
;	---------------------------------
; Function purchase_item
; ---------------------------------
_purchase_item::
	add	sp, #-16
	ldhl	sp,	#14
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#12
	ld	a, c
	ld	(hl+), a
;src/shop.c:35: if (game->money < item->cost) {
	ld	a, b
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
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
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, l
	ld	a, b
	sbc	a, h
	jr	NC, 00102$
;src/shop.c:36: return 0; // Cannot afford
	xor	a, a
	jp	00113$
00102$:
;src/shop.c:40: if (item->type == SHOP_ITEM_JOKER) {
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	or	a, a
	jp	NZ, 00109$
;src/shop.c:42: for (i = 0; i < MAX_JOKERS; i++) {
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#11
	ld	(hl), #0x00
00111$:
;src/shop.c:43: if (!game->jokers[i].active) {
	ldhl	sp,	#11
	ld	a, (hl)
	add	a, a
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
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
	ld	a, (de)
	or	a, a
	jr	NZ, 00112$
;src/shop.c:44: game->jokers[i].type = item->joker;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#11
	ld	a, (hl)
	ld	(de), a
;src/shop.c:45: game->jokers[i].active = 1;
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/shop.c:46: game->money -= item->cost;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#10
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/shop.c:47: return 1;
	ld	a, #0x01
	jr	00113$
00112$:
;src/shop.c:42: for (i = 0; i < MAX_JOKERS; i++) {
	ldhl	sp,	#11
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jp	C, 00111$
;src/shop.c:50: return 0; // No space for joker
	xor	a, a
	jr	00113$
00109$:
;src/shop.c:51: } else if (item->type == SHOP_ITEM_REROLL) {
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00110$
;src/shop.c:53: game->hands_left++;
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	ld	(bc), a
;src/shop.c:54: game->money -= item->cost;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	de
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, c
	sub	a, l
	ld	c, a
	ld	a, b
	sbc	a, h
	ld	b, a
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/shop.c:55: return 1;
	ld	a, #0x01
	jr	00113$
00110$:
;src/shop.c:58: return 0;
	xor	a, a
00113$:
;src/shop.c:59: }
	add	sp, #16
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__shop_rng:
	.db #0x2a	; 42
	.area _CABS (ABS)
