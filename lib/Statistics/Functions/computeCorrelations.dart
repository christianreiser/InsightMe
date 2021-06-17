import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:insightme/Core/functions/aggregatedData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starfruit/starfruit.dart';


class ComputeCorrelations {
  computeCorrelations() async {
    /// reads daily summaries CSV,
    /// computes correlations
    /// writes correlations matrix as csv

    final directory = await getApplicationDocumentsDirectory();

    /// get Daily Summaries In Row For Each Day Format. calls WriteDailySummariesCSV
    final rowForEachDay =
        await getDailySummariesInRowForEachDayFormat(directory);

    debugPrint('right before getLabels.');
    final List<dynamic> labels = await getLabels(rowForEachDay);

    // getNumDays has to be after getDailySummariesInRowForEachDayFormat because there it is set
    int numDays = rowForEachDay.length;

    final int numLabels = labels.length;
    debugPrint('numLabels: $numLabels');

    final rowForEachAttribute = getRowForEachAttribute(rowForEachDay);

    /// ini correlation matrix
    var correlationMatrix = List.generate(
        numLabels + 1, (i) => List<dynamic>.filled(numLabels + 1, null),
        growable: false);

    /// ini correlationCoefficient
    var correlationCoefficient;

    /// iterate through rows. 1 to skip date
    for (int row = 1; row < numLabels + 1; row++) {
      /// write labels in first column in correlationMatrix
      debugPrint('progress: row $row of $numLabels (numLabels) rows.');
      correlationMatrix[row][0] = labels[row - 1];

      /// iterate through columns. 1 to skip date
      for (int column = 1; column < numLabels + 1; column++) {
        /// write labels in first row in correlationMatrix
        correlationMatrix[0][column] = labels[column - 1];

        /// skip self and double correlation with if column > row:
        if (column > row) {
          /// get xYStats which are needed to compute correlations
          Map<num, num> xYStats =
              getXYStats(rowForEachAttribute, numDays, row, column);

          correlationCoefficient = computeCorrelationCoefficient(xYStats);
          // debugPrint('row: $row; '
          //     'column: $column; '
          //     'correlationCoefficient: $correlationCoefficient; ');
          // debugPrint('xYStats: $xYStats;');

          /// writeCorrelationCoefficients
          correlationMatrix = fillCorrelationCoefficientMatrix(
              correlationCoefficient, correlationMatrix, row, column);
        }
      }
    } // last for loop

    /// write correlations to file
    writeCorrelationsToFile(correlationMatrix, directory);
  }

  Future<int> getNumDays() async {
    /// get number of days
    final prefs = await SharedPreferences.getInstance();
    int numDays = prefs.getInt('numDays') ?? null;
    debugPrint('got numDays $numDays');
    return numDays;
  }

  num computeCorrelationCoefficient(xYStats) {
    num correlationCoefficient;

    /// writeCorrelationCoefficients
    if (xYStats.length > 2) {
      correlationCoefficient = StarStatsXY(xYStats).corCoefficient;

      // catch if correlationCoefficient == NaN(, due indifferent y values?)
      if (correlationCoefficient.isNaN) {
        correlationCoefficient = null;
        // debugPrint(
        //     'correlationCoefficient.isNaN: ${correlationCoefficient.isNaN}');
      }

      /// round if too many decimals
      //if (correlation != 0 && correlation != 1 && correlation != -1) {
      try {
        correlationCoefficient = roundDouble(correlationCoefficient, 2);
      } catch (e) {
        //debugPrint('correlation= $correlationCoefficient was not rounded');
      }
    } else {
      debugPrint(
          'skipping: requirement not full-filled: at least 3 values needed for correlation\n');
      correlationCoefficient = 0;
    }
    //debugPrint('correlationCoefficient: $correlationCoefficient');
    return correlationCoefficient;
  }

  fillCorrelationCoefficientMatrix(
      correlation, correlationMatrix, row, column) {
    //debugPrint('correlationMatrix: $correlationMatrix');
    //debugPrint('correlation: $correlation');
    correlationMatrix[row][column] = correlation;
    correlationMatrix[column][row] = correlation;
    return correlationMatrix;
  }

  void writeCorrelationsToFile(correlationMatrix, directory) {
    /// save correlations
    //debugPrint('correlationMatrix: $correlationMatrix');

    final pathOfTheFileToWrite = directory.path + "/correlation_matrix.csv";
//  debugPrint('directoryTarget $directoryTarget');

    debugPrint('targetPath: $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    debugPrint('file: $file');
    String csv = const ListToCsvConverter().convert(correlationMatrix);
    debugPrint('correlation matrix csv: $csv');
    file.writeAsString(csv);
    debugPrint('correlation_matrix.csv written');
  }

  double roundDouble(double value, int places) {
    /*
    * round to double
    * */
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
