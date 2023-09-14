import '../models/piece_move.dart';

class MovePieceHandler {
  bool isValidPawnMove(PieceMove pm) {
    int direction = (pm.pieceType == "pawn-white") ? 1 : -1;
    return pm.row == pm.selectedRow + direction &&
        pm.col == pm.selectedCol &&
        pm.board[pm.row][pm.col].isEmpty;
  }

  bool isValidKnightMove(PieceMove pm) {
    List<List<int>> knightMoves = [
      [-1, -2],
      [-2, -1],
      [-2, 1],
      [-1, 2],
      [1, -2],
      [2, -1],
      [2, 1],
      [1, 2],
    ];

    for (var move in knightMoves) {
      int newRow = pm.selectedRow + move[0];
      int newCol = pm.selectedCol + move[1];
      if (pm.row == newRow && pm.col == newCol && pm.board[pm.row][pm.col].isEmpty) {
        return true;
      }
    }

    return false;
  }
}
