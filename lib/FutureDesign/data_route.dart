import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';
import 'package:insightme/Core/widgets/design.dart';

import '../navigation_helper.dart';


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
          oneAttributeNameAndChart('Happiness', context),
          greyLineSeparator(),
          oneAttributeNameAndChart('Time asleep', context),
          greyLineSeparator(),
          //oneAttributeNameAndChart('Body weight'),

          // WHITE SPACE DUE TO FAB
          SizedBox(height: 50),
        ],
      ),
    ); // type lineChart
  }

  Widget oneAttributeNameAndChart(attributeName, context) {
    // creates chart widget of one Attribute with name as heading
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // max chart width
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  attributeName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    NavigationHelper().navigateToScaffoldRoute(context); // refreshes
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: futureAnimatedLineChart(attributeName),
            )
          ]),
    );
  }
}
