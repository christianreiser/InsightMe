import 'package:flutter/material.dart';
import 'package:lifetracker4/Visualize/schedule.dart';
import 'package:provider/provider.dart';
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
  Future<LineChart> _getDateTimeMap(selectedAttribute1, selectedAttribute2) async {
    List<Entry> filteredEntryList = await databaseHelperEntry
        .getFilteredEntryList(selectedAttribute1); //TODO selectedAttribute
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
        [selectedAttribute1, selectedAttribute2], // chart label name
        tapTextFontWeight: FontWeight.w400);
    return chart;
  }

  @override
  Widget build(BuildContext context) {
    
/*    setState(() {
      this.filteredEntryList = filteredEntryList;
      this.countEntryFiltered = filteredEntryList.length;
    });*/

    return Consumer<MySchedule>(
      builder: (context, schedule, _) => Expanded(
        child: FutureBuilder(
          future: _getDateTimeMap(schedule.selectedAttribute1, schedule.selectedAttribute2),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AnimatedLineChart(chart); // todo 2
            } else {
              return CircularProgressIndicator(); // when Future doesn't get data
            } // snapshot is current state of future
          },
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
