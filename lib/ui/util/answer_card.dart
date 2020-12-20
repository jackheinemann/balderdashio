import 'package:balderdashio/business_logic/models/answer.dart';
import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  final bool isSelected;
  final Function(Answer) onSelect;
  final bool showName;

  final Answer answer;

  const AnswerCard(
      {@required this.onSelect,
      @required this.answer,
      this.isSelected,
      this.showName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: ListTile(
          tileColor: isSelected ?? false ? Colors.green[200] : Colors.white,
          onTap: () {
            this.onSelect(answer);
          },
          title: Text(
            answer.text,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: showName ? Text(answer.creator) : null,
        ),
      ),
    );
  }
}
