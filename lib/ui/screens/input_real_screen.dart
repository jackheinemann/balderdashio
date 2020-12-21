import 'dart:html';

import 'package:balderdashio/business_logic/services/confirm_dialog.dart';
import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/input_answer_screen.dart';
import 'package:flutter/material.dart';

class InputRealScreen extends StatefulWidget {
  bool isModerator;

  // GAME PHASE 2
  InputRealScreen({@required this.isModerator});

  @override
  _InputRealScreenState createState() => _InputRealScreenState();
}

class _InputRealScreenState extends State<InputRealScreen> {
  bool isModerator;
  String name = window.localStorage['name'] + ', y' ?? 'Y'; //load this in

  List<String> categories = ['Definition', 'Person', 'Acronym', 'Movie', 'Law'];

  TextEditingController controller = new TextEditingController();

  String selectedCategory;

  Database database = new Database();

  @override
  void initState() {
    super.initState();
    isModerator = widget.isModerator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Balderdash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: !isModerator
              ? Center(
                  child: Text('Waiting for moderator',
                      style: TextStyle(fontSize: 18)))
              : Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('${name}ou are the Moderator',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    Text('Select a category'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: categories
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = e;
                                    });
                                  },
                                  child: Chip(
                                      backgroundColor:
                                          (e == selectedCategory ?? '')
                                              ? Colors.green
                                              : Colors.grey[100],
                                      label: Text(
                                        e,
                                        style: TextStyle(fontSize: 15),
                                      )),
                                ))
                            .toList(),
                        spacing: 5,
                        runSpacing: 5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Enter the prompt',
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
                          String category = selectedCategory;
                          String prompt = controller.text;

                          bool shouldSubmit = await showConfirmDialog(
                              'Submit prompt?', context);

                          if (!shouldSubmit) return;

                          database.submitPrompt(category, prompt);

                          database.updateGamePhase(3);
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
        ),
      ),
    );
  }
}
