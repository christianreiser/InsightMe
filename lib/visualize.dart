import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

class Visualize extends StatefulWidget {
  Visualize({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VisualizeState createState() => _VisualizeState();
}

class _VisualizeState extends State<Visualize> {
  int countEntryFiltered = 0;
  List<Entry> filteredEntryList;
  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  // updateEntryListView depends on state
  void _updateFilteredEntryListView() {
    final Future<Database> dbFuture = databaseHelperEntry.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> entryListFuture =
          databaseHelperEntry.getFilteredEntryList('Productivity');
      entryListFuture.then((filteredEntryList) {
        setState(() {
          this.filteredEntryList = filteredEntryList;
          this.countEntryFiltered = filteredEntryList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // get data from DB
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    // TODO refactoring
    List<double> valueList = [];
    List<DateTime> dateList = [];

    for (int i = 0; i < countEntryFiltered; i++) {
      valueList.add(
        double.parse(this.filteredEntryList[i].value),
      );
      // TODO parsing to date type needed?
      dateList.add(
        DateTime.parse(
          (this.filteredEntryList[i].date),
        ),
      );
    }

    // update if empty
    if (valueList.isEmpty) {
      _updateFilteredEntryListView();
    }
    // create the lineCharts
    Map<DateTime, double> dateTimeMap = {};
    dateTimeMap[dateList[0]] = 1.0; //TODO removeme
    //print('dateTimeMap[dateList[ele]] = valueList[ele] ${dateTimeMap[dateList[ele]] = valueList[ele]}');
    for (int ele = 0; ele < dateList.length; ele++) {
      // ele in valueList) {
      dateTimeMap[dateList[ele]] = valueList[ele];
    }

    LineChart chart;
    chart = LineChart.fromDateTimeMaps(
        [dateTimeMap, dateTimeMap],
        [Colors.green, Colors.blue],
        ['C', 'C'], // TODO dateTimeMap change attribute
        tapTextFontWeight: FontWeight.w400);

    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AnimatedLineChart(chart),
            ), // type lineChart
          ]),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
