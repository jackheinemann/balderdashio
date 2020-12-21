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
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(answer.text,
                      softWrap: true,
                      style: answer.isReal
                          ? TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          : TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                ),
                Text(answer.isReal ? 'Real Answer' : answer.creator,
                    style: TextStyle(fontSize: 16)),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Votes',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${answer.votes.length}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: answer.votes.map((e) {
                      return Text(e, style: TextStyle(fontSize: 15));
                    }).toList()),
              ],
            )));
  }
}
