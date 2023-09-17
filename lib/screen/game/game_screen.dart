import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nowchess/screen/Util/set_up_pieces.dart';
import 'package:nowchess/screen/business_logic/move_piece_handler.dart';
import 'package:nowchess/screen/models/piece_move.dart';

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
  late MovePieceHandler m;

  SetUpPieces setUpPieces = SetUpPieces();

  void initGame() {
    List<List<String>> chessPieces =
    List.generate(8, (i) => List<String>.filled(8, ""));
    setState(() {
      board = chessPieces;
    });
    m = MovePieceHandler();
    featData();
  }

  void handleBoard(int row, int col) {
    oldBoard = List.from(board.map((row) => List<String>.from(row)));
    if (selectedRow == -1 && board[row][col].isNotEmpty) {
      setState(() {
        selectedRow = row;
        selectedCol = col;
      });
    } else if (selectedRow != -1 &&
        (row != selectedRow || col != selectedCol)) {
      movePiece(row, col);
    } else if (row == selectedRow && col == selectedCol) {
      setState(() {
        selectedRow = -1;
        selectedCol = -1;
      });
    }
  }

  void undoMove() {
    refLobby.set(oldBoard);
  }

  void movePiece(int row, int col) {
    String selectedPiece = board[selectedRow][selectedCol];
    bool isValidMove = false;
    PieceMove pm = PieceMove(
      row: row,
      col: col,
      selectedRow: selectedRow,
      selectedCol: selectedCol,
      board: board,
      pieceType: selectedPiece,
    );

    switch (selectedPiece) {
      case "pawn-black":
      case "pawn-white": //เบี้ย
        isValidMove = m.isValidPawnMove(pm);
        break;
      case "knight-white":
      case "knight-black": //ม้า
        isValidMove = m.isValidKnightMove(pm);
        break;
      case "queen-white":
      case "queen-black": //ขุน
        isValidMove = m.isValidQueen(pm);
        break;
      case "ship-white":
      case "ship-black": //เรือ
        isValidMove = m.isValidShip(pm);
        break;
      case "khon-white":
      case "khon-black": //โคน
        isValidMove = m.isValidKhon(pm);
        break;
      case "mad-white":
      case "mad-black": //เม็ด
      case "pawn2-white": //เบี้ยเข้า
      case "pawn2-black":
        isValidMove = m.isValidMad(pm);
        break;
    }

    if (isValidMove) {
      board[row][col] = pm.pieceType;
      board[selectedRow][selectedCol] = "";
      selectedRow = -1;
      selectedCol = -1;
      refLobby.set(board);
    }
  }
  @override
  void initState() {
    super.initState();
    refLobby = FirebaseDatabase.instance.ref("lobby/${widget.lobbyKey}");
    initGame();
  }

  Future<void> featData() async {
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
                    onTap: () async => {undoMove()},
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.brown),
                        child: const Icon(
                          Icons.undo,
                          color: Colors.white,
                        )),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async => {undoMove()},
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.redAccent),
                        child: const Icon(
                          Icons.restart_alt,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(padding: const EdgeInsets.all(2), child: boardView()),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Container boardView() {
    return Container(
      // Add padding to control the spacing around the GridView
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.brown,
            width: 4.0), // Add a black border around the GridView
        //            borderRadius: BorderRadius.circular(8.0), // Optionally, add rounded corners
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        shrinkWrap: true,
        itemCount: 8 * 8,
        itemBuilder: (BuildContext ctx, index) {
          final row = 7 - (index ~/ 8);
          final col = (index % 8);
          final switchColor =
          (row + col) % 2 == 0 ? Colors.brown[400] : Colors.brown[200];

          final isSelected = selectedRow == row && selectedCol == col;

          return GestureDetector(
            onTap: () => {handleBoard(row, col)},
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: switchColor,
                border: isSelected
                    ? Border.all(
                    color: Colors.green,
                    width: 2.0) // Add border for selected cell
                    : null,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  board[row][col].isNotEmpty
                      ? Image.asset(
                    setUpPieces.switchImage(board[row][col]),
                    scale: 4,
                  )
                      : const SizedBox(),
                  const Spacer(),
                  Text(
                    '[$row, $col]',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
