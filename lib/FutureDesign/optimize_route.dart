import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insightme/FutureDesign/Visualize/attribute_selection.dart';
import 'package:insightme/FutureDesign/Visualize/change_notifier.dart';
import 'package:insightme/FutureDesign/Visualize/chart.dart';
import 'package:insightme/Optimize/optimize.dart';
import 'package:provider/provider.dart';

import './../globals.dart' as globals;

class OptimizeRoute extends StatefulWidget {
  @override
  _OptimizeRouteState createState() => _OptimizeRouteState();
}

class _OptimizeRouteState extends State<OptimizeRoute> {
  @override
  Widget build(BuildContext context) {
    debugPrint('entryListLength ${globals.entryListLength}');
    if (globals.entryListLength == null || globals.entryListLength == 0) {
      // todo entryListLength == 0 needed?
      globals.Global().updateEntryList();
    }

    return globals.entryListLength == null
        ? _makeEntryHint()
        : globals.entryListLength > 0
            ? _attributeSelectionAndChart()
            : _makeEntryHint(); // type lineChart
  }


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

  static LineChart weightRHRChart = LineChart.fromDateTimeMaps(
      [dateTimeWeightMap, dateTimeRHRMap],
      [Colors.green, Colors.blue],
      ['Body weight', 'Resting heart rate'], // chart label name
      tapTextFontWeight: FontWeight.w400);

  static LineChart weightProductivityChart = LineChart.fromDateTimeMaps(
      [dateTimeWeightMap, dateTimeProductivityMap],
      [Colors.green, Colors.blue],
      ['Body weight', 'Resting heart rate'], // chart label name
      tapTextFontWeight: FontWeight.w400);

  static LineChart productivity = LineChart.fromDateTimeMaps(
      [dateTimeWeightMap, dateTimeProductivityMap],
      [Colors.green, Colors.blue],
      ['Body weight', 'Resting heart rate'], // chart label name
      tapTextFontWeight: FontWeight.w400);

  static LineChart chart = LineChart.fromDateTimeMaps(
      [dateTimeWeightMap, dateTimeProductivityMap],
      [Colors.green, Colors.blue],
      ['Body weight', 'Resting heart rate'], // chart label name
      tapTextFontWeight: FontWeight.w400);

  Widget _attributeSelectionAndChart() {
    return Container(
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: ChangeNotifierProvider(
        create: (context) => OptimizationChangeNotifier(), // builder -> create

        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 400,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // max chart width
                  children: <Widget>[
                    Text(
                      /// HEADING
                      'What do you want to optimize?',
                      style: TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w500),
                    ),
                    Row(

                        ///dropdown
                        // start: child as close to the start of the main axis as possible
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // true/false do discriminate first and second
                          DropDown(true),
                          SizedBox(width: 15),
                          DropDown(false),
                          // true/false do discriminate first and second
                        ]),
                    Text(
                      'Highest correlations:',
                      style: TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20), // needed above chart
                    /// visualize chart
                    Chart(),
                    /// statistics: correlation and confidence
                    Optimize().statistics(context, 0.92, 0.20),
                    SizedBox(height: 10),
                  ]),
            ),

            // SEPARATOR
            Container(
              color: Colors.grey,
              height: 1,
            ),

            // Attribute
            SizedBox(
              height: 400,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // max chart width
                  children: <Widget>[
                    SizedBox(height: 30),
                    Chart(),
                    Optimize().statistics(context, 0.62, 0.22),
                  ]),
            ),
          ]),
        ),
      ), // type lineChart
    );
  }

  Column _makeEntryHint() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.tealAccent,
              child: Row(
                children: [
                  Text(
                    'You have no entries to visualize.\n '
                    'To create new entries tab here ',
                    textScaleFactor: 1.2,
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
        SizedBox(
          height: 27, // height of button
        )
      ],
    );
  }
}
