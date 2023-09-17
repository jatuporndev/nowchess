class SetUpPieces {
  void setPiece(chessPieces) {
    //pawn
    for (int i = 0; i < 8; i++) {
      chessPieces[2][i] = "pawn-white";
    }
    for (int i = 0; i < 8; i++) {
      chessPieces[5][i] = "pawn-black";
    }
    chessPieces[0][3] = "queen-white";
    chessPieces[7][4] = "queen-black";

    // Knight
    chessPieces[0][1] = "knight-white";
    chessPieces[0][6] = "knight-white";
    chessPieces[7][1] = "knight-black";
    chessPieces[7][6] = "knight-black";

    // Ship
    chessPieces[0][7] = "ship-white";
    chessPieces[0][0] = "ship-white";
    chessPieces[7][0] = "ship-black";
    chessPieces[7][7] = "ship-black";

    // Khon
    chessPieces[0][2] = "khon-white";
    chessPieces[0][5] = "khon-white";
    chessPieces[7][5] = "khon-black";
    chessPieces[7][2] = "khon-black";

    // Mad
    chessPieces[0][4] = "mad-white";
    chessPieces[7][3] = "mad-black";
  }

  String switchImage(String name) {
    return "asset/pieces/$name.png";
  }
}
