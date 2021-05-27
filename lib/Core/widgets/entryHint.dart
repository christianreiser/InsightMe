import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Column entryHint() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.tealAccent,
            child: Row(
              children: [
                Text(
                  'You have no entries to visualize.\n '
                      'To create new entries tab here ',
                  textScaleFactor: 1.2,
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          )
        ],
      ),
      SizedBox(
        height: 27, // height of button
      )
    ],
  );
}