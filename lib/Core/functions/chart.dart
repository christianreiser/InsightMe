import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';

import '../../Database/database_helper_entry.dart';
import '../../Database/entry.dart';

final DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

//  reset chart
LineChart chart = null;


Future<Map<DateTime, double>> getDateTimeValueMap(attributeName) async {
  debugPrint('attributeName test works: $attributeName');
  // Get dateTime and values of entries from database and set as state
  // input: selectedAttribute
  // returns: dateTimeValueMap
  List<Entry> filteredEntryList =
  await databaseHelperEntry.getFilteredEntryList(attributeName);
  debugPrint('attributeName test works: $attributeName');

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
  debugPrint('attributeName test works: $attributeName');

  Map<DateTime, double> dateTimeValueMap1 =
  await getDateTimeValueMap(attributeName);
  debugPrint('dateTimeValueMap1 test works: $dateTimeValueMap1');


  chart = LineChart.fromDateTimeMaps( // todo final chart?
    [dateTimeValueMap1],
    [Colors.blue],
    [attributeName], // axis numbers
    tapTextFontWeight: FontWeight.w600,
  );
  debugPrint('chart debugging?: $chart');

  return chart;
}

Future<LineChart> twoAttributeChart(selectedAttribute1, selectedAttribute2) async {
  Map<DateTime, double> dateTimeValueMap1 =
  await getDateTimeValueMap(selectedAttribute1);
  Map<DateTime, double> dateTimeValueMap2 =
  await getDateTimeValueMap(selectedAttribute2);
  chart = LineChart.fromDateTimeMaps(
    [dateTimeValueMap1, dateTimeValueMap2],
    [Colors.green, Colors.blue],
    [selectedAttribute1, selectedAttribute2], // axis numbers
    tapTextFontWeight: FontWeight.w600,
  );
  return chart;
}

