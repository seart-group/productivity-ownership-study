
import java.util.Scanner;

public class main {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        tris game = new tris();
        char player = 'X';
        char winner = ' ';

        System.out.println("Benvenuti al gioco del Tris!");
        while (winner == ' ' && !game.isDraw()) {
            game.printBoard();
            System.out.print("Giocatore " + player + ", inserisci riga e colonna (0-2 separati da spazio): ");
            int row = scanner.nextInt();
            int col = scanner.nextInt();

            while (!game.makeMove(row, col, player)) {
                row = scanner.nextInt();
                col = scanner.nextInt();
            }

            winner = game.checkWinner();
            if (winner == ' ') {
                if (game.isDraw()) {
                    break;
                }
                player = (player == 'X') ? 'O' : 'X';
            }
        }
        game.printBoard();

        if (winner != ' ') {
            System.out.println("Il giocatore " + winner + " ha vinto!");
        } else {
            System.out.println("La partita è finita in pareggio!");
        }
        scanner.close();
    }
}
