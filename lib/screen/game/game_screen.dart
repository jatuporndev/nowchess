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

  void initGame() {
    SetUpPieces setUpPieces = SetUpPieces();
    List<List<String>> chessPieces =
        List.generate(8, (i) => List<String>.filled(8, ""));

    setUpPieces.setPiece(chessPieces);
    setState(() {
      board = chessPieces;
    });
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
    initGame();
  }

  Future<void> test() async {
    DatabaseReference refLobby = FirebaseDatabase.instance.ref("lobba/s");
    refLobby.onValue.listen((event) {
      var snapshot = event.snapshot;
      print(snapshot.value);
      setState(() {
        if (snapshot.value is List) {
          // Assuming snapshot.value is a List of Lists of Strings or null
          board = (snapshot.value as List).map((list) {
            if (list is List) {
              return list.map((item) => item.toString()).toList();
            } else {
              return <String>[];
            }
          }).toList();
        } else {
           board = [];
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                "Now Chess",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            GridView.builder(
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

                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: switchColor,
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
                        Spacer(),
                        GestureDetector(
                          onTap: () => {test()},
                          child: Text(
                            '[$row, $col]',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                }),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
