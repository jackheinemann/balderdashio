import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(String title, BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes')),
            ],
          ));
}
