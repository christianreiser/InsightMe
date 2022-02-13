import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:insightme/Core/functions/aggregatedData.dart';
import 'package:path_provider/path_provider.dart';
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

    print('get labels');
    final List<dynamic> labels = await getLabels(rowForEachDay);

    /// getNumDays has to be after getDailySummariesInRowForEachDayFormat because there it is set
    int numDays = rowForEachDay.length;

    final int numLabels = labels.length;
    print('got # Labels: $numLabels');

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
      print('progress: row $row of $numLabels (numLabels) rows.');
      correlationMatrix[row][0] = labels[row - 1];

      /// iterate through columns. 1 to skip date
      for (int column = 1; column < numLabels + 1; column++) {
        /// write labels in first row in correlationMatrix
        correlationMatrix[0][column] = labels[column - 1];

        /// skip self and double correlation with if column > row:
        if (column > row) {
          /// get xYStats which are needed to compute correlations
          Map<num?, num> xYStats =
              getXYStats(rowForEachAttribute, numDays, row, column,0);

          correlationCoefficient = _computeCorrelationCoefficient(xYStats);

          /// writeCorrelationCoefficients
          correlationMatrix = _fillCorrelationCoefficientMatrix(
              correlationCoefficient, correlationMatrix, row, column);
        }
      }
    } // last for loop

    /// write correlations to file
    _writeCorrelationsToFile(correlationMatrix, directory);
  }

  num? _computeCorrelationCoefficient(xYStats) {
    num? correlationCoefficient;

    /// writeCorrelationCoefficients
    if (xYStats.length > 2) {
      correlationCoefficient = StarStatsXY(xYStats).corCoefficient;

      /// catch if correlationCoefficient == NaN(, due indifferent y values?)
      if (correlationCoefficient.isNaN) {
        correlationCoefficient = null;
      }

      /// round if too many decimals
      try {
        correlationCoefficient = _roundDouble(correlationCoefficient as double, 2);
      } catch (e) {
      }
    } else {
      print(
          'skipping: requirement not full-filled: at least 3 values needed for correlation\n');
      correlationCoefficient = 0;
    }
    return correlationCoefficient;
  }

  _fillCorrelationCoefficientMatrix(
      correlation, correlationMatrix, row, column) {
    correlationMatrix[row][column] = correlation;
    correlationMatrix[column][row] = correlation;
    return correlationMatrix;
  }

  void _writeCorrelationsToFile(correlationMatrix, directory) {
    /// save correlations
    final pathOfTheFileToWrite = directory.path + "/correlation_matrix.csv";

    print('targetPath: $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    String csv = const ListToCsvConverter().convert(correlationMatrix);
    file.writeAsString(csv);
    print('correlation_matrix.csv written');
  }

  double _roundDouble(double value, int places) {
    /// round to double
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }
}
