import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nowchess/screen/game/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Util/colors.dart';
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
      backgroundColor: ColorResource().main,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${name}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorResource().text
                    ),
                  ),
                  SizedBox(width: 8,),
                  GestureDetector(
                    onTap: () async =>
                    {},
                    child: Container(
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 6,top: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorResource().button),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: ColorResource().text, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 42,),
              Text(
                "Hi,  Enter Lobby Key",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32,color: ColorResource().text),
              ),
              SizedBox(
                height: 32,
              ),
              // TextField(
              //   controller: myController,
              //   decoration: InputDecoration(
              //     prefixIcon: Icon(Icons.meeting_room,color: Colors.black45),
              //     border: const OutlineInputBorder(),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           width: 2, color: ColorResource().text),
              //     ),
              //     hintText: 'Enter Your Name',
              //   ),
              //   style: TextStyle(color: ColorResource().text),
              //   cursorColor: ColorResource().text,
              // ),
              // SizedBox(
              //   height: 16,
              // ),
              // GestureDetector(
              //   onTap: () async =>
              //       {print(myController.text), saveLobby(myController.text)},
              //   child: Container(
              //     padding: EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(12),
              //         color: ColorResource().button),
              //     child: Text(
              //       "Enter lobby",
              //       style: TextStyle(
              //           color: ColorResource().text, fontWeight: FontWeight.w500),
              //     ),
              //   ),
              // ),
              Row(
                children: [
                 Flexible(child:
                 TextField(
                   controller: myController,
                   decoration: InputDecoration(
                     prefixIcon: Icon(Icons.meeting_room,color: Colors.black45),
                     border: const OutlineInputBorder(),
                     focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(
                           width: 2, color: ColorResource().text),
                     ),
                     hintText: 'Enter Your Name',
                   ),
                   style: TextStyle(color: ColorResource().text),
                   cursorColor: ColorResource().text,
                 )),
                  const SizedBox(width: 8,),
                  GestureDetector(
                    onTap: () async =>
                    {print(myController.text), saveLobby(myController.text)},
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorResource().button),
                      child: Text(
                        "Enter",
                        style: TextStyle(
                            color: ColorResource().text, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      )),
    );
  }
}
