;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14228 (Linux)
;--------------------------------------------------------
	.module poker
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _evaluate_hand
	.globl _get_base_chips
	.globl _get_base_multiplier
	.globl _get_hand_name
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
;src/poker.c:5: static uint8_t count_rank(Card* hand, Rank rank) {
;	---------------------------------
; Function count_rank
; ---------------------------------
_count_rank:
	add	sp, #-9
	ldhl	sp,	#5
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
	ld	(hl), a
;src/poker.c:8: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#7
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00104$:
;src/poker.c:9: if (hand[i].rank == rank) count++;
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	pop	hl
	push	hl
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
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	ld	a, (bc)
	ld	c, a
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00105$
	ldhl	sp,	#7
	inc	(hl)
00105$:
;src/poker.c:8: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#8
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00104$
;src/poker.c:11: return count;
	dec	hl
	ld	a, (hl)
;src/poker.c:12: }
	add	sp, #9
	ret
;src/poker.c:14: static uint8_t is_flush(Card* hand) {
;	---------------------------------
; Function is_flush
; ---------------------------------
_is_flush:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/poker.c:16: Suit first_suit = hand[0].suit;
	ld	a, (bc)
	ldhl	sp,	#0
;src/poker.c:17: for (i = 1; i < HAND_SIZE; i++) {
	ld	(hl+), a
	ld	(hl), #0x01
00104$:
;src/poker.c:18: if (hand[i].suit != first_suit) return 0;
	ldhl	sp,	#1
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	e, (hl)
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, e
	jr	Z, 00105$
	xor	a, a
	jr	00106$
00105$:
;src/poker.c:17: for (i = 1; i < HAND_SIZE; i++) {
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00104$
;src/poker.c:20: return 1;
	ld	a, #0x01
00106$:
;src/poker.c:21: }
	inc	sp
	inc	sp
	ret
;src/poker.c:23: static uint8_t is_straight(Card* hand) {
;	---------------------------------
; Function is_straight
; ---------------------------------
_is_straight:
	add	sp, #-13
	ldhl	sp,	#9
	ld	a, e
	ld	(hl+), a
;src/poker.c:28: for (i = 0; i < HAND_SIZE; i++) {
	ld	a, d
	ld	(hl+), a
	inc	hl
	ld	(hl), #0x00
00113$:
;src/poker.c:29: ranks[i] = hand[i].rank;
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#12
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#12
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/poker.c:28: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#12
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00113$
;src/poker.c:33: for (i = 0; i < HAND_SIZE - 1; i++) {
	dec	hl
	ld	(hl), #0x00
;src/poker.c:34: for (j = 0; j < HAND_SIZE - i - 1; j++) {
00128$:
	ldhl	sp,	#12
	ld	(hl), #0x00
00116$:
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl+), a
	ld	de, #0x0004
	ld	(hl), d
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#12
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#7
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	ld	a, b
	ld	d, a
	bit	7, (hl)
	jr	Z, 00218$
	bit	7, d
	jr	NZ, 00219$
	cp	a, a
	jr	00219$
00218$:
	bit	7, d
	jr	Z, 00219$
	scf
00219$:
	jr	NC, 00119$
;src/poker.c:35: if (ranks[j] > ranks[j + 1]) {
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#12
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	inc	a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, #0
	add	hl, sp
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (hl-)
	sub	a, (hl)
	jr	NC, 00117$
;src/poker.c:36: temp = ranks[j];
;src/poker.c:37: ranks[j] = ranks[j + 1];
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	inc	hl
	push	af
	ld	a, (hl)
	ld	(de), a
	pop	af
;src/poker.c:38: ranks[j + 1] = temp;
	ld	(bc), a
00117$:
;src/poker.c:34: for (j = 0; j < HAND_SIZE - i - 1; j++) {
	ldhl	sp,	#12
	inc	(hl)
	jr	00116$
00119$:
;src/poker.c:33: for (i = 0; i < HAND_SIZE - 1; i++) {
	ldhl	sp,	#11
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00128$
;src/poker.c:44: for (i = 0; i < HAND_SIZE - 1; i++) {
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00120$:
;src/poker.c:45: if (ranks[i + 1] != ranks[i] + 1) {
	ldhl	sp,	#12
	ld	a, (hl)
	inc	a
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	hl, #0
	add	hl, sp
	add	hl, bc
	ld	c, (hl)
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#12
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ld	d, #0x00
	inc	de
	ld	b, #0x00
	ld	a, c
	sub	a, e
	jr	NZ, 00220$
	ld	a, b
	sub	a, d
	jr	Z, 00121$
00220$:
;src/poker.c:47: if (i == 3 && ranks[0] == RANK_2 && ranks[4] == RANK_ACE) {
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00107$
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl), a
	or	a, a
	jr	NZ, 00107$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jr	NZ, 00107$
;src/poker.c:48: return 1;
	ld	a, #0x01
	jr	00122$
00107$:
;src/poker.c:50: return 0;
	xor	a, a
	jr	00122$
00121$:
;src/poker.c:44: for (i = 0; i < HAND_SIZE - 1; i++) {
	ldhl	sp,	#12
	inc	(hl)
	ld	a, (hl-)
	ld	(hl+), a
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00120$
;src/poker.c:53: return 1;
	ld	a, #0x01
00122$:
;src/poker.c:54: }
	add	sp, #13
	ret
;src/poker.c:56: HandScore evaluate_hand(Card* hand) {
;	---------------------------------
; Function evaluate_hand
; ---------------------------------
_evaluate_hand::
	add	sp, #-25
	ldhl	sp,	#23
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;src/poker.c:63: for (i = 0; i < RANKS; i++) {
	ld	c, #0x00
00147$:
;src/poker.c:64: rank_counts[i] = 0;
	ld	e, c
	ld	d, #0x00
	ld	hl, #4
	add	hl, sp
	add	hl, de
	ld	(hl), #0x00
;src/poker.c:63: for (i = 0; i < RANKS; i++) {
	inc	c
	ld	a, c
	sub	a, #0x0d
	jr	C, 00147$
;src/poker.c:68: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#22
	ld	(hl), #0x00
00149$:
;src/poker.c:69: rank_counts[hand[i].rank]++;
	ldhl	sp,	#22
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#23
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
	ld	d, #0x00
	ld	hl, #4
	add	hl, sp
	add	hl, de
	inc	(hl)
;src/poker.c:68: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#22
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00149$
;src/poker.c:73: for (i = 0; i < RANKS; i++) {
	dec	hl
	dec	hl
	xor	a, a
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	ldhl	sp,	#19
	ld	(hl), #0x00
00151$:
;src/poker.c:74: if (rank_counts[i] == 2) pairs++;
	push	hl
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#19
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0x02
	jr	NZ, 00109$
	ldhl	sp,	#22
	inc	(hl)
	jr	00152$
00109$:
;src/poker.c:75: else if (rank_counts[i] == 3) threes++;
	cp	a, #0x03
	jr	NZ, 00106$
	ldhl	sp,	#21
	inc	(hl)
	jr	00152$
00106$:
;src/poker.c:76: else if (rank_counts[i] == 4) fours++;
	sub	a, #0x04
	jr	NZ, 00152$
	ldhl	sp,	#20
	inc	(hl)
00152$:
;src/poker.c:73: for (i = 0; i < RANKS; i++) {
	ldhl	sp,	#19
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0d
	jr	C, 00151$
;src/poker.c:80: uint8_t flush = is_flush(hand);
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#23
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_is_flush
	ldhl	sp,	#20
	ld	(hl), a
;src/poker.c:81: uint8_t straight = is_straight(hand);
	ldhl	sp,	#23
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_is_straight
	ldhl	sp,#21
	ld	(hl), a
	ld	a, (hl+)
;src/poker.c:83: if (straight && flush) {
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00144$
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00144$
;src/poker.c:85: uint8_t has_ten = 0, has_ace = 0;
	xor	a, a
	ld	(hl+), a
;src/poker.c:86: for (i = 0; i < HAND_SIZE; i++) {
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00153$:
;src/poker.c:87: if (hand[i].rank == RANK_10) has_ten = 1;
	ldhl	sp,	#22
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#23
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x08
	jr	NZ, 00113$
	ldhl	sp,	#20
	ld	(hl), #0x01
00113$:
;src/poker.c:88: if (hand[i].rank == RANK_ACE) has_ace = 1;
	sub	a, #0x0c
	jr	NZ, 00154$
	ldhl	sp,	#21
	ld	(hl), #0x01
00154$:
;src/poker.c:86: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#22
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00153$
;src/poker.c:90: if (has_ten && has_ace) {
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
;src/poker.c:91: score.type = HAND_ROYAL_FLUSH;
	ldhl	sp,	#0
	ld	(hl), #0x09
	jr	00145$
00118$:
;src/poker.c:93: score.type = HAND_STRAIGHT_FLUSH;
	ldhl	sp,	#0
	ld	(hl), #0x08
	jr	00145$
00144$:
;src/poker.c:95: } else if (fours) {
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	Z, 00141$
;src/poker.c:96: score.type = HAND_FOUR_KIND;
	ldhl	sp,	#0
	ld	(hl), #0x07
	jr	00145$
00141$:
;src/poker.c:97: } else if (threes && pairs) {
	ldhl	sp,	#18
	ld	a, (hl)
	or	a, a
	jr	Z, 00137$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00137$
;src/poker.c:98: score.type = HAND_FULL_HOUSE;
	ldhl	sp,	#0
	ld	(hl), #0x06
	jr	00145$
00137$:
;src/poker.c:99: } else if (flush) {
	ldhl	sp,	#20
	ld	a, (hl)
	or	a, a
	jr	Z, 00134$
;src/poker.c:100: score.type = HAND_FLUSH;
	ldhl	sp,	#0
	ld	(hl), #0x05
	jr	00145$
00134$:
;src/poker.c:101: } else if (straight) {
	ldhl	sp,	#22
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
;src/poker.c:102: score.type = HAND_STRAIGHT;
	ldhl	sp,	#0
	ld	(hl), #0x04
	jr	00145$
00131$:
;src/poker.c:103: } else if (threes) {
	ldhl	sp,	#18
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
;src/poker.c:104: score.type = HAND_THREE_KIND;
	ldhl	sp,	#0
	ld	(hl), #0x03
	jr	00145$
00128$:
;src/poker.c:105: } else if (pairs >= 2) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00125$
;src/poker.c:106: score.type = HAND_TWO_PAIR;
	ldhl	sp,	#0
	ld	(hl), #0x02
	jr	00145$
00125$:
;src/poker.c:107: } else if (pairs == 1) {
	ldhl	sp,	#19
	ld	a, (hl)
	dec	a
	jr	NZ, 00122$
;src/poker.c:108: score.type = HAND_PAIR;
	ldhl	sp,	#0
	ld	(hl), #0x01
	jr	00145$
00122$:
;src/poker.c:110: score.type = HAND_HIGH_CARD;
	ldhl	sp,	#0
	ld	(hl), #0x00
00145$:
;src/poker.c:113: score.chips = get_base_chips(score.type);
	ldhl	sp,	#0
	ld	a, (hl)
	call	_get_base_chips
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
;src/poker.c:114: score.multiplier = get_base_multiplier(score.type);
	ld	a, b
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	call	_get_base_multiplier
	ldhl	sp,	#3
	ld	(hl), a
;src/poker.c:116: return score;
	ldhl	sp,	#27
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/poker.c:117: }
	add	sp, #25
	pop	hl
	pop	af
	jp	(hl)
;src/poker.c:119: uint16_t get_base_chips(HandType type) {
;	---------------------------------
; Function get_base_chips
; ---------------------------------
_get_base_chips::
	ld	c, a
;src/poker.c:120: switch (type) {
	ld	a, #0x09
	sub	a, c
	jr	C, 00111$
	ld	b, #0x00
	ld	hl, #00122$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00122$:
	jp	00110$
	jp	00109$
	jp	00108$
	jp	00107$
	jp	00106$
	jp	00105$
	jp	00104$
	jp	00103$
	jp	00102$
	jp	00101$
;src/poker.c:121: case HAND_ROYAL_FLUSH:      return 100;
00101$:
	ld	bc, #0x0064
	ret
;src/poker.c:122: case HAND_STRAIGHT_FLUSH:   return 100;
00102$:
	ld	bc, #0x0064
	ret
;src/poker.c:123: case HAND_FOUR_KIND:        return 60;
00103$:
	ld	bc, #0x003c
	ret
;src/poker.c:124: case HAND_FULL_HOUSE:       return 40;
00104$:
	ld	bc, #0x0028
	ret
;src/poker.c:125: case HAND_FLUSH:            return 35;
00105$:
	ld	bc, #0x0023
	ret
;src/poker.c:126: case HAND_STRAIGHT:         return 30;
00106$:
	ld	bc, #0x001e
	ret
;src/poker.c:127: case HAND_THREE_KIND:       return 30;
00107$:
	ld	bc, #0x001e
	ret
;src/poker.c:128: case HAND_TWO_PAIR:         return 20;
00108$:
	ld	bc, #0x0014
	ret
;src/poker.c:129: case HAND_PAIR:             return 10;
00109$:
	ld	bc, #0x000a
	ret
;src/poker.c:130: case HAND_HIGH_CARD:        return 5;
00110$:
	ld	bc, #0x0005
	ret
;src/poker.c:131: default:                    return 0;
00111$:
	ld	bc, #0x0000
;src/poker.c:132: }
;src/poker.c:133: }
	ret
;src/poker.c:135: uint8_t get_base_multiplier(HandType type) {
;	---------------------------------
; Function get_base_multiplier
; ---------------------------------
_get_base_multiplier::
	ld	c, a
;src/poker.c:136: switch (type) {
	ld	a, #0x09
	sub	a, c
	jr	C, 00111$
	ld	b, #0x00
	ld	hl, #00122$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00122$:
	jp	00110$
	jp	00109$
	jp	00108$
	jp	00107$
	jp	00106$
	jp	00105$
	jp	00104$
	jp	00103$
	jp	00102$
	jp	00101$
;src/poker.c:137: case HAND_ROYAL_FLUSH:      return 8;
00101$:
	ld	a, #0x08
	ret
;src/poker.c:138: case HAND_STRAIGHT_FLUSH:   return 8;
00102$:
	ld	a, #0x08
	ret
;src/poker.c:139: case HAND_FOUR_KIND:        return 7;
00103$:
	ld	a, #0x07
	ret
;src/poker.c:140: case HAND_FULL_HOUSE:       return 4;
00104$:
	ld	a, #0x04
	ret
;src/poker.c:141: case HAND_FLUSH:            return 4;
00105$:
	ld	a, #0x04
	ret
;src/poker.c:142: case HAND_STRAIGHT:         return 4;
00106$:
	ld	a, #0x04
	ret
;src/poker.c:143: case HAND_THREE_KIND:       return 3;
00107$:
	ld	a, #0x03
	ret
;src/poker.c:144: case HAND_TWO_PAIR:         return 2;
00108$:
	ld	a, #0x02
	ret
;src/poker.c:145: case HAND_PAIR:             return 2;
00109$:
	ld	a, #0x02
	ret
;src/poker.c:146: case HAND_HIGH_CARD:        return 1;
00110$:
	ld	a, #0x01
	ret
;src/poker.c:147: default:                    return 1;
00111$:
	ld	a, #0x01
;src/poker.c:148: }
;src/poker.c:149: }
	ret
;src/poker.c:151: const char* get_hand_name(HandType type) {
;	---------------------------------
; Function get_hand_name
; ---------------------------------
_get_hand_name::
	ld	c, a
;src/poker.c:152: switch (type) {
	ld	a, #0x09
	sub	a, c
	jr	C, 00111$
	ld	b, #0x00
	ld	hl, #00122$
	add	hl, bc
	add	hl, bc
	add	hl, bc
	jp	(hl)
00122$:
	jp	00110$
	jp	00109$
	jp	00108$
	jp	00107$
	jp	00106$
	jp	00105$
	jp	00104$
	jp	00103$
	jp	00102$
	jp	00101$
;src/poker.c:153: case HAND_ROYAL_FLUSH:      return "Royal Flush";
00101$:
	ld	bc, #___str_0
	ret
;src/poker.c:154: case HAND_STRAIGHT_FLUSH:   return "Straight Flush";
00102$:
	ld	bc, #___str_1
	ret
;src/poker.c:155: case HAND_FOUR_KIND:        return "Four of a Kind";
00103$:
	ld	bc, #___str_2
	ret
;src/poker.c:156: case HAND_FULL_HOUSE:       return "Full House";
00104$:
	ld	bc, #___str_3
	ret
;src/poker.c:157: case HAND_FLUSH:            return "Flush";
00105$:
	ld	bc, #___str_4
	ret
;src/poker.c:158: case HAND_STRAIGHT:         return "Straight";
00106$:
	ld	bc, #___str_5
	ret
;src/poker.c:159: case HAND_THREE_KIND:       return "Three of a Kind";
00107$:
	ld	bc, #___str_6
	ret
;src/poker.c:160: case HAND_TWO_PAIR:         return "Two Pair";
00108$:
	ld	bc, #___str_7
	ret
;src/poker.c:161: case HAND_PAIR:             return "Pair";
00109$:
	ld	bc, #___str_8
	ret
;src/poker.c:162: case HAND_HIGH_CARD:        return "High Card";
00110$:
	ld	bc, #___str_9
	ret
;src/poker.c:163: default:                    return "Unknown";
00111$:
	ld	bc, #___str_10
;src/poker.c:164: }
;src/poker.c:165: }
	ret
___str_0:
	.ascii "Royal Flush"
	.db 0x00
___str_1:
	.ascii "Straight Flush"
	.db 0x00
___str_2:
	.ascii "Four of a Kind"
	.db 0x00
___str_3:
	.ascii "Full House"
	.db 0x00
___str_4:
	.ascii "Flush"
	.db 0x00
___str_5:
	.ascii "Straight"
	.db 0x00
___str_6:
	.ascii "Three of a Kind"
	.db 0x00
___str_7:
	.ascii "Two Pair"
	.db 0x00
___str_8:
	.ascii "Pair"
	.db 0x00
___str_9:
	.ascii "High Card"
	.db 0x00
___str_10:
	.ascii "Unknown"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
