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

Future<List<ChartDataOptimize>> twoAttributeChartData(attributeName1, attributeName2) async {
  debugPrint('entered twoAttributeChartData');
  debugPrint('1asf');

  final rowForEachDay =
  await getDailySummariesInRowForEachDayFormat(await getApplicationDocumentsDirectory());
  debugPrint('2asf');



  // getNumDays has to be after getDailySummariesInRowForEachDayFormat because there it is set
  debugPrint('4asf');

  final List<dynamic> labels = await getLabels(rowForEachDay);
  debugPrint('4.1asf');
  debugPrint('labels: $labels');
  final int row = labels.indexOf(attributeName1)+2;
  debugPrint('row: $row');
  final int column = labels.indexOf(attributeName2)+2;
  debugPrint('column: $column');

  final Map<num, num> xYStats =
  getXYStats(getRowForEachAttribute(rowForEachDay), rowForEachDay.length, row, column);
  debugPrint('xYStats.length: ${xYStats.length}');
  debugPrint('xYStats.keys.length: ${xYStats.keys.length}');
  final List<num> attributeValues1 = xYStats.keys;
  debugPrint('attributeValues1.length: ${attributeValues1.length}');
  debugPrint('xYStats.values.length: ${xYStats.values.length}');
  final List<num> attributeValues2 = xYStats.values;
  debugPrint('attributeValues2: ${attributeValues2.length}');
  List<ChartDataOptimize> chartDataOptimizeList = [];
  debugPrint('chartDataOptimizeList.length: ${chartDataOptimizeList.length}');

  // fill chartDataList
  for (int i = 0; i < xYStats.length; i++) {
    chartDataOptimizeList.add(
      ChartDataOptimize(
        attributeValues1[i],
        attributeValues2[i],
      ),
    );
  }
  return chartDataOptimizeList;
}

class ChartDataOptimize {
  ChartDataOptimize(this.value1, this.value2);
  final num value1;
  final num value2;
}