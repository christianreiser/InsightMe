import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Core/widgets/chart.dart';
import 'package:insightme/Core/widgets/widgets.dart';

class DataRoute extends StatelessWidget {
  static Map<DateTime, double> dateTimeWeightMap = {
    DateTime(2019, 12, 01): 74.65,
    DateTime(2020, 01, 01): 74.6,
    DateTime(2020, 02, 02): 74.9,
    DateTime(2020, 03, 03): 74.8,
    DateTime(2020, 04, 04): 75.0,
    DateTime(2020, 05, 05): 75.2,
    DateTime(2020, 06, 06): 75.1,
    DateTime(2020, 07, 07): 75.2,
    DateTime(2020, 08, 08): 75.2,
    DateTime(2020, 09, 09): 75.3,
  };

  static Map<DateTime, double> dateTimeRHRMap = {
    DateTime(2020, 09, 01): 55,
    DateTime(2020, 09, 02): 54,
    DateTime(2020, 09, 03): 55,
    DateTime(2020, 09, 04): 57,
    DateTime(2020, 09, 05): 56,
    DateTime(2020, 09, 06): 55,
    DateTime(2020, 09, 07): 54,
    DateTime(2020, 09, 08): 54,
    DateTime(2020, 09, 09): 53,
    DateTime(2020, 09, 10): 53,
    DateTime(2020, 09, 11): 53,
    DateTime(2020, 09, 12): 54,
    DateTime(2020, 09, 13): 53,
    DateTime(2020, 09, 14): 52,
    DateTime(2020, 09, 15): 53,
  };

  static Map<DateTime, double> dateTimeProductivityMap = {
    DateTime(2020, 09, 01): 9,
    DateTime(2020, 09, 02): 8,
    DateTime(2020, 09, 03): 9,
    DateTime(2020, 09, 04): 0,
    DateTime(2020, 09, 05): 0,
    DateTime(2020, 09, 06): 8,
    DateTime(2020, 09, 07): 9,
    DateTime(2020, 09, 08): 7,
    DateTime(2020, 09, 09): 8,
    DateTime(2020, 09, 10): 7,
    DateTime(2020, 09, 11): 3,
    DateTime(2020, 09, 12): 1,
    DateTime(2020, 09, 13): 9,
    DateTime(2020, 09, 14): 9,
    DateTime(2020, 09, 15): 8,
  };

  static LineChart dateTimeWeightChart = LineChart.fromDateTimeMaps(
      [dateTimeWeightMap], [Colors.blue], [''], // chart label name
      tapTextFontWeight: FontWeight.w400);

  static LineChart dateTimeRHRChart = LineChart.fromDateTimeMaps(
      [dateTimeRHRMap], [Colors.blue], [''], // chart label name
      tapTextFontWeight: FontWeight.w400);

  static LineChart dateTimeProductivityChart = LineChart.fromDateTimeMaps(
      [dateTimeProductivityMap], [Colors.blue], [''], // chart label name
      tapTextFontWeight: FontWeight.w400);


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
          oneAttributeNameAndChart('Body weight'),

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
                child:futureAnimatedLineChart(attributeName),
            )
          ]),
    );
  }
}
