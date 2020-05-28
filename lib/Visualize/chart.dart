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

  // TODO remove copy and pasting below
  // selectedAttribute1
  // get data from db delayed and set as state
  Future<LineChart> _getDateTimeMap(selectedAttribute1, selectedAttribute2) async {
    List<Entry> filteredEntryList1 = await databaseHelperEntry
        .getFilteredEntryList(selectedAttribute1); //TODO selectedAttribute
    List<DateTime> dateList1 = [];
    debugPrint('filteredEntryList.length ${filteredEntryList1.length}');
    for (int i = 0; i < filteredEntryList1.length; i++) {
      dateList1.add(
        DateTime.parse(
          (filteredEntryList1[i].date),
        ),
      );
    }
    // create dateTimeMap
    Map<DateTime, double> dateTimeMap1 = {};
    dateTimeMap1[dateList1[0]] = 1.0; // =1 is needed
    for (int ele = 0; ele < filteredEntryList1.length; ele++) {
      dateTimeMap1[dateList1[ele]] = double.parse(filteredEntryList1[ele].value);
    }


    // selectedAttribute2
    // get data from db delayed and set as state
    List<Entry> filteredEntryList2 = await databaseHelperEntry
        .getFilteredEntryList(selectedAttribute2); //TODO selectedAttribute
    List<DateTime> dateList2 = [];
    debugPrint('filteredEntryList.length ${filteredEntryList2.length}');
    for (int i = 0; i < filteredEntryList2.length; i++) {
      dateList2.add(
        DateTime.parse(
          (filteredEntryList2[i].date),
        ),
      );
    }
    // create dateTimeMap
    Map<DateTime, double> dateTimeMap2 = {};
    dateTimeMap2[dateList2[0]] = 1.0; // =1 is needed
    for (int ele = 0; ele < filteredEntryList2.length; ele++) {
      dateTimeMap2[dateList2[ele]] = double.parse(filteredEntryList2[ele].value);
    }


    // fill chart
    chart = LineChart.fromDateTimeMaps(
        [dateTimeMap1, dateTimeMap2],
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
