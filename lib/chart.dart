import 'package:flutter/material.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
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
    bool chartDone = false;

    debugPrint('chart1: $chart');
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    // TODO refactoring
    List<Entry> filteredEntryList = await databaseHelperEntry.getFilteredEntryList('Productivity'); //TODO selectedAttribute
    List<DateTime> dateList = [];
    debugPrint('filteredEntryList.length ${filteredEntryList.length}');
    for (int i = 0; i < filteredEntryList.length; i++) {
      // TODO parsing to date type needed?
      dateList.add(
        DateTime.parse(
          (filteredEntryList[i].date),
        ),
      );
    }
    debugPrint('chart2: $chart');

    // create the lineCharts
    Map<DateTime, double> dateTimeMap = {};
    dateTimeMap[dateList[0]] = 1.0;  // =1 is needed
    debugPrint('chart2.1: $chart');
    //print('dateTimeMap[dateList[ele]] = valueList[ele] ${dateTimeMap[dateList[ele]] = valueList[ele]}');
    for (int ele = 0; ele < filteredEntryList.length; ele++) {
      // ele in valueList) {
      debugPrint('chart2.2: $chart');
      dateTimeMap[dateList[ele]] = double.parse(filteredEntryList[ele].value);
      debugPrint('chart2.3: $chart');
    }

    debugPrint('chart3: $chart');

    chart = LineChart.fromDateTimeMaps(
        [dateTimeMap, dateTimeMap],
        [Colors.green, Colors.blue],
        ['C', 'C'], // TODO dateTimeMap change attribute
        tapTextFontWeight: FontWeight.w400);
    debugPrint('chart4: $chart');

    chartDone = true;
    return chartDone;
  }


  @override
  Widget build(BuildContext context) {
    // create valueList and dateList
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    // TODO refactoring


/*    // update if empty
    if (valueList.isEmpty) {
      _updateFilteredEntryListView();
    }*/
    //else { // TODO else doesnt work. try ? and :



    //chart = _getChart();
/*    setState(() {
      this.filteredEntryList = filteredEntryList;
      this.countEntryFiltered = filteredEntryList.length;
    });*/


    return FutureBuilder(
      future: _getDateTimeMap(),
      builder: (context, snapshot) {
        debugPrint('connectionState: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedLineChart(chart);
        } else {
          return CircularProgressIndicator(); // when Future doesn't get data
        } // snapshot is current state of future
      }
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
//}
