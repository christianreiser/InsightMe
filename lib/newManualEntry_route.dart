import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewManualEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New manual entry"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                children: <Widget>[

                  // Input text field for search or create attribute
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'search or create new attribute',
                    ),
                  ),

                  // spacing between boxes
                  SizedBox(height: 16),

                  // List of previously used attributes
                  Flexible(
                    child: ListView(
                      children: <Widget>[

                      FlatButton(
                      onPressed: () {},
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "second last used attribute"
                            ),
                          )
                      ),

                      FlatButton(
                        onPressed: () {},
                        child: Align(
                        alignment: Alignment.centerLeft,
                          child: Text(
                              "second last used attribute"
                          ),
                        )
                      ),
                      ],
                    ),
                  )
                ]
            )
        )
    );
  } // widget
} // class
