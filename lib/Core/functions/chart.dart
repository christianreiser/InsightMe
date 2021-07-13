import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';

import '../../Database/database_helper_entry.dart';
import '../../Database/entry.dart';

final DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

//  reset chart
LineChart chart; // = null;

Future<Map<DateTime, double>> getDateTimeValueMap(attributeName) async {
  // Get dateTime and values of entries from database and set as state
  // input: selectedAttribute
  // returns: dateTimeValueMap
  List<Entry> filteredEntryList =
      await databaseHelperEntry.getFilteredEntryList(attributeName);

  // create dateTimeValueMap:
  Map<DateTime, double> dateTimeValueMap = {};
  dateTimeValueMap[DateTime.parse(
    (filteredEntryList[0].date),
  )] = 1.0; // =1 is needed
  debugPrint('filteredEntryList.length ${filteredEntryList.length}');
  for (int ele = 0; ele < filteredEntryList.length; ele++) {
    dateTimeValueMap[DateTime.parse(
      (filteredEntryList[ele].date),
    )] = double.parse(filteredEntryList[ele].value);
  }
  return dateTimeValueMap;
}

Future<LineChart> oneAttributeChart(attributeName) async {
  // used in data tab
  Map<DateTime, double> dateTimeValueMap1 =
      await getDateTimeValueMap(attributeName);
  // debugPrint('dateTimeValueMap1: $dateTimeValueMap1');
  chart = LineChart.fromDateTimeMaps(
    [dateTimeValueMap1],
    [Colors.blue],
    [attributeName], // axis numbers
    tapTextFontWeight: FontWeight.w600,
  );
  debugPrint('chart: $chart');
  return chart;
}

Future<LineChart> twoAttributeChart(attributeName1, attributeName2) async {
  Map<DateTime, double> dateTimeValueMap1 =
      await getDateTimeValueMap(attributeName1);
  Map<DateTime, double> dateTimeValueMap2 =
      await getDateTimeValueMap(attributeName2);
  chart = LineChart.fromDateTimeMaps(
    [dateTimeValueMap1, dateTimeValueMap2],
    [Colors.green, Colors.blue],
    [attributeName1, attributeName2],
    tapTextFontWeight: FontWeight.w600,
  );
  return chart;
}
