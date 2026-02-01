;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.3.2 #14228 (Linux)
;--------------------------------------------------------
	.module jokers
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _apply_jokers
	.globl _get_joker_name
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
;src/jokers.c:3: static uint8_t all_same_suit(Card* hand) {
;	---------------------------------
; Function all_same_suit
; ---------------------------------
_all_same_suit:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/jokers.c:5: Suit first_suit = hand[0].suit;
	ld	a, (bc)
	ldhl	sp,	#0
;src/jokers.c:6: for (i = 1; i < HAND_SIZE; i++) {
	ld	(hl+), a
	ld	(hl), #0x01
00104$:
;src/jokers.c:7: if (hand[i].suit != first_suit) return 0;
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
;src/jokers.c:6: for (i = 1; i < HAND_SIZE; i++) {
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00104$
;src/jokers.c:9: return 1;
	ld	a, #0x01
00106$:
;src/jokers.c:10: }
	inc	sp
	inc	sp
	ret
;src/jokers.c:12: static uint8_t count_face_cards(Card* hand) {
;	---------------------------------
; Function count_face_cards
; ---------------------------------
_count_face_cards:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/jokers.c:15: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#0
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00104$:
;src/jokers.c:16: if (hand[i].rank >= RANK_JACK) count++;
	ldhl	sp,	#1
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	inc	hl
	ld	a, (hl)
	sub	a, #0x09
	jr	C, 00105$
	ldhl	sp,	#0
	inc	(hl)
00105$:
;src/jokers.c:15: for (i = 0; i < HAND_SIZE; i++) {
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00104$
;src/jokers.c:18: return count;
	dec	hl
	ld	a, (hl)
;src/jokers.c:19: }
	inc	sp
	inc	sp
	ret
;src/jokers.c:21: void apply_jokers(HandScore* score, Card* hand, Joker* jokers) {
;	---------------------------------
; Function apply_jokers
; ---------------------------------
_apply_jokers::
	add	sp, #-13
	ldhl	sp,	#10
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/jokers.c:24: for (i = 0; i < MAX_JOKERS; i++) {
	ldhl	sp,	#12
	ld	(hl), #0x00
00114$:
;src/jokers.c:25: if (!jokers[i].active) continue;
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	sla	c
	rl	b
	ldhl	sp,	#15
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
	ld	a, (hl+)
	ld	b, a
	inc	bc
	ld	a, (bc)
	ld	(hl), a
	or	a, a
	jp	Z, 00112$
;src/jokers.c:27: switch (jokers[i].type) {
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
;src/jokers.c:30: score->multiplier += 4;
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
;src/jokers.c:27: switch (jokers[i].type) {
	ld	a, c
	dec	a
	jr	Z, 00103$
;src/jokers.c:35: score->chips += 50;
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	push	hl
;src/jokers.c:27: switch (jokers[i].type) {
	ld	a,c
	cp	a,#0x02
	jr	Z, 00104$
	sub	a, #0x03
	jr	Z, 00105$
	ld	a,c
	cp	a,#0x04
	jr	Z, 00108$
	sub	a, #0x05
	jr	Z, 00109$
	jp	00112$
;src/jokers.c:28: case JOKER_MULTIPLIER:
00103$:
;src/jokers.c:30: score->multiplier += 4;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, #0x04
	ld	c, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
;src/jokers.c:31: break;
	jp	00112$
;src/jokers.c:33: case JOKER_CHIP_BONUS:
00104$:
;src/jokers.c:35: score->chips += 50;
	pop	de
	push	de
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0032
	add	hl, bc
	ld	c, l
	ld	b, h
	pop	hl
	push	hl
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/jokers.c:36: break;
	jp	00112$
;src/jokers.c:38: case JOKER_SUIT_BOOST:
00105$:
;src/jokers.c:40: if (all_same_suit(hand)) {
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_all_same_suit
	or	a, a
	jp	Z, 00112$
;src/jokers.c:41: score->multiplier *= 2;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, a
	ld	c, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
;src/jokers.c:43: break;
	jp	00112$
;src/jokers.c:45: case JOKER_LUCKY:
00108$:
;src/jokers.c:47: score->multiplier += 1 + (i % 3);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	ld	bc, #0x0003
	ld	e, (hl)
	ld	d, #0x00
	call	__modsint
	ldhl	sp,	#3
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	(hl-), a
	inc	a
	ld	(hl+), a
	inc	hl
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	inc	hl
	inc	hl
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (hl)
	ld	(de), a
;src/jokers.c:48: break;
	jr	00112$
;src/jokers.c:50: case JOKER_FACE_BONUS:
00109$:
;src/jokers.c:52: score->chips += count_face_cards(hand) * 10;
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_count_face_cards
	ldhl	sp,	#6
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	pop	de
	push	de
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/jokers.c:57: }
00112$:
;src/jokers.c:24: for (i = 0; i < MAX_JOKERS; i++) {
	ldhl	sp,	#12
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jp	C, 00114$
;src/jokers.c:59: }
	add	sp, #13
	pop	hl
	pop	af
	jp	(hl)
;src/jokers.c:61: const char* get_joker_name(JokerType type) {
;	---------------------------------
; Function get_joker_name
; ---------------------------------
_get_joker_name::
;src/jokers.c:62: switch (type) {
	cp	a, #0x01
	jr	Z, 00101$
	cp	a, #0x02
	jr	Z, 00102$
	cp	a, #0x03
	jr	Z, 00103$
	cp	a, #0x04
	jr	Z, 00104$
	sub	a, #0x05
	jr	Z, 00105$
	jr	00106$
;src/jokers.c:63: case JOKER_MULTIPLIER:  return "Mult +4";
00101$:
	ld	bc, #___str_0
	ret
;src/jokers.c:64: case JOKER_CHIP_BONUS:  return "Chips +50";
00102$:
	ld	bc, #___str_1
	ret
;src/jokers.c:65: case JOKER_SUIT_BOOST:  return "Flush x2";
00103$:
	ld	bc, #___str_2
	ret
;src/jokers.c:66: case JOKER_LUCKY:       return "Lucky";
00104$:
	ld	bc, #___str_3
	ret
;src/jokers.c:67: case JOKER_FACE_BONUS:  return "Face Bonus";
00105$:
	ld	bc, #___str_4
	ret
;src/jokers.c:68: default:                return "Unknown";
00106$:
	ld	bc, #___str_5
;src/jokers.c:69: }
;src/jokers.c:70: }
	ret
___str_0:
	.ascii "Mult +4"
	.db 0x00
___str_1:
	.ascii "Chips +50"
	.db 0x00
___str_2:
	.ascii "Flush x2"
	.db 0x00
___str_3:
	.ascii "Lucky"
	.db 0x00
___str_4:
	.ascii "Face Bonus"
	.db 0x00
___str_5:
	.ascii "Unknown"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
