import 'dart:html';

import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/input_answer_screen.dart';
import 'package:balderdashio/ui/screens/input_real_screen.dart';
import 'package:balderdashio/ui/screens/lobby_screen.dart';
import 'package:balderdashio/ui/screens/login_screen.dart';
import 'package:balderdashio/ui/screens/results_screen.dart';
import 'package:balderdashio/ui/screens/score_screen.dart';
import 'package:balderdashio/ui/screens/vote_screen.dart';
import 'package:balderdashio/ui/util/answer_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Database database = new Database();
    return StreamBuilder<DocumentSnapshot>(
        stream: database.gamestateStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
                title: 'Balderdash',
                home: validateIncomingUser(snapshot, database));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

Widget validateIncomingUser(
    AsyncSnapshot<DocumentSnapshot> snapshot, Database database) {
  Storage storage = window.localStorage;

  // first check if there is a name saved locally
  String name = storage['name'];

  if (name == null) {
    // return loginScreen
    return LoginScreen();
  }

  bool isModerator;
  Map<String, dynamic> data = snapshot.data.data();

  bool gameStarted = data['gameStarted'];

  //check moderator status
  List<String> moderatorOrder = List<String>.from(data['moderatorOrder']);
  if (moderatorOrder.length < 1)
    return LoginScreen(); // this covers the first player who joins

  // after the first player joins, check for his/her moderatorIndex to set them as moderator
  int moderatorIndex = data['moderatorIndex'];
  if (moderatorOrder[moderatorIndex] == name) {
    isModerator = true;
    database.updateModStatus(name, true);
  } else
    isModerator = false;

  // filter out anyone who isnt a moderator but has a saved name and send them to the loginScreen
  if (!isModerator && !gameStarted) {
    // you are 1) not the moderator, 2) the game has not started, 3) you have a saved name locally
    Database database = new Database();
    database.addUser(name);
    return LobbyScreen(
      isModerator: isModerator,
    );
  }

  int gamePhase = data['gamePhase'];

  String category = data['activeCategory'];
  String prompt = data['activePrompt'];

  List<Widget> gamePhases = [
    LoginScreen(),
    LobbyScreen(isModerator: isModerator),
    InputRealScreen(isModerator: isModerator),
    InputAnswerScreen(isModerator: isModerator),
    VoteScreen(isModerator: isModerator, category: category, prompt: prompt),
    ResultsScreen(isModerator: isModerator),
    // ScoreScreen(
    //   isModerator: isModerator,
    // )
  ];

  return gamePhases[gamePhase];
}
