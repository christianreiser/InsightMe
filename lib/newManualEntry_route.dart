import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewManualEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // APP BAR
        appBar: AppBar(
          title: Text("New manual entry"),
        ),

        // FRAGMENT
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                children: <Widget>[

                  // Input text field for search or create attribute
                  // todo replace with
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'search or create new attribute',
                    ),
                    onChanged: (value) {
                      debugPrint('Something changed search or create new attribute');
/*
                       TODO:
                       search string in list of attributes
                       if found partially
                          if NOT matched exactly:
                              show found attributes in list below
                              display create new attribute button
                          else if: exact match:
                              hide create new attribute button

*/

                    },
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
