import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/Covid19/stayHealthy.dart';


class Recommend extends StatelessWidget {
  static Map<DateTime, double> dateTimeMap1 = {
    DateTime(1): 1,
    DateTime(2): 3,
    DateTime(3): 3,
    DateTime(4): 4,
    DateTime(5): 3
  };
  static Map<DateTime, double> dateTimeMap2 = {
    DateTime(1): 2,
    DateTime(2): 5,
    DateTime(3): 4,
    DateTime(4): 6,
    DateTime(5): 3
  };

  static LineChart chart = LineChart.fromDateTimeMaps(
      [dateTimeMap1, dateTimeMap2],
      [Colors.green, Colors.blue],
      ['time with friends', 'mood'], // chart label name
      tapTextFontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
          children: <Widget>[
            // TITLE
            Text(
              ' Recommendation',
              style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            Text('You have a better day when you spend more time with friends'),
            SizedBox(height: 15),
            Expanded(
              child: AnimatedLineChart(chart),
            ),

            SizedBox(height: 15),
            Text('Correlation coefficient: 0.8.\nP-value: 0.04'),


            // SPACING AND GREY LINE
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [],
                ),
              ),
            ), // spacing between dropdown and chart

            //Correlation(),
          ]),
    ); // type lineChart
  }


}
//}
