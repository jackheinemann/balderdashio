import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/results_screen.dart';
import 'package:balderdashio/ui/util/answer_card.dart';
import 'package:flutter/material.dart';

class VoteScreen extends StatefulWidget {
  bool isModerator;
  String category;
  String prompt;

  VoteScreen({@required this.isModerator, this.category, this.prompt});

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  bool answersReady = true;
  bool isModerator;
  String category;
  String prompt;

  String selectedAnswer;

  Database database = new Database();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isModerator = widget.isModerator;
    category = widget.category;
    prompt = widget.prompt;
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
            return Scaffold(
                appBar: AppBar(
                  leading: Container(),
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
                                      return AnswerCard(
                                          answer: answer,
                                          onSelect: (e) {
                                            if (isModerator) return;
                                            setState(() {
                                              selectedAnswer = e.text;
                                            });
                                          },
                                          isSelected:
                                              (selectedAnswer == answer.text) ??
                                                  false,
                                          showName: isModerator);
                                    }),
                              ),
                              RaisedButton(
                                  onPressed: () {
                                    // confirm and move to scoring
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: Center(
                                        child: Text(
                                      isModerator ? 'See results' : 'Vote',
                                      style: TextStyle(fontSize: 15),
                                    )),
                                  )),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
