import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/chart.dart';

Widget futureOneAttributeAnimatedLineChart(attributeName) {
  // calls AnimatedLineChart(chart) in a future builder
  return FutureBuilder(
    future: oneAttributeChart(attributeName), //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      if (snapshot.connectionState == ConnectionState.done &&
          chart != null && snapshot.data != null) {
        debugPrint('snapshot.data: ${snapshot.data}');
        return AnimatedLineChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          (chart == null || snapshot.data == null)) {
        return Text('No data found for this label');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}

Widget futureTwoAttributeAnimatedLineChart(attributeName1, attributeName2) {
  // calls AnimatedLineChart(chart) in a future builder
  return FutureBuilder(
    future: twoAttributeChart(attributeName1, attributeName2), //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      if (snapshot.connectionState == ConnectionState.done &&
          chart != null && snapshot.data != null) {
        return AnimatedLineChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          (chart == null || snapshot.data == null)) {
        return Text('No data found for this label');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}