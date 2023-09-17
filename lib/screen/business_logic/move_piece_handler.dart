import '../models/piece_move.dart';

class MovePieceHandler {


  bool isValidPawnMove(PieceMove pm) {
    int direction = (pm.pieceType == "pawn-white") ? 1 : -1;
    int targetRow = pm.selectedRow + direction;
    String currentPieceType = pm.pieceType;

    bool isPawnAtStartingRow = (currentPieceType == "pawn-white" && pm.row == 5) ||
        (currentPieceType == "pawn-black" && pm.row == 2);

    if (isPawnAtStartingRow) {
      pm.pieceType = "pawn2-${currentPieceType.split('-').last}";
    }

    if (pm.row == targetRow && pm.col == pm.selectedCol && pm.board[targetRow][pm.selectedCol].isEmpty) {
      return true;
    }

    if (pm.row == targetRow && (pm.col == pm.selectedCol + 1 || pm.col == pm.selectedCol - 1)) {
      String targetPiece = pm.board[pm.row][pm.col];
      if (targetPiece.isNotEmpty && _isOppositeColor(currentPieceType, targetPiece)) {
        return true;
      }
    }
    return false;
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
      if (pm.row == newRow &&
          pm.col == newCol &&
          _checkTarget(pm)) {
        return true;
      }
    }
    return false;
  }

  bool isValidQueen(PieceMove pm) {
    List<List<int>> queenMoves = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0,- 1],
      [1, -1],
      [-1, 1],
      [1, 1],
      [-1, -1]
    ];
    for (var move in queenMoves) {
      int newRow = pm.selectedRow + move[0];
      int newCol = pm.selectedCol + move[1];
      if (pm.row == newRow &&
          pm.col == newCol &&
          _checkTarget(pm)) {
        return true;
      }
    }
    return false;
  }

  bool isValidShip(PieceMove pm) {
    if (pm.row == pm.selectedRow || pm.col == pm.selectedCol) {
      int rowIncrement = (pm.row > pm.selectedRow) ? 1 : (pm.row < pm.selectedRow) ? -1 : 0;
      int colIncrement = (pm.col > pm.selectedCol) ? 1 : (pm.col < pm.selectedCol) ? -1 : 0;

      int currentRow = pm.selectedRow + rowIncrement;
      int currentCol = pm.selectedCol + colIncrement;

      while (currentRow != pm.row || currentCol != pm.col) {
        if (pm.board[currentRow][currentCol].isNotEmpty) {
          return false;
        }
        currentRow += rowIncrement;
        currentCol += colIncrement;
      }

      return _checkTarget(pm);
    }

    return false;
  }

  bool isValidKhon(PieceMove pm) {
    int direction = (pm.pieceType == "khon-white") ? 1 : -1;
    int targetRow = pm.selectedRow + direction;
    if((targetRow == pm.row && (pm.selectedCol + 1 == pm.col || pm.selectedCol - 1 == pm.col || pm.selectedCol == pm.col))) {
      return _checkTarget(pm);
    } else {
      int direction = (pm.pieceType == "khon-white") ? -1 : 1;
      int targetRow = pm.selectedRow + direction;
      if((targetRow == pm.row && (pm.selectedCol + 1 == pm.col || pm.selectedCol - 1 == pm.col))) {
        return _checkTarget(pm);
      }
    }
    return false;
  }

  bool isValidMad(PieceMove pm) {
    int rowDiff = (pm.row - pm.selectedRow).abs();
    int colDiff = (pm.col - pm.selectedCol).abs();

    if (rowDiff == colDiff) {
      return _checkTarget(pm);
    }

    return false;
  }

  bool _checkTarget(PieceMove pm) {
    String targetPiece = pm.board[pm.row][pm.col];
    return (targetPiece.isEmpty || _isOppositeColor(pm.pieceType, targetPiece));
  }

  bool _isOppositeColor(String pieceType, String targetPiece) {
    String current = pieceType[pieceType.length -1];
    String target = targetPiece[targetPiece.length -1];
    return current != target;
  }
}
