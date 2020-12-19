import 'package:balderdashio/ui/screens/login_screen.dart';
import 'package:balderdashio/ui/util/answer_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balderdash',
      home: LoginScreen(),
    );
  }
}
