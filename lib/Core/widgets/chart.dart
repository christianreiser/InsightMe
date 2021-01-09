import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/chart.dart';

Widget futureAnimatedLineChart(attributeName) {
  debugPrint('attributeName test works: $attributeName');
  // calls AnimatedLineChart(chart) in a future builder
  return FutureBuilder(
    future: oneAttributeChart(attributeName), //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      if (snapshot.connectionState == ConnectionState.done &&
          chart != null) {
        debugPrint('chart debugging??: $chart');

        debugPrint('snapshot.data??: ${snapshot.data}');

        return AnimatedLineChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          chart == null) {
        return Text('No data found for this label');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}