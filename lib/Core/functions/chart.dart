import 'package:flutter/material.dart';
import 'package:insightme/Core/widgets/chart.dart';

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

Future<List<List<ChartData>>> twoAttributeChartData(attributeName1, attributeName2) async {
  List<ChartData> chartDataList1 = await oneAttributeChartData(attributeName1);
  List<ChartData> chartDataList2 = await oneAttributeChartData(attributeName2);
  List<List<ChartData>> chartDataListList = [chartDataList1,chartDataList2];
  return chartDataListList;
}
