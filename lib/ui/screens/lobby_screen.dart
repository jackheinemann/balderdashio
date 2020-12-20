import 'package:balderdashio/ui/screens/input_real_screen.dart';
import 'package:balderdashio/ui/util/user_card.dart';
import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  List<String> names = ['Jack', 'Glenn', 'Grace'];
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
                    Text('Players in lobby', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                          itemCount: names.length,
                          itemBuilder: (context, i) {
                            return UserCard(name: names[i]);
                          }),
                    )
                  ]
                  // + user cards or whatever
                  +
                  [
                    RaisedButton(
                        onPressed: () {
                          // maybe confirm and then start the game
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
                            'Start Game',
                            style: TextStyle(fontSize: 15),
                          )),
                        )),
                    SizedBox(
                      height: 30,
                    )
                  ]),
        ),
      ),
    );
  }
}
