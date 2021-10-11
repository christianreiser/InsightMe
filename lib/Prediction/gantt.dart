import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Prediction/visualization.dart';

import 'core.dart';

Future<List<List<dynamic>>> _readPhoneGanttIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/gantt_chart.csv");
  final List<List<dynamic>> featureDataListList =
      const CsvToListConverter().convert(data);
  return featureDataListList;
}

Widget biDirectionalGanttChart(scaleBounds, context, wVCIOData,showDetails) {
  print('\nshowDetails beginning of function: $showDetails');
  return FutureBuilder(
    future: _readPhoneGanttIOFiles(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        final List<List<dynamic>> featureEndStarts = snapshot.data;
        const double height = 16.0;

        List<Widget> _ganttChildren(featureEndStarts) {
          List<Widget> list = [];
          for (int i = 1; i < featureEndStarts.length; i++) {
            Color color = kindaRed;
            if ((featureEndStarts[i][3]) == 'True') {
              color = kindaGreen;
            }
            list.add(
              Column(children: [
                SizedBox(
                  height: height,
                  child: TextButton(
                    onPressed: () {
                      print('showDetails before:$showDetails');
                      if (showDetails < 0) {
                        showDetails = i - 1;
                      } else {
                        showDetails = -1;
                      }
                      print('showDetails after:$showDetails');
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
                i > 1
                    ? showDetails != i - 1
                        ? triangleScatterPlot(context, featureEndStarts[i][0],
                            wVCIOData[i - 1], scaleBounds)
                        : Container()
                    : Container(), // todo Average explanation
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

Widget showGanttExplanation(context) {
  return TextButton(
    style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    /* info note for correlation coefficient */
    // to reduce height of correlation info button
    child: Icon(Icons.info, color: Colors.grey),
    // onPressed: () {
    //   showAlertDialog(
    //       'Explanation',
    //       ';
    // },
    onPressed: () {
      AlertDialog alertDialog = AlertDialog(
        title: Text('Explanation'),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30.0,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      scaledBar(7 - 0.1, 7 + 0.1, [1, 9], Colors.black, 12.0,
                          '', false),
                      scaledBar(5, 9, [1, 9], Colors.black, 2.0, '', false),
                      scaledBar(
                          5, 5 + 0.05, [1, 9], Colors.black, 12.0, '', false),
                      scaledBar(
                          9 - 0.05, 9, [1, 9], Colors.black, 12.0, '', false),
                    ],
                  ),
                ),
              ),
              Text('Predicted mood with 95% prediction interval in black.\n'
                  'The green and red bars show positive and negative '
                  'contributions of the prediction.'),
            ]),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    },
  );
}
