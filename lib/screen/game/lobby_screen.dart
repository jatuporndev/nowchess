import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nowchess/screen/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/set_up_pieces.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final myController = TextEditingController();
  late final SharedPreferences prefs;

  String key = "playerName";
  String name = "-";

  Future<void> saveLobby(String key) async {
    DatabaseReference refLobby = FirebaseDatabase.instance.ref("lobby/$key");

    SetUpPieces setUpPieces = SetUpPieces();
    List<List<String>> chessPieces =
        List.generate(8, (i) => List<String>.filled(8, ""));
    setUpPieces.setPiece(chessPieces);
    await refLobby.child("chessPieces").set(chessPieces).then((value) => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameScreen(
                        lobbyKey: key,
                        playerName: name,
                      )))
        });
  }

  void getName() {
    String? data = prefs.getString(key);
    setState(() {
      if (data != null) {
        name = data;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Hi, ${name} Enter Lobby Key",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () async =>
                    {print(myController.text), saveLobby(myController.text)},
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.indigo),
                  child: Text(
                    "Enter lobby",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      )),
    );
  }
}
