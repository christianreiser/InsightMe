import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewManualEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New manual entry"),
      ),
      body: new Card(
          child: TextField(
            //obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'search or create new attribute',
            ),
          )
      ),

    );
  }
}