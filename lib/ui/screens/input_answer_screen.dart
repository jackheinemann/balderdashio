import 'package:flutter/material.dart';

class InputAnswerScreen extends StatefulWidget {
  @override
  _InputAnswerScreenState createState() => _InputAnswerScreenState();
}

class _InputAnswerScreenState extends State<InputAnswerScreen> {
  String category = 'Movie';
  String prompt = 'The Terrible Trio';

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          Text('The category is $category', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Flexible(
              child: Text(
            '"$prompt"',
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
              onPressed: () {
                // confirm and move to vote
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
}
