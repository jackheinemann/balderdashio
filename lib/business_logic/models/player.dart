import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String name;
  int score;

  Player({this.name, this.score});

  Player.fromDatabase(DocumentSnapshot playerSnap) {
    name = playerSnap.data()['name'];
    score = playerSnap.data()['score'];
  }
}
