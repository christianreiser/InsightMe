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
    //debugPrint('rowForEachAttribute[column - 1][day]: ${rowForEachAttribute[column - 1][day]}');
    //debugPrint('rowForEachAttribute: ${rowForEachAttribute}');

    // convert to doubles, skip 'null' Strings
    if (rowForEachAttribute[column - 1][day].runtimeType != String) {
      value = (rowForEachAttribute[column - 1][day]).toDouble();
    }
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
        //debugPrint('duplicate key incremented to $key');
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
      // debugPrint('skipping because value is null');
    }
  }
  return xYStats;
}

Future<List<dynamic>> getDailySummariesInRowForEachDayFormat(directory) async {
  /// call createDailySummariesCSVFromDB
  await WriteDailySummariesCSV().writeDailySummariesCSV();
  sleep(Duration(milliseconds:20)); /// somehow probably needed to avoid empty rowForEachDay
  /// read daily summaries csv and transform
  final input = new File(directory.path + "/daily_summaries.csv").openRead();
  var rowForEachDay = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();

  /// ugly workaround with waiting to avoid empty rowForEachDay
  if (rowForEachDay.isEmpty) {
    debugPrint('ERROR!!!: rowForEachDay is empty: $rowForEachDay');
    sleep(Duration(milliseconds:20)); /// somehow probably needed to avoid empty rowForEachDay
    /// read daily summaries csv and transform
    final input = new File(directory.path + "/daily_summaries.csv").openRead();
    rowForEachDay = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }
  /// end of bad workaround

  return rowForEachDay;
}

List<dynamic> getRowForEachAttribute(rowForEachDay) {
  /// remove dates from values
  /// 1. remove dates
  /// 2. transpose
  // debugPrint('rowForEachDay: $rowForEachDay');
  for (int day = 0; day < rowForEachDay.length; day++) {
    //debugPrint('rowForEachDay[day]: ${rowForEachDay[day]}');
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
  // debugPrint('labels: $labels');
  return labels;
}
