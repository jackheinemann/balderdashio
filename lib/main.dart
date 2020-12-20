import 'dart:html';

import 'package:balderdashio/ui/screens/input_answer_screen.dart';
import 'package:balderdashio/ui/screens/lobby_screen.dart';
import 'package:balderdashio/ui/screens/login_screen.dart';
import 'package:balderdashio/ui/screens/results_screen.dart';
import 'package:balderdashio/ui/screens/score_screen.dart';
import 'package:balderdashio/ui/screens/vote_screen.dart';
import 'package:balderdashio/ui/util/answer_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Balderdash', home: validateIncomingUser());
  }
}

Widget validateIncomingUser() {
  Storage storage = window.localStorage;

  // first check if there is a name saved locally
  String name = storage['name'];

  if (name == null) {
    // return loginScreen
    return LoginScreen();
  }

  // return lobby
  return ScoreScreen();
}
