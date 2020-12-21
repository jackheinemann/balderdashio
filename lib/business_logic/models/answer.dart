import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  String text;
  String creator;
  List<String> votes;
  bool isReal;

  Answer({this.text, this.creator, this.votes, this.isReal});

  Answer.fromDatabase(DocumentSnapshot answerSnap) {
    Map<String, dynamic> answerData = answerSnap.data();

    text = answerData['text'];
    creator = answerData['creator'];
    votes = List<String>.from(answerData['votes']);
    isReal = answerData[isReal];
  }
}
