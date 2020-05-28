import 'package:flutter/material.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

class Chart extends StatefulWidget {
  Chart({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  //int countEntryFiltered = 0;
  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();
  LineChart chart;

  // get data from db delayed and set as state
  Future<bool> _getDateTimeMap() async {

    List<Entry> filteredEntryList = await databaseHelperEntry
        .getFilteredEntryList('Productivity'); //TODO selectedAttribute
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

    // fill chart
    chart = LineChart.fromDateTimeMaps(
        [dateTimeMap, dateTimeMap],
        [Colors.green, Colors.blue],
        ['Productivity', 'Mood'], // TODO dateTimeMap change attribute
        tapTextFontWeight: FontWeight.w400);
    return true;
  }

  @override
  Widget build(BuildContext context) {


/*    setState(() {
      this.filteredEntryList = filteredEntryList;
      this.countEntryFiltered = filteredEntryList.length;
    });*/

    return FutureBuilder(
        future: _getDateTimeMap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AnimatedLineChart(chart);
          } else {
            return CircularProgressIndicator(); // when Future doesn't get data
          } // snapshot is current state of future
        }); // This trailing comma makes auto-formatting nicer for build methods.
  }
}