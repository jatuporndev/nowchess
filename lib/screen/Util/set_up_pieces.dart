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

    // Kon
    chessPieces[0][2] = "kon-white";
    chessPieces[0][5] = "kon-white";
    chessPieces[7][5] = "kon-black";
    chessPieces[7][2] = "kon-black";

    // Mad
    chessPieces[0][4] = "mad-white";
    chessPieces[7][3] = "mad-black";
  }

  String switchImage(String name) {
    final pieceImageUrls = {
      "pawn-black": "asset/pieces/pawn-black.png",
      "pawn-white": "asset/pieces/pawn-white.png",
      "queen-black": "asset/pieces/queen-black.png",
      "queen-white": "asset/pieces/queen-white.png",
      "knight-white": "asset/pieces/knight-white.png",
      "knight-black": "asset/pieces/knight-black.png",
      "ship-white": "asset/pieces/ship-white.png",
      "ship-black": "asset/pieces/ship-black.png",
      "kon-white": "asset/pieces/kon-white.png",
      "kon-black": "asset/pieces/kon-black.png",
      "mad-white": "asset/pieces/mad-white.png",
      "mad-black": "asset/pieces/mad-black.png",
    };
    // Use the map to get the image URL based on the piece name
    return pieceImageUrls[name] ?? "";
  }
}
