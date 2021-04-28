import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Database/database_helper_entry.dart';
import 'package:insightme/Database/entry.dart';

class Chart extends StatelessWidget {
  final String selectedAttribute1;
  final String selectedAttribute2;

  Chart(this.selectedAttribute1, this.selectedAttribute2);

  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

//  reset chart
  LineChart chart = null;

/*
  * Get dateTime and values of entries from database and set as state
  * input: selectedAttribute
  * returns: dateTimeValueMap
  */
  Future<Map<DateTime, double>> _getDateTimeValueMap(selectedAttribute) async {
    debugPrint('selectedAttribute $selectedAttribute');
    List<Entry> filteredEntryList =
        await databaseHelperEntry.getFilteredEntryList(selectedAttribute);

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

  Future<LineChart> _getChart(selectedAttribute1, selectedAttribute2) async {
    debugPrint('selectedAttribute1, selectedAttribute2: $selectedAttribute1 $selectedAttribute2');
    Map<DateTime, double> dateTimeValueMap1 =
        await _getDateTimeValueMap(selectedAttribute1);
    debugPrint('dateTimeValueMap1 attribute 1 $dateTimeValueMap1');
    Map<DateTime, double> dateTimeValueMap2 =
        await _getDateTimeValueMap(selectedAttribute2);
    debugPrint('dateTimeValueMap2 attribute 2 $dateTimeValueMap2');
    chart = LineChart.fromDateTimeMaps(
      [dateTimeValueMap1, dateTimeValueMap2],
      [Colors.green, Colors.blue],
      [selectedAttribute1, selectedAttribute2], // axis numbers
      //tapTextFontWeight: FontWeight.w600,
    );

    return chart;
  }

  @override
  Widget build(BuildContext context) {
    return
        // Consumer<OptimizationChangeNotifier>( // todo move state up
        // builder: (context, schedule, _) =>
        Expanded(
      child: FutureBuilder(
        future: _getChart(selectedAttribute1, selectedAttribute2),
        builder: (context, snapshot) {
          // chart data arrived && data found
          debugPrint('chart: $chart');
          if (snapshot.connectionState == ConnectionState.done &&
              chart != null) {
            return AnimatedLineChart(chart);
          }

          // chart data arrived but no data found
          else if (snapshot.connectionState == ConnectionState.done &&
              chart == null) {
            return Text('No data found for this label');

            // else: i.e. data didn't arrive
          } else {
            return CircularProgressIndicator(); // when Future doesn't get data
          } // snapshot is current state of future
        },
      ),
      // ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
