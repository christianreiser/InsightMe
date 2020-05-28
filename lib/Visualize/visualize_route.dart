import 'package:flutter/material.dart';
import 'package:lifetracker4/Visualize/attribute_selection.dart';
import 'chart.dart';

class Visualize extends StatefulWidget {
  Visualize({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VisualizeState createState() => _VisualizeState();
}

class _VisualizeState extends State<Visualize> {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DropDown('Mood'),
                //Padding(padding: EdgeInsets.all(4.0)),
                DropDown('Productivity'),
              ],
            ),
            Expanded(
              child: Chart()
              ),
          ]
      ), // type lineChart
    ); // type lineChart
  }
}
//}
