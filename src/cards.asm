;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14228 (Linux)
;--------------------------------------------------------
	.module cards
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_bkg_tiles
	.globl _init_deck
	.globl _shuffle_deck
	.globl _deal_hand
	.globl _draw_card
	.globl _draw_hand
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
_rng_seed:
	.ds 2
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
;src/cards.c:9: static uint8_t random_byte(void) {
;	---------------------------------
; Function random_byte
; ---------------------------------
_random_byte:
;src/cards.c:10: rng_seed = (rng_seed * 1103515245 + 12345) & 0x7FFF;
	ld	hl, #_rng_seed
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #0x3039
	add	hl, bc
	ld	a, l
	ld	(_rng_seed), a
	ld	a, h
	and	a, #0x7f
;src/cards.c:11: return (uint8_t)(rng_seed >> 8);
	ld	(#_rng_seed + 1), a
;src/cards.c:12: }
	ret
;src/cards.c:14: void init_deck(Card* deck) {
;	---------------------------------
; Function init_deck
; ---------------------------------
_init_deck::
	add	sp, #-5
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
;src/cards.c:15: uint8_t i = 0;
;src/cards.c:18: for (suit = 0; suit < SUITS; suit++) {
	ld	a, d
	ld	(hl+), a
	ld	c, #0x00
	ld	(hl), c
;src/cards.c:19: for (rank = 0; rank < RANKS; rank++) {
00109$:
	ld	b, #0x00
00103$:
;src/cards.c:20: deck[i].suit = suit;
	ld	e, c
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(de), a
;src/cards.c:21: deck[i].rank = rank;
	ld	l, e
;	spillPairReg hl
;	spillPairReg hl
	ld	h, d
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	(hl), b
;src/cards.c:22: deck[i].selected = 0;
	inc	de
	inc	de
	xor	a, a
	ld	(de), a
;src/cards.c:23: i++;
	inc	c
;src/cards.c:19: for (rank = 0; rank < RANKS; rank++) {
	inc	b
	ld	a, b
	sub	a, #0x0d
	jr	C, 00103$
;src/cards.c:18: for (suit = 0; suit < SUITS; suit++) {
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00109$
;src/cards.c:26: }
	add	sp, #5
	ret
;src/cards.c:28: void shuffle_deck(Card* deck) {
;	---------------------------------
; Function shuffle_deck
; ---------------------------------
_shuffle_deck::
	add	sp, #-10
	ldhl	sp,	#7
	ld	(hl), e
	inc	hl
	ld	(hl), d
;src/cards.c:33: for (i = DECK_SIZE - 1; i > 0; i--) {
	inc	hl
	ld	(hl), #0x33
00102$:
;src/cards.c:34: j = random_byte() % (i + 1);
	call	_random_byte
	ldhl	sp,	#9
	ld	c, (hl)
	ld	b, #0x00
	inc	bc
	ld	e, a
	ld	d, #0x00
	call	__modsint
	ldhl	sp,	#6
	ld	(hl), c
;src/cards.c:37: temp = deck[i];
	ldhl	sp,	#9
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0003
	push	de
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	call	___memcpy
;src/cards.c:38: deck[i] = deck[j];
	ldhl	sp,	#6
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	push	hl
	call	___memcpy
;src/cards.c:39: deck[j] = temp;
	ld	hl, #0
	add	hl, sp
	ld	c, l
	ld	b, h
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	push	hl
	call	___memcpy
;src/cards.c:33: for (i = DECK_SIZE - 1; i > 0; i--) {
	ldhl	sp,	#9
	dec	(hl)
	ld	a, (hl)
	jp	NZ, 00102$
;src/cards.c:41: }
	add	sp, #10
	ret
;src/cards.c:43: void deal_hand(Card* deck, Card* hand, uint8_t* deck_pos) {
;	---------------------------------
; Function deal_hand
; ---------------------------------
_deal_hand::
	add	sp, #-10
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/cards.c:46: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#9
	ld	(hl), #0x00
00104$:
;src/cards.c:47: if (*deck_pos >= DECK_SIZE) {
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x34
	jr	C, 00102$
;src/cards.c:48: *deck_pos = 0; // Reshuffle if needed
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), #0x00
;src/cards.c:49: shuffle_deck(deck);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_shuffle_deck
00102$:
;src/cards.c:51: hand[i] = deck[*deck_pos];
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	a, h
	ldhl	sp,	#0
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	bc, #0x0003
	push	bc
	push	hl
	ldhl	sp,	#6
	ld	c, (hl)
	ldhl	sp,	#7
	ld	b, (hl)
	pop	de
	call	___memcpy
	pop	de
;src/cards.c:52: hand[i].selected = 0;
	inc	de
	inc	de
	inc	sp
	inc	sp
	ld	l, e
	ld	h, d
	ld	(hl), #0x00
	push	hl
;src/cards.c:53: (*deck_pos)++;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl-)
	ld	c, a
	inc	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
;src/cards.c:46: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#9
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jp	C, 00104$
;src/cards.c:55: }
	add	sp, #10
	pop	hl
	pop	af
	jp	(hl)
;src/cards.c:59: void draw_card(uint8_t x, uint8_t y, Card* card) {
;	---------------------------------
; Function draw_card
; ---------------------------------
_draw_card::
	add	sp, #-6
	ldhl	sp,	#5
	ld	(hl-), a
	ld	(hl), e
;src/cards.c:63: if (card->rank <= 8) {
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	e, (hl)
	ld	a, #0x08
	sub	a, e
	jr	C, 00114$
;src/cards.c:64: rank_char = '2' + card->rank;
	ld	a, e
	add	a, #0x32
	ldhl	sp,	#0
	ld	(hl), a
	jr	00115$
00114$:
;src/cards.c:65: } else if (card->rank == RANK_10) {
	ld	a, e
	sub	a, #0x08
	jr	NZ, 00111$
;src/cards.c:66: rank_char = 'T';
	ldhl	sp,	#0
	ld	(hl), #0x54
	jr	00115$
00111$:
;src/cards.c:67: } else if (card->rank == RANK_JACK) {
	ld	a, e
	sub	a, #0x09
	jr	NZ, 00108$
;src/cards.c:68: rank_char = 'J';
	ldhl	sp,	#0
	ld	(hl), #0x4a
	jr	00115$
00108$:
;src/cards.c:69: } else if (card->rank == RANK_QUEEN) {
	ld	a, e
	sub	a, #0x0a
	jr	NZ, 00105$
;src/cards.c:70: rank_char = 'Q';
	ldhl	sp,	#0
	ld	(hl), #0x51
	jr	00115$
00105$:
;src/cards.c:71: } else if (card->rank == RANK_KING) {
	ld	a, e
	sub	a, #0x0b
	jr	NZ, 00102$
;src/cards.c:72: rank_char = 'K';
	ldhl	sp,	#0
	ld	(hl), #0x4b
	jr	00115$
00102$:
;src/cards.c:74: rank_char = 'A';
	ldhl	sp,	#0
	ld	(hl), #0x41
00115$:
;src/cards.c:78: switch (card->suit) {
	ld	a, (bc)
	or	a, a
	jr	Z, 00116$
	cp	a, #0x01
	jr	Z, 00117$
	cp	a, #0x02
	jr	Z, 00118$
	sub	a, #0x03
	jr	Z, 00119$
	jr	00120$
;src/cards.c:79: case SUIT_HEARTS:   suit_char = 'H'; break;
00116$:
	ldhl	sp,	#1
	ld	(hl), #0x48
	jr	00121$
;src/cards.c:80: case SUIT_DIAMONDS: suit_char = 'D'; break;
00117$:
	ldhl	sp,	#1
	ld	(hl), #0x44
	jr	00121$
;src/cards.c:81: case SUIT_CLUBS:    suit_char = 'C'; break;
00118$:
	ldhl	sp,	#1
	ld	(hl), #0x43
	jr	00121$
;src/cards.c:82: case SUIT_SPADES:   suit_char = 'S'; break;
00119$:
	ldhl	sp,	#1
	ld	(hl), #0x53
	jr	00121$
;src/cards.c:83: default:            suit_char = '?'; break;
00120$:
	ldhl	sp,	#1
	ld	(hl), #0x3f
;src/cards.c:84: }
00121$:
;src/cards.c:87: set_bkg_tiles(x, y, 1, 1, (unsigned char*)"+");
	ld	de, #___str_0
	push	de
	ld	hl, #0x101
	push	hl
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:88: set_bkg_tiles(x+1, y, 1, 1, (unsigned char*)"-");
	ldhl	sp,	#5
	ld	c, (hl)
	ld	a, c
	inc	a
	ldhl	sp,	#2
	ld	(hl+), a
	inc	hl
	ld	de, #___str_1
	push	de
	ld	de, #0x101
	push	de
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:89: set_bkg_tiles(x+2, y, 1, 1, (unsigned char*)"+");
	ld	a, c
	add	a, #0x02
	ldhl	sp,	#3
	ld	(hl+), a
	ld	de, #___str_0
	push	de
	ld	de, #0x101
	push	de
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:92: set_bkg_tiles(x, y+1, 1, 1, (unsigned char*)"|");
	ldhl	sp,	#4
	ld	c, (hl)
	ld	e, c
	inc	e
	push	de
	ld	hl, #___str_2
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	d, #0x01
	push	de
	ldhl	sp,	#12
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
	pop	de
;src/cards.c:93: set_bkg_tiles(x+1, y+1, 1, 1, &rank_char);
	push	de
	ld	hl, #2
	add	hl, sp
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	d, #0x01
	push	de
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
	pop	de
;src/cards.c:94: set_bkg_tiles(x+2, y+1, 1, 1, (unsigned char*)"|");
	ld	hl, #___str_2
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	d, #0x01
	push	de
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:96: set_bkg_tiles(x, y+2, 1, 1, (unsigned char*)"|");
	ld	e, c
	inc	e
	inc	e
	push	de
	ld	hl, #___str_2
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	d, #0x01
	push	de
	ldhl	sp,	#12
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
	pop	de
;src/cards.c:97: set_bkg_tiles(x+1, y+2, 1, 1, &suit_char);
	push	de
	ld	hl, #3
	add	hl, sp
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	d, #0x01
	push	de
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
	pop	de
;src/cards.c:98: set_bkg_tiles(x+2, y+2, 1, 1, (unsigned char*)"|");
	ld	hl, #___str_2
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	d, #0x01
	push	de
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:100: set_bkg_tiles(x, y+3, 1, 1, (unsigned char*)"+");
	inc	c
	inc	c
	inc	c
	ld	de, #___str_0
	push	de
	ld	hl, #0x101
	push	hl
	ld	a, c
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:101: set_bkg_tiles(x+1, y+3, 1, 1, (unsigned char*)"-");
	ld	de, #___str_1
	push	de
	ld	hl, #0x101
	push	hl
	ld	a, c
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cards.c:102: set_bkg_tiles(x+2, y+3, 1, 1, (unsigned char*)"+");
	ld	de, #___str_0
	push	de
	ld	hl, #0x101
	push	hl
	ld	a, c
	push	af
	inc	sp
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
;src/cards.c:103: }
	add	sp, #12
	pop	hl
	pop	af
	jp	(hl)
___str_0:
	.ascii "+"
	.db 0x00
___str_1:
	.ascii "-"
	.db 0x00
___str_2:
	.ascii "|"
	.db 0x00
;src/cards.c:105: void draw_hand(Card* hand) {
;	---------------------------------
; Function draw_hand
; ---------------------------------
_draw_hand::
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/cards.c:110: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#1
	ld	(hl), #0x00
00105$:
;src/cards.c:111: x_pos = 2 + (i * 4); // 4 tiles per card with spacing
	ldhl	sp,	#1
	ld	a, (hl-)
	add	a, a
	add	a, a
	add	a, #0x02
;src/cards.c:112: draw_card(x_pos, 8, &hand[i]);
	ld	(hl+), a
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	push	hl
	push	bc
	push	hl
	ld	e, #0x08
	push	hl
	ldhl	sp,	#8
	ld	a, (hl)
	pop	hl
	call	_draw_card
	pop	bc
	pop	hl
;src/cards.c:115: if (hand[i].selected) {
	inc	hl
	inc	hl
	ld	a, (hl)
;src/cards.c:116: set_bkg_tiles(x_pos+1, 7, 1, 1, (unsigned char*)"^");
	ldhl	sp,	#0
	ld	d, (hl)
	inc	d
;src/cards.c:115: if (hand[i].selected) {
	or	a, a
	jr	Z, 00102$
;src/cards.c:116: set_bkg_tiles(x_pos+1, 7, 1, 1, (unsigned char*)"^");
	ld	hl, #___str_3
	push	hl
	ld	hl, #0x101
	push	hl
	ld	a, #0x07
	push	af
	inc	sp
	push	de
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
	jr	00106$
00102$:
;src/cards.c:118: set_bkg_tiles(x_pos+1, 7, 1, 1, (unsigned char*)" ");
	ld	hl, #___str_4
	push	hl
	ld	hl, #0x101
	push	hl
	ld	a, #0x07
	push	af
	inc	sp
	push	de
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
00106$:
;src/cards.c:110: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00105$
;src/cards.c:121: }
	inc	sp
	inc	sp
	ret
___str_3:
	.ascii "^"
	.db 0x00
___str_4:
	.ascii " "
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__rng_seed:
	.dw #0x3039
	.area _CABS (ABS)
