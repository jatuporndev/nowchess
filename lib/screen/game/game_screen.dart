import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nowchess/screen/Util/set_up_pieces.dart';

class GameScreen extends StatefulWidget {
  final String lobbyKey;

  const GameScreen({Key? key, required this.lobbyKey}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> board;
  late List<List<String>> oldBoard;
  int selectedRow = -1;
  int selectedCol = -1;
  late DatabaseReference refLobby;

  void initGame() {
    List<List<String>> chessPieces =
        List.generate(8, (i) => List<String>.filled(8, ""));
    setState(() {
      board = chessPieces;
    });
    FeatData();
  }

  void handleBoard(int row, int col) {
    print('[$row, $col]');
    oldBoard = List.from(board.map((row) => List<String>.from(row)));
    if (selectedRow == -1 && board[row][col].isNotEmpty) {
      setState(() {
        selectedRow = row;
        selectedCol = col;
      });
    } else if (selectedRow != -1 && (row != selectedRow || col != selectedCol)) {
      board[row][col] = board[selectedRow][selectedCol];
      board[selectedRow][selectedCol] = "";
      selectedRow = -1;
      selectedCol = -1;
      refLobby.set(board);
    } else if (row == selectedRow && col == selectedCol) {
      setState(() {
        selectedRow = -1;
        selectedCol = -1;
      });
    }

  }

  void undoMove() {
    print(oldBoard);
    refLobby.set(oldBoard);
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

  @override
  void initState() {
    super.initState();
    refLobby = FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}");
    initGame();
  }

  Future<void> FeatData() async {
    refLobby.onValue.listen((event) {
      late List<List<String>> snapBoard;
      var snapshot = event.snapshot;
      if (snapshot.value is List) {
        snapBoard = (snapshot.value as List).map((list) {
          if (list is List) {
            return list.map((item) => item.toString()).toList();
          } else {
            return <String>[];
          }
        }).toList();
      } else {
        snapBoard = [];
      }
      setState(() {
        board = snapBoard;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     "Now Chess",
            //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async => {print("undo"), undoMove()},
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.brown),
                        child: Icon(Icons.undo,color: Colors.white,)
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async => {print("undo"), undoMove()},
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.redAccent),
                        child: Icon(Icons.restart_alt,color: Colors.white,)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56,),
            SizedBox(height: 8,),
            Padding(padding: EdgeInsets.all(2),child: boardView()),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Container boardView() {
    return Container(// Add padding to control the spacing around the GridView
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown, width: 4.0), // Add a black border around the GridView
  //            borderRadius: BorderRadius.circular(8.0), // Optionally, add rounded corners
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              shrinkWrap: true,
              itemCount: 8 * 8,
              itemBuilder: (BuildContext ctx, index) {
                final row = 7 - (index ~/ 8);
                final col = (index % 8);
                final switchColor = (row + col) % 2 == 0
                    ? Colors.brown[400]
                    : Colors.brown[200];

                final isSelected = selectedRow == row && selectedCol == col;

                return GestureDetector(
                  onTap: () => {handleBoard(row, col)},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: switchColor,
                      border: isSelected
                          ? Border.all(color: Colors.green, width: 2.0) // Add border for selected cell
                          : null,
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        board[row][col].isNotEmpty
                            ? Image.asset(
                          switchImage(board[row][col]),
                          scale: 4,
                        )
                            : const SizedBox(),
                        const Spacer(),
                        // Text(
                        //   '[$row, $col]',
                        //   style: const TextStyle(fontSize: 12),
                        // ),
                        // Spacer(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
