import 'package:balderdashio/business_logic/models/player.dart';
import 'package:balderdashio/business_logic/services/confirm_dialog.dart';
import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/input_real_screen.dart';
import 'package:balderdashio/ui/util/score_card.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  bool isModerator;

  ScoreScreen({@required this.isModerator});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  bool isModerator;

  Database database = new Database();

  @override
  void initState() {
    // TODO: implement initState
    isModerator = widget.isModerator;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
        future: database.getScores(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error),
            );
          if (snapshot.hasData) {
            List<Player> players = snapshot.data;
            players.sort((a, b) => b.score.compareTo(a.score));
            return Scaffold(
              appBar: AppBar(
                title: Text('Balderdash'),
                actions: [
                  isModerator
                      ? IconButton(
                          icon: Icon(Icons.dangerous),
                          onPressed: () async {
                            bool shouldDelete = await showConfirmDialog(
                                'Reset the entire game and end it?', context);
                            if (!shouldDelete) return;

                            database.endGame();
                          })
                      : Container()
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Current Scoreboard', style: TextStyle(fontSize: 18)),
                    Expanded(
                        child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, i) {
                        Player player = players[i];
                        return ScoreCard(player: player);
                      },
                    )),
                    isModerator
                        ? RaisedButton(
                            onPressed: () async {
                              // confirm and restart the round with a new moderator
                              bool endRound = await showConfirmDialog(
                                  'End the round?', context);
                              if (!endRound) return;

                              database.endRound();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width * .6,
                              child: Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(fontSize: 15),
                              )),
                            ))
                        : Container(),
                    SizedBox(
                      height: 20,
                    )
                  ],
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
