import 'package:insightme/Core/widgets/chart.dart';
import 'package:path_provider/path_provider.dart';

import './aggregatedData.dart';
import '../../Database/database_helper_entry.dart';
import '../../Database/entry.dart';

final DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

Future<List<ChartData>> timeSeriesChartData(attributeName) async {
  // Get dateTime and values of entries from database and set as state
  final List<Entry> filteredEntryList =
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
  return chartDataList;
}

Future<List<ChartDataOptimize>> scatterPlotData(
    attributeName1, attributeName2) async {

  final rowForEachDay = await getDailySummariesInRowForEachDayFormat(
      await getApplicationDocumentsDirectory());
  final List<dynamic> labels = await getLabels(rowForEachDay);

  /// handle yesterday: if String contains 'Yesterday' set dayOffset to 1 and
  /// remove yesterday from String
  int daysOffset = 0;
  String tmp = attributeName1.substring(attributeName1.length - 9);
  if (tmp=='Yesterday') {
    daysOffset = 1;
    attributeName1 = attributeName1.substring(0,attributeName1.length - 9);
  }

  final int row = labels.indexOf(attributeName1) + 1;
  final int column = labels.indexOf(attributeName2) + 1;
  final rowForEachAttribute = getRowForEachAttribute(rowForEachDay);
  List<ChartDataOptimize> chartDataOptimizeList = [];
  if (rowForEachDay.isNotEmpty) {
    final Map<num, num> xYStats =
    getXYStats(rowForEachAttribute, rowForEachDay.length, row, column, daysOffset);

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
