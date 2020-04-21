import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewManualEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manual Entry"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);// Navigate back to Journal when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}