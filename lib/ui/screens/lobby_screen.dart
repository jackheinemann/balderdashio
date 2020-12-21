import 'dart:html';

import 'package:balderdashio/business_logic/services/confirm_dialog.dart';
import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/input_real_screen.dart';
import 'package:balderdashio/ui/util/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  bool isModerator;

  LobbyScreen({@required this.isModerator});
  // GAME PHASE 1
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  Database database = new Database();
  bool isModerator;

  String name = window.localStorage['name'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isModerator = widget.isModerator;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: database.gamestateStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();

            // get list of names, which is essentially just moderator order list
            List<String> names = List<String>.from(data['moderatorOrder']);

            return Scaffold(
              appBar: AppBar(
                title: Text('Balderdash'),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Players in lobby',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                              itemCount: names.length,
                              itemBuilder: (context, i) {
                                return UserCard(name: names[i]);
                              }),
                        ),
                        (isModerator)
                            ? RaisedButton(
                                onPressed: () async {
                                  // maybe confirm and then start the game
                                  bool startGame = await showConfirmDialog(
                                      'Start the game?', context);
                                  if (!startGame) return;
                                  database
                                      .startGame(); //updates gamePhase, which navigates essentially
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Center(
                                      child: Text(
                                    'Start Game',
                                    style: TextStyle(fontSize: 15),
                                  )),
                                ))
                            : Container(),
                        SizedBox(
                          height: 30,
                        )
                      ]),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
