import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Column entryHint() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.tealAccent,
            child: Row(
              children: [
                Text(
                  'Create new entries ',
                  textScaleFactor: 1.2,
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          SizedBox(
            width: 75,
          )
        ],
      ),
      SizedBox(
        height: 27, // height of button
      )
    ],
  );
}
