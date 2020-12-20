import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:flutter/material.dart';

class ResultsCard extends StatelessWidget {
  final Answer answer;

  const ResultsCard({@required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            color: answer.isReal ? Colors.blue[200] : Colors.white,
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    answer.text,
                  ),
                  trailing: !answer.isReal
                      ? Text(
                          answer.creator,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Votes',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text('${answer.votes.length}')
                  ],
                ),
                Column(
                  children: answer.votes.map((e) => Text('- $e')).toList(),
                )
              ],
            )));
  }
}
