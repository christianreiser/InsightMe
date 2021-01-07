import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/chart.dart';
import 'package:provider/provider.dart';

import './change_notifier.dart';
import '../Database/database_helper_entry.dart';


class Chart extends StatelessWidget {
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();


  @override
  Widget build(BuildContext context) {
    return Consumer<VisualizationChangeNotifier>(
      builder: (context, schedule, _) => Expanded(
        child: FutureBuilder(
          future: twoAttributeChart(
              schedule.selectedAttribute1, schedule.selectedAttribute2),
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
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
