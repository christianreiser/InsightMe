import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';
import 'package:insightme/Core/widgets/design.dart';

class DataRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
        children: <Widget>[
          // Data
          oneAttributeNameAndChart('Happiness'),
          greyLineSeparator(),
          oneAttributeNameAndChart('Time asleep'),
          greyLineSeparator(),
          //oneAttributeNameAndChart('Body weight'),

          // WHITE SPACE DUE TO FAB
          SizedBox(height: 50),
        ],
      ),
    ); // type lineChart
  }

  Widget oneAttributeNameAndChart(attributeName) {
    // creates chart widget of one Attribute with name as heading
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // max chart width
          children: [
            Text(
              attributeName,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 25),
            SizedBox(
              height: 200,
              child: futureAnimatedLineChart(attributeName),
            )
          ]),
    );
  }
}
