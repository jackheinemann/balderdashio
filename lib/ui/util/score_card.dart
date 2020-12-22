import 'package:balderdashio/business_logic/models/player.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  Player player;

  ScoreCard({@required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(player.name),
        trailing: Text(
          '${player.score} ${player.score == 1 ? 'point' : 'points'}',
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
