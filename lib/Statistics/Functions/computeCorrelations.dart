import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starfruit/starfruit.dart';

import '../../Database/create_daily_summary.dart';

class ComputeCorrelations {
  computeCorrelations() async {
    /// reads daily summaries CSV,
    /// computes correlations
    /// writes correlations matrix as csv

    int numDays = await getNumDays();

    final directory = await getApplicationDocumentsDirectory();

    /// get Daily Summaries In Row For Each Day Format. calls WriteDailySummariesCSV
    final rowForEachDay =
        await getDailySummariesInRowForEachDayFormat(directory);

    final List<dynamic> labels = await getLabels(rowForEachDay);
    final int numLabels = labels.length;
    debugPrint('numLabels $numLabels');

    final rowForEachAttribute = getRowForEachAttribute(rowForEachDay);

    /// ini correlation matrix
    /// todo try List<List<double>> instead of var
    var correlationMatrix = List.generate(
        numLabels + 1, (i) => List(numLabels + 1),
        growable: false);

    /// ini correlationCoefficient
    var correlationCoefficient;

    /// iterate through rows. 1 to skip date
    for (int row = 1; row < numLabels + 1; row++) {
      /// write labels in first column in correlationMatrix
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
    debugPrint('numDays $numDays');
    return numDays;
  }

  Future<List<dynamic>> getDailySummariesInRowForEachDayFormat(
      directory) async {
    /// call createDailySummariesCSVFromDB
    await WriteDailySummariesCSV().writeDailySummariesCSV();

    /// read daily summaries csv and transform
    final input = new File(directory.path + "/daily_summaries.csv").openRead();
    final rowForEachDay = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    return rowForEachDay;
  }

  Future<List<dynamic>> getLabels(rowForEachDay) async {
    /// separate labels from values
    final List<dynamic> labels =
        rowForEachDay.removeAt(0); // separate labels from values
    labels.removeAt(0); // remove date-label
//  debugPrint('labels $labels');
    debugPrint('rowForEachDay $rowForEachDay');
    return labels;
  }

  List<dynamic> getRowForEachAttribute(rowForEachDay) {
    /// remove dates from values
    var rowForEachAttribute = List<List<dynamic>>.from(
        transpose(rowForEachDay)); // make list variable length
    rowForEachAttribute.removeAt(0); // remove dates
//  List<List<num>> rowForEachAttributeNum = rowForEachAttribute.cast<List<num>>();
//debugPrint('rowForEachAttribute $rowForEachAttribute');
    return rowForEachAttribute;
  }

  Map<num, num> getXYStats(rowForEachAttribute, numDays, row, column) {
    /// get xYStats which are needed to compute correlations

    /// ini xYStats
    Map<num, num> xYStats = {};
    int duplicateCount = 0;

    /// ini key value which are added to xYStats
    double key;
    double value;

    /// ini keys to keep track of key uniqueness
    List<double> keys = [];

    for (int day = 0; day < numDays; day++) {
      key = (rowForEachAttribute[row - 1][day]).toDouble();
      //debugPrint('rowForEachAttribute[column - 1][day]: ${rowForEachAttribute[column - 1][day]}');
      value = (rowForEachAttribute[column - 1][day]).toDouble();
      // debugPrint('day: $day');
      // debugPrint('key $key');
      // debugPrint('value $value');

      /// exclude day if one of the two attributes has a value of null
      if (key != null && value != null) {
//            debugPrint('there is no null');

        // debugPrint('row - 1: ${row - 1}, day: $day');
        // debugPrint('key $key');
        // debugPrint('value $value');

        /// keys must be unique. Track keys. if not unique modify it a little.
        /// search for duplicate
        bool duplicate = keys.contains(key);
        if (duplicate) {
          duplicateCount = duplicateCount + 1;

          /// increment key by tiny amount to make it unique
          key = key + duplicateCount * 1E-13;
          debugPrint('duplicate key incremented to $key');
        }

        keys.add(key);
        //debugPrint('keys: $keys');
        //debugPrint('keys.cardinality: ${keys.cardinality}');
        try {
          /// write xYStats as key value pairs.
          xYStats[(key)] = (value);
          //debugPrint('xYStats $xYStats');
        } catch (e) {
          debugPrint('_TypeError');
        }
      } else {
        debugPrint('skipping because value is null');
      }
    }
    return xYStats;
  }

  num computeCorrelationCoefficient(xYStats) {
    num correlationCoefficient;

    /// writeCorrelationCoefficients
    if (xYStats.length > 2) {
      correlationCoefficient = StarStatsXY(xYStats).corCoefficient;

      /// round if necessary // todo round if too many decimals and hard coded
      //if (correlation != 0 && correlation != 1 && correlation != -1) {
      try {
        correlationCoefficient =
            roundDouble(correlationCoefficient, 2);
      } catch (e) {
        //debugPrint('correlation= $correlationCoefficient was not rounded');
      }
    } else {
      debugPrint(
          'skipping: requirement not full-filled: at least 3 values needed for correlation\n');
      correlationCoefficient = 0;
    }
    return correlationCoefficient;
  }

  fillCorrelationCoefficientMatrix(
      correlation, correlationMatrix, row, column) {
    correlationMatrix[row][column] = correlation;
    correlationMatrix[column][row] = correlation;
    return correlationMatrix;
  }

  void writeCorrelationsToFile(correlationMatrix, directory) {
    /// save correlations
    debugPrint('correlationMatrix: $correlationMatrix');

    final pathOfTheFileToWrite = directory.path + "/correlation_matrix.csv";
//  debugPrint('directoryTarget $directoryTarget');

    debugPrint('targetPath $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    debugPrint('file $file');
    String csv = const ListToCsvConverter().convert(correlationMatrix);
//  debugPrint('csv $csv');
    file.writeAsString(csv);
    debugPrint('correlation_matrix.csv written');
  }

  double roundDouble(double value, int places){
    /*
    * round to double
    * */
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
