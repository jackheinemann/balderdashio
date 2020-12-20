import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:balderdashio/ui/screens/score_screen.dart';
import 'package:balderdashio/ui/util/answer_card.dart';
import 'package:balderdashio/ui/util/results_card.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool answersReady = true;
  bool isModerator = true;

  String selectedAnswer;

  String category = 'Movie';
  String prompt = 'The Terrible Trio of horrible no good very bad day';

  List<Answer> answers = [
    new Answer(
        text: 'A fun cowboy flick',
        creator: 'Jack',
        votes: ['Drew'],
        isReal: false),
    new Answer(
        text: 'A rowdy gang of brothers gets into trouble',
        creator: 'Drew',
        votes: ['Jack'],
        isReal: false),
    new Answer(
        text: 'Three dogs take new york city',
        creator: 'Real',
        votes: [],
        isReal: true)
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Balderdash'),
          ),
          body: !answersReady
              ? Center(
                  child: Text('Waiting for all answers',
                      style: TextStyle(fontSize: 18)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('The category is $category',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text(
                          '"$prompt"',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: answers.length,
                              itemBuilder: (context, i) {
                                Answer answer = answers[i];
                                return ResultsCard(answer: answer);
                              }),
                        ),
                        isModerator
                            ? RaisedButton(
                                onPressed: () {
                                  // confirm and move to scoring
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScoreScreen()));
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
                )),
    );
  }
}
