import 'package:flutter/material.dart';
import 'package:nowchess/screen/game/lobby_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final myController = TextEditingController();
  late final SharedPreferences prefs;
  String key = "playerName";

  Future<void> saveName(String name) async {
    await prefs.setString(key, name).then((value) => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LobbyScreen()))
        });
  }

  void checkName() async {
    String? data = prefs.getString(key);
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
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    checkName();
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
                "Enter Your Name",
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
                    {print(myController.text), saveName(myController.text)},
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
