import 'package:flutter/material.dart';
import 'package:insightme/Core/widgets/chart.dart';
import 'package:path_provider/path_provider.dart';

import './aggregatedData.dart';
import '../../Database/database_helper_entry.dart';
import '../../Database/entry.dart';

final DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

Future<List<ChartData>> oneAttributeChartData(attributeName) async {
  // Get dateTime and values of entries from database and set as state
  List<Entry> filteredEntryList =
      await databaseHelperEntry.getFilteredEntryList(attributeName);

  // create chartDataList:
  List<ChartData> chartDataList = <ChartData>[];

  // fill chartDataList
  for (int ele = 0; ele < filteredEntryList.length; ele++) {
    chartDataList.add(
      ChartData(
        DateTime.parse(filteredEntryList[ele].date),
        double.parse(filteredEntryList[ele].value),
      ),
    );
  }
  debugPrint('chartDataList: $chartDataList');
  return chartDataList;
}

Future<List<ChartDataOptimize>> twoAttributeChartData(
    attributeName1, attributeName2) async {
  final rowForEachDay = await getDailySummariesInRowForEachDayFormat(
      await getApplicationDocumentsDirectory());
  final List<dynamic> labels = await getLabels(rowForEachDay);
  final int row = labels.indexOf(attributeName1) + 1;
  final int column = labels.indexOf(attributeName2) + 1;
  final rowForEachAttribute = getRowForEachAttribute(rowForEachDay);
  List<ChartDataOptimize> chartDataOptimizeList = [];
  if (rowForEachDay.isNotEmpty) {
    final Map<num, num> xYStats =
    getXYStats(rowForEachAttribute, rowForEachDay.length, row, column);

    xYStats.forEach((k, v) => chartDataOptimizeList.add(
      ChartDataOptimize(k, v),
    ));
  }
  return chartDataOptimizeList;
}

class ChartDataOptimize {
  ChartDataOptimize(this.value1, this.value2);

  final num value1;
  final num value2;
}
