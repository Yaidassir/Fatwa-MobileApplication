import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

   ButtonWidget({ required this.text, required this.onClicked,});

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        shape: StadiumBorder(),
        color: Colors.orange[300],
        padding: EdgeInsets.symmetric(horizontal:45, vertical: 20),
        textColor: Colors.white,
        onPressed: onClicked,
      );
      }