//import 'package:flutter/material.dart';
//import 'package:lifetracker4/Visualize/change_notifier.dart';
//import 'package:provider/provider.dart';
//import '../Database/database_helper_entry.dart';
//import '../Database/entry.dart';
//import 'package:fl_animated_linechart/fl_animated_linechart.dart';
//
//class Correlation extends StatefulWidget {
//  Correlation({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  _CorrelationState createState() => _CorrelationState();
//}
//
//class _CorrelationState extends State<Correlation> {
//  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();
//
//  // get data from db delayed and set as state
//  Future<Map<DateTime, double>> _getDateTimeMap(selectedAttribute) async {
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Consumer<MySchedule>(
//      builder: (context, schedule, _) => Expanded(
//        child: FutureBuilder(
//          future: _getChart(schedule.selectedAttribute1, schedule.selectedAttribute2),
//          builder: (context, snapshot) {
//
//            // chart data arrived && data found
//            if (snapshot.connectionState == ConnectionState.done && chart != null) {
//              debugPrint('chart: $chart');
//              return AnimatedLineChart(chart);
//            }
//
//            // chart data arrived but no data found
//            else if (snapshot.connectionState == ConnectionState.done && chart == null) {
//              return Text('no data found for this label');
//
//              // else: i.e. data didn't arrive
//            } else {
//              return CircularProgressIndicator(); // when Future doesn't get data
//            } // snapshot is current state of future
//
//          },
//        ),
//      ),
//    ); // This trailing comma makes auto-formatting nicer for build methods.
//  }
//}
