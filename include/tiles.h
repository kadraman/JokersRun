#ifndef TILES_H
#define TILES_H

/* ASCII printable tiles start at 0 */
#define TILE_ASCII_BASE 0
#define TILE_ASCII_END  58  /* 32..127 -> 96 characters */

/* Card tiles start after ASCII */
#define TILE_FILL    59
#define TILE_BORDER  60
#define TILE_SPADE   61
#define TILE_HEART   62
#define TILE_DIAMOND 63
#define TILE_CLUB    64
#define TILE_JOKER   65
#define TILE_BACK    66

#endif