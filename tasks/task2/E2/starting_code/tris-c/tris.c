#include <stdio.h>
#include "tris.h"

// Inizializza la griglia con spazi vuoti
void init_board(Tris *game) {
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            game->board[i][j] = ' ';
}

// Stampa la griglia
void print_board(const Tris *game) {
    printf("\n");
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf(" %c ", game->board[i][j]);
            if (j < SIZE - 1) printf("|");
        }
        printf("\n");
        if (i < SIZE - 1) printf("---+---+---\n");
    }
    printf("\n");
}

// Effettua una mossa
int make_move(Tris *game, int row, int col, char player) {
    if (row >= 0 && row < SIZE && col >= 0 && col < SIZE && game->board[row][col] == ' ') {
        game->board[row][col] = player;
        return 1;
    }
    return 0;
}

// Controlla se c'è un vincitore
char check_winner(const Tris *game) {
    for (int i = 0; i < SIZE; i++) {
        // Controllo righe e colonne
        if (game->board[i][0] != ' ' && game->board[i][0] == game->board[i][1] && game->board[i][1] == game->board[i][2])
            return game->board[i][0];

        if (game->board[0][i] != ' ' && game->board[0][i] == game->board[1][i] && game->board[1][i] == game->board[2][i])
            return game->board[0][i];
    }

    // Controllo diagonali
    if (game->board[0][0] != ' ' && game->board[0][0] == game->board[1][1] && game->board[1][1] == game->board[2][2])
        return game->board[0][0];

    if (game->board[0][2] != ' ' && game->board[0][2] == game->board[1][1] && game->board[1][1] == game->board[2][0])
        return game->board[0][2];

    return ' '; 
}

// Controlla se la partita è in pareggio
int is_draw(const Tris *game) {
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            if (game->board[i][j] == ' ')  // C'è almeno una cella vuota
                return 0;
    return 1; // Tutte le celle sono piene
}
