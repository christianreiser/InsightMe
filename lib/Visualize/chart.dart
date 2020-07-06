import 'package:flutter/material.dart';
import './change_notifier.dart';
import 'package:provider/provider.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

class Chart extends StatelessWidget {
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  /*
  * Get dateTime and values of entries from database and set as state
  * input: selectedAttribute
  * returns: dateTimeValueMap
  */
  Future<Map<DateTime, double>> _getdateTimeValueMap(selectedAttribute) async {
    debugPrint('selectedAttribute $selectedAttribute');
    List<Entry> filteredEntryList =
        await databaseHelperEntry.getFilteredEntryList(selectedAttribute);
    List<DateTime> dateList = [];
    for (int i = 0; i < filteredEntryList.length; i++) {
      dateList.add(
        DateTime.parse(
          (filteredEntryList[i].date),
        ),
      );
    }
    // create dateTimeValueMap
    Map<DateTime, double> dateTimeValueMap = {};
    dateTimeValueMap[dateList[0]] = 1.0; // =1 is needed
    for (int ele = 0; ele < filteredEntryList.length; ele++) {
      dateTimeValueMap[dateList[ele]] =
          double.parse(filteredEntryList[ele].value);
    }
    return dateTimeValueMap;
  }

  // create chart
  LineChart chart;

  Future<LineChart> _getChart(selectedAttribute1, selectedAttribute2) async {

    Map<DateTime, double> dateTimeValueMap1 =
        await _getdateTimeValueMap(selectedAttribute1);
    Map<DateTime, double> dateTimeValueMap2 =
        await _getdateTimeValueMap(selectedAttribute2);
    chart = LineChart.fromDateTimeMaps(
        [dateTimeValueMap1, dateTimeValueMap2],
        [Colors.green, Colors.blue],
        [selectedAttribute1, selectedAttribute2], // chart label name
        tapTextFontWeight: FontWeight.w400);

    // todo beginning new for correlation and pValue

    // todo end new for correlation and pValue
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
            debugPrint('chart ${chart}');
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
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        correlation(),
        pValue(),
      ],
    );
  }

  Widget correlation() {
    return Container(
      child: Text('Correlation coefficient: 0.88'),
    );
  }

  Widget pValue() {
    return Container(
      child: Text('pValue: 0.04'),
    );
  }
}
