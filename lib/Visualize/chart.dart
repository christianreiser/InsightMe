import 'package:flutter/material.dart';
import './change_notifier.dart';
import 'package:provider/provider.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

class Chart extends StatelessWidget {
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  // get data from db delayed and set as state
  Future<Map<DateTime, double>> _getDateTimeMap(selectedAttribute) async {
    List<Entry> filteredEntryList =
        await databaseHelperEntry.getFilteredEntryList(selectedAttribute);
    List<DateTime> dateList = [];
    debugPrint('filteredEntryList.length ${filteredEntryList.length}');
    for (int i = 0; i < filteredEntryList.length; i++) {
      dateList.add(
        DateTime.parse(
          (filteredEntryList[i].date),
        ),
      );
    }
    // create dateTimeMap
    Map<DateTime, double> dateTimeMap = {};
    dateTimeMap[dateList[0]] = 1.0; // =1 is needed
    for (int ele = 0; ele < filteredEntryList.length; ele++) {
      dateTimeMap[dateList[ele]] = double.parse(filteredEntryList[ele].value);
    }
    return dateTimeMap;
  }

  // create chart
  LineChart chart;
  Future<LineChart> _getChart(selectedAttribute1, selectedAttribute2) async {
    Map<DateTime, double> dateTimeMap1 =
        await _getDateTimeMap(selectedAttribute1);
    Map<DateTime, double> dateTimeMap2 =
        await _getDateTimeMap(selectedAttribute2);
    chart = LineChart.fromDateTimeMaps(
        [dateTimeMap1, dateTimeMap2],
        [Colors.green, Colors.blue],
        [selectedAttribute1, selectedAttribute2], // chart label name
        tapTextFontWeight: FontWeight.w400);
    return chart;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisualizationChangeNotifier>(
      builder: (context, schedule, _) => Expanded(
        child: FutureBuilder(
          future: _getChart(
              schedule.selectedAttribute1, schedule.selectedAttribute2),
          builder: (context, snapshot) {
            // chart data arrived && data found
            if (snapshot.connectionState == ConnectionState.done &&
                chart != null) {
              return AnimatedLineChart(chart);
            }

            // chart data arrived but no data found
            else if (snapshot.connectionState == ConnectionState.done &&
                chart == null) {
              return Text('no data found for this label');

              // else: i.e. data didn't arrive
            } else {
              return CircularProgressIndicator(); // when Future doesn't get data
            } // snapshot is current state of future
          },
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
