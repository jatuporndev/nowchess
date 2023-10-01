import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nowchess/screen/Util/colors.dart';
import 'package:nowchess/screen/game/lobby_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/set_up_pieces.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final myController = TextEditingController();
  late final SharedPreferences prefs;
  String key = "playerName";
  String? name;
  SetUpPieces setUpPieces = SetUpPieces();

  Future<void> saveName(String name) async {
    await prefs.setString(key, name);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LobbyScreen()));
  }

  void checkName() async {
    String? data = prefs.getString(key);
    name = data;
    if (data != null) {
      if (data.isNotEmpty) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LobbyScreen()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeSharedPreferences() async {
    //await Future.delayed(const Duration(seconds: 1));
    prefs = await SharedPreferences.getInstance();
    checkName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource().main,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: FutureBuilder(
              future: initializeSharedPreferences(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(
                        setUpPieces.switchImage("knight-white"),
                        scale: 2,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Enter Your Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: ColorResource().text),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: myController..text = ((name != null) ? name : "")!,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.accessibility_new_sharp,color: Colors.black45),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: ColorResource().text),
                          ),
                          hintText: 'Enter Your Name',
                        ),
                        style: TextStyle(color: ColorResource().text),
                        cursorColor: ColorResource().text,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          print(myController.text);
                          saveName(myController.text);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: ColorResource().button,
                          ),
                          child: Text(
                            "Done!!!",
                            style: TextStyle(
                              color: ColorResource().text,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text("v1.0.0", style: TextStyle(
                        color: ColorResource().text,
                      ),)
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
