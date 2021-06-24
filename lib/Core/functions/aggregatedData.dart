import 'dart:convert' show utf8;
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:insightme/Database/create_daily_summary.dart';

import 'misc.dart';

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
    if (rowForEachAttribute[row - 1][day].runtimeType != String) {
      key = (rowForEachAttribute[row - 1][day]).toDouble();
    }

    // convert to doubles, skip 'null' Strings
    if (rowForEachAttribute[column - 1][day].runtimeType != String) {
      value = (rowForEachAttribute[column - 1][day]).toDouble();
    }

    /// skip if key or value is null
    if (key != null && value != null) {

      /// keys must be unique. Track keys. if not unique modify it a little.
      /// search for duplicate
      bool duplicate = keys.contains(key);
      if (duplicate) {
        duplicateCount = duplicateCount + 1;

        /// increment key by tiny amount to make it unique
        key = key + duplicateCount * 1E-13;
      }

      keys.add(key);

      try {
        /// write xYStats as key value pairs.
        xYStats[(key)] = (value);
        key = null;
        value = null;
      } catch (e) {
        debugPrint('_TypeError');
        key = null;
        value = null;
      }
      /// skip if key or value is null and reset key and value variables
    } else {
      // debugPrint('skipping because value is null');
      key = null;
      value = null;
    }
  }
  return xYStats;
}

Future<List<dynamic>> getDailySummariesInRowForEachDayFormat(directory) async {
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

List<dynamic> getRowForEachAttribute(rowForEachDay) {
  /// remove dates from values
  /// 1. remove dates
  /// 2. transpose
  for (int day = 0; day < rowForEachDay.length; day++) {
    rowForEachDay[day].removeAt(0);
  }
  final rowForEachAttribute = transposeChr(rowForEachDay);
  return rowForEachAttribute;
}

Future<List<dynamic>> getLabels(rowForEachDay) async {
  /// separate labels from values
  final List<dynamic> labels =
      rowForEachDay.removeAt(0); // separate labels from values
  labels.removeAt(0); // remove date-label
  return labels;
}
