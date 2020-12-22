import 'dart:html';

import 'package:balderdashio/business_logic/services/database.dart';
import 'package:balderdashio/ui/screens/lobby_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  bool isModerator;

  LoginScreen({this.isModerator = false});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = new TextEditingController();

  Database database = new Database();

  bool isModerator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isModerator = widget.isModerator;
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: RaisedButton(
                    onPressed: () async {
                      Storage storage = window.localStorage;

                      String name = nameController.text;
                      if (name == '') return;

                      // save to local storage and firestore
                      storage['name'] = name;
                      bool userAdded = await database.addUser(name);

                      if (!userAdded) {
                        AlertDialog dialog = AlertDialog(
                          title: Text('User already exists with this name'),
                          content: Text('Please enter a different name.'),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Ok'))
                          ],
                        );
                        showDialog(
                            context: context, builder: (context) => dialog);
                        return;
                      }
                      database.updateGamePhase(
                          1); // this will only do anything navigation wise for the very first person to join
                      // now check for mod status and regular navigate
                      if (!isModerator) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LobbyScreen(isModerator: isModerator)));
                      }
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
