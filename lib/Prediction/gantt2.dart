import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Prediction/regression_triangle_chart.dart';
import 'package:insightme/Prediction/wvc.dart';

import 'core.dart';

Future<List<List<dynamic>>> _readPhoneGanttIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/gantt_chart.csv");
  final List<List<dynamic>> featureDataListList =
  const CsvToListConverter().convert(data);
  return featureDataListList;
}

class BiDirectionalGanttChart2 extends StatefulWidget {
  final scaleBounds;
  final context;
  final regressionTriangleIOData;

  BiDirectionalGanttChart2(
      this.scaleBounds, this.context, this.regressionTriangleIOData);

  @override
  BiDirectionalGanttChart2State createState() {
    return BiDirectionalGanttChart2State(
        this.scaleBounds, this.context, this.regressionTriangleIOData);
  }
}

class BiDirectionalGanttChart2State extends State<BiDirectionalGanttChart2> {
  final scaleBounds;
  final context;
  final regressionTriangleIOData;

  BiDirectionalGanttChart2State(
      this.scaleBounds, this.context, this.regressionTriangleIOData);

  List<bool> _expandedList = []; // which gantt
  @override
  Widget build(BuildContext context) {
    bool triangle = false; /// TRIANGLE
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

