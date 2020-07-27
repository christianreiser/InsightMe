import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starfruit/starfruit.dart';
import 'dart:io';
import 'dart:convert' show utf8;
import 'package:flutter_charts/flutter_charts.dart';

class ComputeCorrelations {
  computeCorrelations() async {
/*
* reads daily summaries CSV,
* computes correlations
* writes correlations matrix as csv
* */
    // get numDays
    final prefs = await SharedPreferences.getInstance();
    int numDays = prefs.getInt('numDays') ?? null;

    /*
  * read csv and transform
  * */
    final directory = await getApplicationDocumentsDirectory();
    final input = new File(directory.path + "/daily_summaries.csv").openRead();
    final rowForEachDay = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    /* separate labels from values*/
    final List<dynamic> labels =
        rowForEachDay.removeAt(0); // separate labels from values
    labels.removeAt(0); // remove date-label
//  debugPrint('labels $labels');
//  debugPrint('rowForEachDay $rowForEachDay');

    /* remove dates from values*/
    var rowForEachAttribute = List<List<dynamic>>.from(
        transpose(rowForEachDay)); // make list variable length
    rowForEachAttribute.removeAt(0); // remove dates
//  List<List<num>> rowForEachAttributeNum = rowForEachAttribute.cast<List<num>>();
    //debugPrint('rowForEachAttribute $rowForEachAttribute');

    /*
  * correlation
  * */
    debugPrint('numDays $numDays');
    int numLabels = labels.length;
    int maxCorrelations = (numLabels * numLabels - numLabels) ~/ 2;
    debugPrint('maxCorrelations: $maxCorrelations');
    var correlationMatrix = List.generate(
        numLabels + 1, (i) => List(numLabels + 1),
        growable: false);

//  List<num> correlationCoefficients = List.filled(maxCorrelations, null);
//  List<String> attribute1 = List.filled(maxCorrelations, null);
//  List<String> attribute2 = List.filled(maxCorrelations, null);
    int labelCount = 0;
    // 1 to skip date
    for (int row = 1; row < numLabels + 1; row++) {
      // set labels1 for list
      correlationMatrix[row][0] = labels[row - 1];

      //debugPrint('${row / (numLabels + 1)}% done');
      // 1 to skip date
      for (int column = 1; column < numLabels + 1; column++) {
        // set labels2 for list
//      debugPrint('column $column');
//      debugPrint('labelsL ${labels.length}');
//      debugPrint('labels[column] ${labels[column-1]}');
//      debugPrint('correlationMatrix[0]L ${correlationMatrix[0].length}');
//      debugPrint('correlationMatrix[0][column] ${correlationMatrix[0][column]}');
        correlationMatrix[0][column] = labels[column - 1];

        // skip self and double correlation with if:
        if (column > row) {
          Map<num, num> xYStats = {};
//        debugPrint(
//            '\nNow labels: ${labels[row - 1]} and ${labels[column - 1]}.');

          /*
        * get xYStats
        * */
          for (int valueCount = 0; valueCount < numDays; valueCount++) {
//          debugPrint('valueCount: $valueCount');
//          debugPrint(
//              'rowForEachAttribute[row][valueCount])] ${rowForEachAttribute[row - 1][valueCount]}');
//          debugPrint(
//              'rowForEachAttribute[column][valueCount])] ${rowForEachAttribute[column - 1][valueCount]}');
            if (rowForEachAttribute[row - 1][valueCount] != null &&
                rowForEachAttribute[row - 1][valueCount] != 'null' &&
                rowForEachAttribute[column - 1][valueCount] != null &&
                rowForEachAttribute[column - 1][valueCount] != 'null') {
//            debugPrint('there is no null');
              // todo fragile: breaks if cardinality row =! # row, because row is the key.
              //  todo: maybe with cUtils.zip or check cardinality with .cardinality.

              xYStats[(rowForEachAttribute[row - 1][valueCount])] =
                  rowForEachAttribute[column - 1][valueCount];
//            debugPrint('xYStats $xYStats');
            } else {
//            debugPrint('skipping because value is null');
            }
          }

          /*
        * Get correlation coefficient
        * */
//        debugPrint('xYStats.length ${xYStats.length}');
//        debugPrint('labelCount: $labelCount');
          if (xYStats.length > 2) {
//          debugPrint('computing correlation');
            num correlation = StarStatsXY(xYStats).corCoefficient;

            // round if necessary // todo round if too many decimals and hard coded
            if (correlation != 0 && correlation != 1 && correlation != -1) {
              correlation = mUtils.roundToDouble(correlation, 2);
            }
            correlationMatrix[row][column] = correlation;
          } else {
//          debugPrint(
//              'skipping: requirement not full-filled: at least 3 values needed for correlation\n');
          }
//        debugPrint('correlationMatrix: $correlationMatrix');
//        debugPrint('____________________________________\n\n');
          labelCount++;
        }
      }
    } // last for loop

//  for (int row = 0; row < numLabels + 1; row++) {
//    debugPrint('${correlationMatrix[row]}');
//  }

    /*
  * save correlations
  * */
    //final directory = await getApplicationDocumentsDirectory(); // already defined
    final pathOfTheFileToWrite = directory.path + "/correlation_matrix.csv";
    final directoryTarget =
//  await getExternalStorageDirectory(); // todo: currently works only on andoid
//  debugPrint('directoryTarget $directoryTarget');

        debugPrint('targetPath $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    debugPrint('file $file');
    String csv = const ListToCsvConverter().convert(correlationMatrix);
//  debugPrint('csv $csv');
    file.writeAsString(csv);
    debugPrint('correlation_matrix.csv written');
  }
}
