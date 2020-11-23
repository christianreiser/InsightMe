import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as fluCa;
import 'package:insightme/Optimize/optimize.dart' as insightMeOptimize;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './change_notifier.dart';

class Statistics extends StatelessWidget {
  //  reset _correlationCoefficient
  num _correlationCoefficient; // = null;

  @override
  Widget build(BuildContext context) {
    return Consumer<VisualizationChangeNotifier>(
      builder: (context, schedule, _) => FutureBuilder(
        future: _getCorrelationCoefficient(
            schedule.selectedAttribute1, schedule.selectedAttribute2),
        builder: (context, snapshot) {
          // chart data arrived && data found
          debugPrint(
              'FutureBuilder: _correlationCoefficient: $_correlationCoefficient');
          if (snapshot.connectionState == ConnectionState.done &&
              _correlationCoefficient != null && _correlationCoefficient != 'NaN') {
            return insightMeOptimize.Optimize()
                .statistics(context, _correlationCoefficient, 0.02);
          }

          // chart data arrived but no data found
          else if (snapshot.connectionState == ConnectionState.done &&
              _correlationCoefficient == null) {
            return Text('Correlation Coefficient: -');

            // else: i.e. data didn't arrive
          } else {
            return CircularProgressIndicator(); // when Future doesn't get data
          } // snapshot is current state of future
        },
      ),
    );
  }

  Future<num> _getCorrelationCoefficient(attribute1, attribute2) async {
    /*
    * read csv and transform
    */
    // todo maybe in different file
    final directory = await getApplicationDocumentsDirectory();
    final input =
        new File(directory.path + "/correlation_matrix.csv").openRead();
    final correlationMatrix = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    debugPrint('got correlationMatrix $correlationMatrix');

    int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
    int attributeIndex2 =
        fluCa.transpose(correlationMatrix)[0].indexOf(attribute2);
    debugPrint(
        'correlationMatrix[attributeIndex1][attributeIndex2] ${correlationMatrix[attributeIndex1][attributeIndex2]}');
    debugPrint(
        'correlationMatrix[attributeIndex2][attributeIndex1] ${correlationMatrix[attributeIndex2][attributeIndex1]}');

    // min max is needed as correlation matrix is only half filled and row<column
    _correlationCoefficient =
        correlationMatrix[min(attributeIndex1, attributeIndex2)]
            [max(attributeIndex1, attributeIndex2)];
    debugPrint(
        '_getCorrelationCoefficient: _correlationCoefficient: $_correlationCoefficient');
    return _correlationCoefficient;
  }



}
