import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Prediction/regression_triangle_chart.dart';
import 'package:insightme/Prediction/wvc.dart';

import 'color_scale.dart';
import 'core.dart';

Future<List<List<dynamic>>> _readPhoneGanttIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/gantt_chart.csv");
  final List<List<dynamic>> featureDataListList =
      const CsvToListConverter().convert(data);
  return featureDataListList;
}

class BiDirectionalGanttChart extends StatefulWidget {
  final scaleBounds;
  final context;
  final regressionTriangleIOData;

  BiDirectionalGanttChart(
      this.scaleBounds, this.context, this.regressionTriangleIOData);

  @override
  BiDirectionalGanttChartState createState() {
    return BiDirectionalGanttChartState(
        this.scaleBounds, this.context, this.regressionTriangleIOData);
  }
}

class BiDirectionalGanttChartState extends State<BiDirectionalGanttChart> {
  final scaleBounds;
  final context;
  final regressionTriangleIOData;

  BiDirectionalGanttChartState(
      this.scaleBounds, this.context, this.regressionTriangleIOData);

  List<bool> _expandedList = []; // which gantt
  @override
  Widget build(BuildContext context) {
    bool triangle = true; /// TRIANGLE
    return FutureBuilder(
      future: _readPhoneGanttIOFiles(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<List<dynamic>> featureEndStarts = snapshot.data;
          const double height = 22.0;

          List<Widget> _ganttChildren(featureEndStarts) {
            List<Widget> list = [];
            for (int i = 1; i < featureEndStarts.length; i++) {
              Color color = kindaRed;
              if ((featureEndStarts[i][3]) == 'True') {
                color = kindaGreen;
              }

              /// gantt list
              list.add(
                Column(children: [
                  /// one gantt
                  SizedBox(
                    height: height,
                    child: TextButton(
                      onPressed: () {
                        if (_expandedList.isEmpty ||
                            _expandedList.isNotEmpty && !_expandedList[i - 1]) {
                          _expandedList =
                              List.filled(featureEndStarts.length, false);
                          _expandedList[i - 1] = true;
                        } else if (_expandedList.isNotEmpty &&
                            _expandedList[i - 1]) {
                          _expandedList =
                              List.filled(featureEndStarts.length, false);
                        }
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: scaledBar(
                          featureEndStarts[i][1],
                          featureEndStarts[i][2],
                          scaleBounds,
                          color,
                          height,
                          featureEndStarts[i][0],
                          true),
                    ),
                  ),

                  /// decide if show details
                  _expandedList.isNotEmpty // check if enough attributes
                      ? _expandedList[i - 1] == true // if selected
                           ?i > 1 // check if not TargetAverage()
                              ? triangle == true // triangle vs wvc
                                  ? triangleScatterPlot(
                                      // triangle
                                      context,
                                      featureEndStarts[i][0],
                                      regressionTriangleIOData[i - 1],
                                      scaleBounds)
                                  : wcv(context, i-1) // wvc
                              : Text(
                                  '\n${featureEndStarts[1][2].toStringAsFixed(1)} is your average mood over all time.\n'
                                  'It is the starting point of your mood prediction.\n') // TargetAverage()
                          : Container() // not selected
                      : Container(), // empty
                ]),
              );
            }
            return list;
          }

          return Column(
            children: _ganttChildren(featureEndStarts),
          );
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Widget showGanttExplanation(context) {
  return TextButton(
    style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    /* info note for correlation coefficient */
    // to reduce height of correlation info button
    child: Icon(Icons.info, color: Colors.grey),
    onPressed: () {
      AlertDialog alertDialog = AlertDialog(
        title: Text('Example'),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Prediction', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Container(
                height: 30.0,
                decoration: predictionBoxDecoration(),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      scaledBar(7 - 0.1, 7 + 0.1, [1, 9], Colors.black, 12.0,
                          '', false),
                      scaledBar(6, 8, [1, 9], Colors.black, 2.0, '', false),
                      scaledBar(
                          6, 6 + 0.05, [1, 9], Colors.black, 12.0, '', false),
                      scaledBar(
                          8 - 0.05, 8, [1, 9], Colors.black, 12.0, '', false),
                    ],
                  ),
                ),
              ),
              numericScale([1, 9]),
              Text('Predicted mood of 7 on a scale from 1 to 9.\n'
                  '95% prediction interval from 6 to 8.\n\n'),
              Text('Contributions',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6.0),
              scaledBar(5, 7, [1, 9], kindaGreen, 16.0, 'Steps', true),
              scaledBar(7, 6, [1, 9], kindaRed, 16.0, 'CO2 level', true),
              Text(
                  'The green bar shows a large positive contribution of \'Steps\' on today\'s mood prediction.\n'
                  'The red bar shows a smaller negative contribution of \'CO2 level\'.\n\n'
                      'For more information close this window and press one of the Contributions'),
              Text('\nAbout the model:\n'
                  'Multiple linear regression with lasso variable selection and regularization.'),
            ]),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),          ),
        ],
      );
      showDialog(context: context, builder: (_) => alertDialog);
    },
  );
}
