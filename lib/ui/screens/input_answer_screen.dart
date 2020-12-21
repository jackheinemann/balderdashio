import 'dart:html';

import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:balderdashio/business_logic/services/confirm_dialog.dart';
import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/vote_screen.dart';
import 'package:flutter/material.dart';

class InputAnswerScreen extends StatefulWidget {
  bool isModerator;
  InputAnswerScreen({@required this.isModerator});
  @override
  _InputAnswerScreenState createState() => _InputAnswerScreenState();
}

class _InputAnswerScreenState extends State<InputAnswerScreen> {
  bool isModerator;

  Database database = new Database();

  TextEditingController controller = new TextEditingController();

  bool answerSubmitted = false;

  @override
  void initState() {
    super.initState();
    isModerator = widget.isModerator;
  }

  @override
  Widget build(BuildContext context) {
    if (answerSubmitted)
      return Scaffold(
        body: Center(
            child: Text('Waiting for all answers',
                style: TextStyle(fontSize: 18))),
      );

    return FutureBuilder<List<String>>(
        future: database.getPrompt(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(snapshot.error),
            );
          if (snapshot.connectionState == ConnectionState.done) {
            List<String> data = snapshot.data;

            String category = data[0];
            String prompt = data[1];
            return Scaffold(
              appBar: AppBar(
                leading: Container(),
                title: Text('Balderdash'),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text('The category is $category',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Flexible(
                      child: Text(
                    '"$prompt"',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    softWrap: true,
                  )),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your answer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      onPressed: () async {
                        String answerText = controller.text;
                        bool shouldSubmit =
                            await showConfirmDialog('Submit answer?', context);
                        if (!shouldSubmit || answerText == '') return;

                        Answer answer = new Answer(
                            text: answerText,
                            creator: window.localStorage['name'],
                            votes: [],
                            isReal: isModerator);

                        database.submitAnswer(answer);

                        setState(() {
                          answerSubmitted = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * .6,
                        child: Center(
                            child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 15),
                        )),
                      )),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
