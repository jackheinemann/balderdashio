import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/score_screen.dart';
import 'package:balderdashio/ui/util/answer_card.dart';
import 'package:balderdashio/ui/util/results_card.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  bool isModerator;

  ResultsScreen({@required this.isModerator});
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool answersReady = true;
  bool isModerator = true;

  String selectedAnswer;

  Database database = new Database();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isModerator = widget.isModerator;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Answer>>(
        future: database.getAnswers(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error),
            );
          if (snapshot.hasData) {
            List<Answer> answers = snapshot.data;
            answers.sort((a, b) => b.votes.length.compareTo(a.votes.length));
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text('Balderdash'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: answers.length,
                                itemBuilder: (context, i) {
                                  Answer answer = answers[i];
                                  return ResultsCard(answer: answer);
                                }),
                          ),
                          RaisedButton(
                              onPressed: () {
                                // confirm and move to scoring
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScoreScreen(
                                              isModerator: isModerator,
                                            )));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width * .6,
                                child: Center(
                                    child: Text(
                                  'View Scoreboard',
                                  style: TextStyle(fontSize: 15),
                                )),
                              )),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
