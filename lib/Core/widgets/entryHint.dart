import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Column entryHint() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        textDirection: TextDirection.ltr,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.tealAccent,
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Text('Create new entries ',
                    textScaleFactor: 1.2, textDirection: TextDirection.ltr),
                Icon(Icons.arrow_forward, textDirection: TextDirection.ltr),
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