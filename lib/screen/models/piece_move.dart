class PieceMove {
  int row;
  int col;
  int selectedRow;
  int selectedCol;
  String pieceType;
  List<List<String>> board;

  PieceMove(
      {required this.row,
      required this.col,
      required this.selectedRow,
      required this.selectedCol,
      required this.board,
      required this.pieceType});
}
