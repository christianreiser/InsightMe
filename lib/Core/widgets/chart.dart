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

Widget sfCartesianChart(chartDataList) {
  debugPrint('chartData[0]: ${(ChartData)}');

  return SfCartesianChart(
      primaryXAxis:
          DateTimeAxis(dateFormat: DateFormat.yMMMd(), desiredIntervals: 3),
      primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
      series: <ChartSeries>[
        scatterSeries(chartDataList),
      ]);
}

Widget twoAttributeSfCartesianChart(chartDataOptimizeList) {
  return SfCartesianChart(
      primaryXAxis: NumericAxis(
          // desiredIntervals: 3,
          ),
      primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
      // zoomPanBehavior: _zoomPanBehavior, // todo
      // tooltipBehavior: _tooltipBehavior, // todo
      series: <ChartSeries>[
        scatterSeriesOptimize(chartDataOptimizeList),
      ]);
}

scatterSeries(chartDataList) {
// Renders scatter chart
  return ScatterSeries<ChartData, DateTime>(
    opacity: 0.4,
    markerSettings:
        MarkerSettings(height: 6, width: 6, shape: DataMarkerType.circle),
    animationDuration: 3000,
    enableTooltip: true,
    dataSource: chartDataList,
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
  );
}

scatterSeriesOptimize(chartDataOptimizeList) {
// Renders scatter chart
  return ScatterSeries<ChartDataOptimize, num>(
    opacity: 0.4,
    markerSettings:
        MarkerSettings(height: 6, width: 6, shape: DataMarkerType.circle),
    animationDuration: 3000,
    enableTooltip: true,
    dataSource: chartDataOptimizeList,
    xValueMapper: (ChartDataOptimize data, _) => data.value1,
    yValueMapper: (ChartDataOptimize data, _) => data.value2,
  );
}

Widget futureOneAttributeScatterPlot(attributeName) {
  return FutureBuilder(
    future: oneAttributeChartData(attributeName), //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      debugPrint('snapshot: $snapshot');
      debugPrint('snapshot.data: ${snapshot.data}');

      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.data != null) {
        return sfCartesianChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          (snapshot.data == null)) {
        return Text('No data found for this label');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}

Widget futureTwoAttributeScatterPlot(attributeName1, attributeName2) {
  if (attributeName1 != attributeName2) {
    return FutureBuilder(
      future: twoAttributeChartData(attributeName1, attributeName2),
      builder: (context, snapshot) {
        // chart data arrived && data found
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return twoAttributeSfCartesianChart(snapshot.data);
        }

        // chart data arrived but no data found
        else if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.data == null)) {
          return Text('No data found for this label');

          // else: i.e. data didn't arrive
        } else {
          return CircularProgressIndicator(); // when Future doesn't get data
        } // snapshot is current state of future
      },
    );
  } else {
    return Text('No data found for this label');
  }
}
