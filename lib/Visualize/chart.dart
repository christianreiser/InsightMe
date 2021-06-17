// /// animated line chart widget
// import 'package:fl_animated_linechart/fl_animated_linechart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_charts/flutter_charts.dart' as fc;
// import 'package:insightme/Database/database_helper_entry.dart';
// import '../tmpRoute.dart';
//
// import '../Core/functions/chart.dart';
//
// class Chart extends StatefulWidget {
//   final String selectedAttribute1;
//   final String selectedAttribute2;
//
//   Chart(this.selectedAttribute1, this.selectedAttribute2);
//
//   static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();
//
//   @override
//   _ChartState createState() => _ChartState();
// }
//
// class _ChartState extends State<Chart> {
//   LineChart chart;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder(
//         future: twoAttributeChart(
//             widget.selectedAttribute1, widget.selectedAttribute2),
//         builder: (context, snapshot) {
//           // chart data arrived && data found
//           debugPrint('chart: $chart');
//           if (snapshot.connectionState == ConnectionState.done &&
//               chart != null) {
//             //return AnimatedLineChart(chart);
//             return TmpRouteState().sfCartesianChart();
//           }
//
//           // chart data arrived but no data found
//           else if (snapshot.connectionState == ConnectionState.done &&
//               chart == null) {
//             return Text('No data found for this label');
//
//             // else: i.e. data didn't arrive
//           } else {
//             return CircularProgressIndicator(); // when Future doesn't get data
//           } // snapshot is current state of future
//         },
//       ),
//       // ),
//     ); // This trailing comma makes auto-formatting nicer for build methods.
//   }
// }
