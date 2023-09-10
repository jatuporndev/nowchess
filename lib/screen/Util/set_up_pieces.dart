class SetUpPieces {

  void setPiece(chessPieces) {

    //pawn
    for (int i = 0; i < 8; i++) {
      chessPieces[2][i] = "pawn-black";
    }
    for (int i = 0; i < 8; i++) {
      chessPieces[5][i] = "pawn-white";
    }

    //queen
    chessPieces[0][3] = "queen-black";
    chessPieces[7][4] = "queen-white";

    //knight
    chessPieces[0][1] = "knight-black";
    chessPieces[0][6] = "knight-black";
    chessPieces[7][1] = "knight-white";
    chessPieces[7][6] = "knight-white";

    //ship
    chessPieces[0][7] = "ship-black";
    chessPieces[0][0] = "ship-black";
    chessPieces[7][0] = "ship-white";
    chessPieces[7][7] = "ship-white";

    //kon
    chessPieces[0][2] = "kon-black";
    chessPieces[0][5] = "kon-black";
    chessPieces[7][5] = "kon-white";
    chessPieces[7][2] = "kon-white";

    //mad
    chessPieces[0][4] = "mad-black";
    chessPieces[7][3] = "mad-white";
  }

}
