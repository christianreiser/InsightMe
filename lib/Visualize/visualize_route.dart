import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lifetracker4/Visualize/attribute_selection.dart';
import 'package:lifetracker4/Visualize/schedule.dart';
import 'package:provider/provider.dart';
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
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: ChangeNotifierProvider(
        create: (context) => MySchedule(), // builder -> create
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
            children: <Widget>[
              Row(
                // start: child as close to the start of the main axis as possible
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropDown(true), // true/false do discriminate first and second
                  //Padding(padding: EdgeInsets.all(4.0)),
                  DropDown(false),// true/false do discriminate first and second
                ],
              ),
              SizedBox(height: 20.0), // spacing between dropdown and chart
              Chart()
            ]),
      ), // type lineChart
    ); // type lineChart
  }
}
//}
