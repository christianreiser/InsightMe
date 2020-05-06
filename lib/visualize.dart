import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';


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
      Future<List<Entry>> entryListFuture = databaseHelperEntry.getFilteredEntryList('Productivity');
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
    List<double>  valueList = [];
    List<DateTime>  dateList = [];
    print('countEntryFiltered: $countEntryFiltered');

    for (int i = 0; i < countEntryFiltered; i++) {
      valueList.add(double.parse(this.filteredEntryList[i].value));
      // TODO parsing to date type needed?
      dateList.add(DateTime.parse((this.filteredEntryList[i].date)));
      print('dateList: $dateList');
      print('valueList: $valueList');
    }
    print('dateList: $dateList');
    print('valueList: $valueList');

    // update if empty
    if (valueList.isEmpty) {
      _updateFilteredEntryListView();
    }
    print('debug2');
    print('dateList: $dateList');
    print('dateList[0]: ${dateList[0]}');
    // create the lineCharts
    Map<DateTime, double> dateTimeMap= {};
    debugPrint('debug2.1');
    dateTimeMap[dateList[0]] = 1.0;  //TODO removeme
    //print('dateTimeMap[dateList[ele]] = valueList[ele] ${dateTimeMap[dateList[ele]] = valueList[ele]}');
    for (int ele = 0; ele < dateList.length; ele++) {// ele in valueList) {
      debugPrint('debug2.2');
      dateTimeMap[dateList[ele]] = valueList[ele];
      debugPrint('debug2.3');
      debugPrint('dateTimeMap $dateTimeMap');
      debugPrint('ele $ele');
    }
    debugPrint('debug3');

    LineChart chart;
    debugPrint('debug3.5');
    chart = LineChart.fromDateTimeMaps(
        [dateTimeMap, dateTimeMap], [Colors.green, Colors.blue], ['C', 'C'], // TODO dateTimeMap change attribute
        tapTextFontWeight: FontWeight.w400);

    debugPrint('debug4');

    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AnimatedLineChart(chart),
                //child: Text('debug chart'),
              ),// type lineChart
            ]
        ),
      //),

    );// This trailing comma makes auto-formatting nicer for build methods.





  }






  //////////////////////
  Widget getChart() {
    return Column(
        children: <Widget>[
          Text('{getValueList()}'),
        ]
    );
  }
}