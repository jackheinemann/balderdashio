import 'dart:math';

import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:balderdashio/business_logic/models/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> addUser(String name) async {
    DocumentReference docRef =
        firestore.collection('balderdash_users').doc(name);

    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) return false;

    firestore
        .collection('balderdash_users')
        .doc(name)
        .set({'name': name, 'score': 0, 'isModerator': false}).catchError(
            (err) => print(err));
    //.add();
    firestore.collection('balderdash_logic').doc('gamestate').update({
      'moderatorOrder': FieldValue.arrayUnion([name])
    });
    return true;
  }

  void updateModStatus(String name, bool isModerator) {
    firestore
        .collection('balderdash_users')
        .doc(name)
        .update({'isModerator': isModerator});
  }

  Future<List<QuerySnapshot>> fetchPlayers() async {
    QuerySnapshot players =
        await firestore.collection('balderdash_users').get();
    QuerySnapshot logic = await firestore.collection('balderdash_logic').get();

    return [players, logic];
  }

  void startGame() {
    firestore
        .collection('balderdash_logic')
        .doc('gamestate')
        .update({'gameStarted': true, 'gamePhase': 2});
  }

  void submitPrompt(String category, String prompt) {
    firestore
        .collection('balderdash_logic')
        .doc('gamestate')
        .update({'activeCategory': category, 'activePrompt': prompt});
  }

  Future<List<String>> getPrompt() async {
    DocumentSnapshot snapshot =
        await firestore.collection('balderdash_logic').doc('gamestate').get();

    String category = snapshot.data()['activeCategory'];
    String prompt = snapshot.data()['activePrompt'];

    return [category, prompt];
  }

  void submitAnswer(Answer answer) {
    String text = answer.text;
    String creator = answer.creator;
    List<String> votes = answer.votes;
    bool isReal = answer.isReal;

    int randomSorter = Random().nextInt(100);

    firestore.collection('balderdash_answers').doc('$creator answer').set({
      'text': text,
      'creator': creator,
      'votes': votes,
      'isReal': isReal,
      'random': randomSorter
    });

    firestore
        .collection('balderdash_logic')
        .doc('gamestate')
        .update({'answersSubmitted': FieldValue.increment(1)});
  }

  Stream<DocumentSnapshot> gamestateStream() {
    return firestore
        .collection('balderdash_logic')
        .doc('gamestate')
        .snapshots();
  }

  void updateGamePhase(int gamePhase) {
    firestore
        .collection('balderdash_logic')
        .doc('gamestate')
        .update({'gamePhase': gamePhase});
  }

  Future<List<Answer>> getAnswers() async {
    QuerySnapshot answersSnap = await firestore
        .collection('balderdash_answers')
        .orderBy('random', descending: false)
        .get();

    List<Answer> answers = [];

    for (DocumentSnapshot doc in answersSnap.docs) {
      answers.add(Answer.fromDatabase(doc));
    }

    return answers;
  }

  void submitVote(Answer answer, String voter) {
    String creator = answer.creator;
    bool isReal = answer.isReal;

    String docID = '$creator answer';

    firestore.collection('balderdash_answers').doc(docID).update({
      'votes': FieldValue.arrayUnion([voter])
    });

    if (creator != voter) {
      // you are not voting for yourself
      if (isReal) {
        // the answer youre voting for is real
        firestore
            .collection('balderdash_users')
            .doc(voter)
            .update({'score': FieldValue.increment(2)}); // voter gets 2 points
      } else {
        // the answer youre voting for is fake
        firestore.collection('balderdash_users').doc(creator).update(
            {'score': FieldValue.increment(1)}); // the creator gets 1 point
      }
    }

    //no matter what, votesSubmitted increments
    firestore
        .collection('balderdash_logic')
        .doc('gamestate')
        .update({'votesSubmitted': FieldValue.increment(1)});
  }

  Future<List<Player>> getScores() async {
    QuerySnapshot snapshot =
        await firestore.collection('balderdash_users').get();

    List<Player> players = [];

    for (DocumentSnapshot doc in snapshot.docs) {
      players.add(Player.fromDatabase(doc));
    }

    return players;
  }

  Future<bool> endRound() async {
    DocumentReference gamestateRef =
        firestore.collection('balderdash_logic').doc('gamestate');

    // check if moderator index is at its max
    DocumentSnapshot snapshot = await gamestateRef.get();
    int modIndex = snapshot.data()['moderatorIndex'];
    List<String> modOrder =
        List<String>.from(snapshot.data()['moderatorOrder']);
    int playerCount = modOrder.length;

    if (modIndex == playerCount - 1)
      modIndex = 0;
    else
      modIndex += 1;

    // clear answersSubmitted
    // clear votesSubmitted
    // reset gamePhase
    // increment moderator index and/or reset it
    gamestateRef.update({
      'answersSubmitted': 0,
      'votesSubmitted': 0,
      'gamePhase': 2,
      'moderatorIndex': modIndex
    });

    for (String name in modOrder) {
      firestore
          .collection('balderdash_answers')
          .doc('$name answer')
          .update({'votes': []});
    }

    return true;
  }

  Future<bool> endGame() async {
    CollectionReference logicColl = firestore.collection('balderdash_logic');

    await logicColl.doc('gamestate').update({
      'gameStarted': false,
      'gamePhase': 0,
      'moderatorOrder': [],
      'moderatorIndex': 0,
      'answersSubmitted': 0,
      'votesSubmitted': 0,
    });

    return true;
  }
}
