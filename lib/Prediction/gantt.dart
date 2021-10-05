import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core.dart';

Future<List<List<dynamic>>> _readPhoneFeatureDataIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/gantt_chart.csv");
  final List<List<dynamic>> featureDataListList =
      const CsvToListConverter().convert(data);
  return featureDataListList;
}

Widget biDirectionalGanttChart(scaleBounds, context) {
  return FutureBuilder(
    future: _readPhoneFeatureDataIOFiles(context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        final List<List<dynamic>> featureEndStarts = snapshot.data;
        const double height = 16.0;

        List<Widget> _ganttChildren(featureEndStarts) {
          List<Widget> list = [];
          //i<5, pass your dynamic limit as per your requirment
          for (int i = 1; i < featureEndStarts.length; i++) {
            Color color = kindaRed; //const Color(0xFF855e78);
            if ((featureEndStarts[i][3]) == 'True') {
              color = kindaGreen; //const Color(0xFF9dbc95);
            }
            list.add(
              scaledBar(featureEndStarts[i][1], featureEndStarts[i][2],
                  scaleBounds, color, height, featureEndStarts[i][0], true),
            ); //add any Widget in place of Text("Index $i")
          }
          return list; // all widget added now retrun the list here
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
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          scaledBar(7 - 0.1, 7 + 0.1, [1, 9], Colors.black,
                              12.0, '', false),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          scaledBar(5, 9, [1, 9], Colors.black, 2.0, '', false),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          scaledBar(5, 5 + 0.05, [1, 9], Colors.black, 12.0, '',
                              false),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          scaledBar(9 - 0.05, 9, [1, 9], Colors.black, 12.0, '',
                              false),
                        ]),

                  ],
                ),
              ),
            ),
            Text(
                'Predicted mood with 95% prediction interval in black.\n'
                    'The green and red bars show positive and negative '
                    'contributions of the prediction.')],
        ),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    },
  );
}
