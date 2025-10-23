#ifndef TRIS_H
#define TRIS_H

#define SIZE 3
typedef struct {
    char board[SIZE][SIZE];
} Tris;

// Funzioni per gestire il gioco
void init_board(Tris *game);
void print_board(const Tris *game);
int make_move(Tris *game, int row, int col, char player);
char check_winner(const Tris *game);
int is_draw(const Tris *game);

#endif
