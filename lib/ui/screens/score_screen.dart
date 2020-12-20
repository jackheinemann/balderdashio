import 'package:balderdashio/business_logic/models/player.dart';
import 'package:balderdashio/ui/screens/input_real_screen.dart';
import 'package:balderdashio/ui/util/score_card.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  List<Player> players = [
    new Player(name: 'Jack', score: 5),
    new Player(name: 'Grace', score: 10),
    new Player(name: 'Harry', score: 7)
  ];

  bool isModerator = true;

  @override
  void initState() {
    // TODO: implement initState
    players.sort((a, b) => b.score.compareTo(a.score));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Balderdash'),
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
                      onPressed: () {
                        // confirm and move to scoring
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputRealScreen()));
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
      ),
    );
  }
}
