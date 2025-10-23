#include <stdio.h>
#include "tris.h"

int main() {
    Tris game;
    int row, col;
    char player = 'X';
    char winner = ' ';
    
    init_board(&game);

    printf("Benvenuti al gioco del Tris!\n");
    
    while (winner == ' ' && !is_draw(&game)) {
        print_board(&game);
        
        printf("Giocatore %c, inserisci riga e colonna (0-2 separati da spazio): ", player);
        scanf("%d %d", &row, &col);

        while (!make_move(&game, row, col, player)) {
            scanf("%d %d", &row, &col);
        }

        // Controlla vincitore o pareggio
        winner = check_winner(&game);
        if (winner == ' ') {
            if (is_draw(&game)) {
                break;
            }
            // Cambia giocatore
            player = (player == 'X') ? 'O' : 'X';
        }
    }

    print_board(&game);

    if (winner != ' ') {
        printf("Il giocatore %c ha vinto!\n", winner);
    } else {
        printf("La partita è finita in pareggio!\n");
    }

    return 0;
}
