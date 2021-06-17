
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


/// TODO: zoom, tooltip, trackball
/// Error: Cannot run with sound null safety, because the following dependencies
/// don't support null safety:
///
///  - package:syncfusion_flutter_charts
///  - package:starfruit
///  - package:fit_kit
///  - package:intl
///  - package:syncfusion_flutter_core
///  - package:fl_animated_linechart
///  - package:flutter_datetime_picker
///  - package:linalg
/*
late TooltipBehavior _tooltipBehavior;
late ZoomPanBehavior _zoomPanBehavior;
late TrackballBehavior _trackballBehavior;


@override
void initState() {
  _tooltipBehavior = TooltipBehavior(enable: true);
  _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true,
      enableDoubleTapZooming: true
  );
  _trackballBehavior = TrackballBehavior(
    // Enables the trackball
      enable: true,
      tooltipSettings: InteractiveTooltip(
          enable: true,
          color: Colors.red
      )
  );
}*/

class ChartData {
  ChartData(this.dateTime, this.value);

  final DateTime dateTime;
  final double value;
}

Widget sfCartesianChart(chartData) {
  debugPrint('ChartData data len: ${(chartData.length)}');
  debugPrint('chartData[0]: ${(ChartData)}');
  // inspect(chartData);

  return SfCartesianChart(
      primaryXAxis:
          DateTimeAxis(dateFormat: DateFormat.yMMMd(), desiredIntervals: 3),
      primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round
          // minimum: chartData[value].reduce(min),
          // maximum: chartData['value'].reduce(max),
          ),
      // borderWidth: 5,
      // borderColor: Colors.red, // none
      // backgroundColor: Colors.yellow,
      // plotAreaBackgroundColor: Colors.green,
      // plotAreaBorderColor: Colors.blue,
      // plotAreaBorderWidth: 7,
      //plotAreaBackgroundImage: 'images/livechart.png',
      annotations: <CartesianChartAnnotation>[],
      // zoomPanBehavior: _zoomPanBehavior,
      // tooltipBehavior: _tooltipBehavior,
      // Enable tooltip
      series: <ChartSeries>[
        // Renders scatter chart
        ScatterSeries<ChartData, DateTime>(
          opacity: 0.4,
          markerSettings:
              MarkerSettings(height: 6, width: 6, shape: DataMarkerType.circle),
          animationDuration: 3000,
          enableTooltip: true,
          dataSource: chartData,
          trendlines: <Trendline>[
            Trendline(
                type: TrendlineType.movingAverage,
                color: Colors.teal,
                width: 2,
                opacity: 0.4,
                enableTooltip: true,
                period: 7,
                animationDuration: 5000.0)
          ],
          xValueMapper: (ChartData data, _) => data.dateTime,
          yValueMapper: (ChartData data, _) => data.value,
        )
      ]);
}

Widget futureOneAttributeScatterPlot(attributeName) {
  return FutureBuilder(
    future: oneAttributeChartData(attributeName), //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      debugPrint('snapshot: $snapshot');
      debugPrint('snapshot.data: ${snapshot.data}');
      debugPrint('chartData: $chartData');

      if (snapshot.connectionState == ConnectionState.done &&
          chartData != null &&
          snapshot.data != null) {
        return sfCartesianChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          (chartData == null || snapshot.data == null)) {
        return Text('No data found for this label');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}

Widget futureTwoAttributeAnimatedLineChart(attributeName1, attributeName2) {
  // calls AnimatedLineChart(chart) in a future builder
  return FutureBuilder(
    future: twoAttributeChart(attributeName1, attributeName2),
    //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      if (snapshot.connectionState == ConnectionState.done &&
          chart != null &&
          snapshot.data != null) {
        return AnimatedLineChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          (chart == null || snapshot.data == null)) {
        return Text('No data found for this label');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}
