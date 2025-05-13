class Board {
  List<String?> tiles = List.filled(9, null); // 3x3 grid
  String currentPlayer = 'X';
  String? winner;

  void reset() {
    tiles = List.filled(9, null);
    currentPlayer = 'X';
    winner = null;
  }

  bool makeMove(int index) {
    if (tiles[index] != null || winner != null) return false;
    tiles[index] = currentPlayer;
    checkWinner();
    if (winner == null) currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    return true;
  }

  void checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (tiles[pattern[0]] != null && tiles[pattern[0]] == tiles[pattern[1]] && tiles[pattern[0]] == tiles[pattern[2]]) {
        winner = tiles[pattern[0]];
        break;
      }
    }

    if (winner == null && tiles.every((tile) => tile != null)) {
      winner = 'Draw';
    }
  }
}
