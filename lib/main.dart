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

  //check moderator status
  List<String> moderatorOrder = List<String>.from(data['moderatorOrder']);
  int moderatorIndex = data['moderatorIndex'];
  if (moderatorOrder[moderatorIndex] == name) {
    isModerator = true;
    database.updateModStatus(name, true);
  } else
    isModerator = false;

  int gamePhase = data['gamePhase'];

  String category = data['activeCategory'];
  String prompt = data['activePrompt'];

  List<Widget> gamePhases = [
    LoginScreen(),
    LobbyScreen(isModerator: isModerator),
    InputRealScreen(isModerator: isModerator),
    InputAnswerScreen(isModerator: isModerator),
    VoteScreen(isModerator: isModerator, category: category, prompt: prompt),
    ResultsScreen()
  ];

  return gamePhases[gamePhase];
}
