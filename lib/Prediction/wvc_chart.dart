import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core.dart';

Future<List<List<dynamic>>> _readPhoneWVCIOFiles(context) async {
  final String data = await DefaultAssetBundle.of(context)
      .loadString("assets/tmp_phone_io/wvc_chart.csv");
  final List<List<dynamic>> featureDataListList =
      const CsvToListConverter().convert(data);
  return featureDataListList;
}

Widget _showWVCExplanation(
    contributionColor, weightColor, valueTodayColor, context) {
  return TextButton(
    style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    /* info note for correlation coefficient */
    // to reduce height of correlation info button
    child: Icon(Icons.info, color: Colors.grey),
    onPressed: () {
      AlertDialog alertDialog = AlertDialog(
        title: Text('Explanation'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              Container(color: contributionColor, height: 16.0, width: 16.0),
              Text(' Contribution:'),
            ]),
            Text('Contribution = Weight · Measurement.\n'
                'Prediction = Sum(Contributions)\n    + Average Mood\n'
                'In the example below it has a medium positive effect.\n'),
            Row(children: [
              Container(color: weightColor, height: 16.0, width: 16.0),
              Text(' Weight:'),
            ]),
            Text(
                'Indicates how strong the effect is and if it\'s negative or positive.\n'
                'In the example below Humidity has a strong negative weight.\n'),
            Row(children: [
              Container(color: valueTodayColor, height: 16.0, width: 16.0),
              Text(' Today\'s measurement:'),
            ]),
            Text(
                'Indicates if today\'s humidity measurement is below or above average.\n'
                'In the example Humidity is a little below average.\n'),
            Text('Example Humidity:'),
            scaledBar(5, 6.7, [1, 9], contributionColor, 16.0, '', false),
            scaledBar(1.5, 5, [1, 9], weightColor, 16.0, '', false),
            scaledBar(4.5, 5, [1, 9], valueTodayColor, 16.0, '', false),
            Text('\nAbout the model:\n'
                'Multiple linear regression with lasso variable selection and regularization.'),
          ],
        ),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    },
  );
}

Widget wvcChart(context) {
  /// header: [0]featureName [1]contribution	[2]weight
  /// [3]value_today_not_normalized	[4]value_today_normalized
  /// [5]extrema[max,min]
  const Color contributionColor = const Color(0xFF946fc4);
  const Color weightColor = const Color(0xFF00b5b2); //Colors.teal;
  const Color valueTodayColor = const Color(0xFF5dddd7);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 8),
      Row(children: [
        Container(color: contributionColor, height: 16.0, width: 16.0),
        Text(' Contribution  '),
        Container(color: weightColor, height: 16.0, width: 16.0),
        Text(' Weight  '),
        Container(color: valueTodayColor, height: 16.0, width: 16.0),
        Text(' Today\'s measurement  '),
      ]),
      SizedBox(height: 6),
      FutureBuilder(
        future: _readPhoneWVCIOFiles(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<List<dynamic>> featureData = snapshot.data;
            const double height = 16.0;
            List<double> scaleBounds = [featureData[2][5], featureData[1][5]];

            List<Widget> _ganttChildren(featureData) {
              List<Widget> list = [];
              for (int i = 1; i < featureData.length; i++) {
                list.add(Text('${featureData[i][0]}:'));
                list.add(
                  scaledBar(0, featureData[i][1], scaleBounds,
                      contributionColor, height, '', false), //
                );
                list.add(
                  scaledBar(0, featureData[i][2], scaleBounds, weightColor,
                      height, '', false), //featureData[i][0]
                );
                list.add(
                  scaledBar(0, featureData[i][4], scaleBounds, valueTodayColor,
                      height, '', false), //featureData[i][0]
                );
                list.add(
                  SizedBox(
                    height: 10,
                  ),
                );
              }
              return list;
            }

            return Column(
              children: _ganttChildren(featureData),
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          } else {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      _showWVCExplanation(
          contributionColor, weightColor, valueTodayColor, context),
    ],
  );
}
