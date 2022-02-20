import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget futureTimeSeriesPlot(attributeName) {
  return FutureBuilder(
    future: timeSeriesChartData(attributeName), //schedule.selectedAttribute1
    builder: (context, snapshot) {
      // chart data arrived && data found
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.data != null) {
        return _timeSeriesSfCartesianChart(snapshot.data);
      }

      // chart data arrived but no data found
      else if (snapshot.connectionState == ConnectionState.done &&
          (snapshot.data == null)) {
        print('chart.dart: chart data arrived but no data found');
        return Text('No data found for this label.');

        // else: i.e. data didn't arrive
      } else {
        return CircularProgressIndicator(); // when Future doesn't get data
      } // snapshot is current state of future
    },
  );
}

Widget futureScatterPlot(attributeName2, attributeName1,trendLineOn) {
  if (attributeName1 != attributeName2) {
    return FutureBuilder(
      future: scatterPlotData(attributeName1, attributeName2),
      builder: (context, snapshot) {
        // chart data arrived && data found
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return _scatterPlot(snapshot.data, attributeName1,trendLineOn);
        }

        // chart data arrived but no data found
        else if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.data == null)) {
          print('chart.dart: chart data arrived but no data found');
          return Text('No data found for this label');

          // else: i.e. data didn't arrive
        } else {
          return CircularProgressIndicator(); // when Future doesn't get data
        }
      },
    );
  } else {
    print('chart.dart: chart data arrived but no data found');
    return Text('No data found for this label');
  }
}

Widget _timeSeriesSfCartesianChart(chartDataList) {
  return SfCartesianChart(
      primaryXAxis:
          DateTimeAxis(dateFormat: DateFormat.yMMMd(), desiredIntervals: 3),
      primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
      series: <ChartSeries>[
        _timeScatterSeries(chartDataList),
      ]);
}

Widget _scatterPlot(chartDataOptimizeList, attributeName1, trendLineOn) {
  return SfCartesianChart(
      margin: EdgeInsets.fromLTRB(6, 8, 2, 0),
      primaryXAxis: NumericAxis(
        rangePadding: ChartRangePadding.none,
        labelStyle: TextStyle(color: Colors.blue, height: 0.7),
        title: AxisTitle(
          text: attributeName1,
          textStyle: TextStyle(
              height: 0.8,
              color: Colors.blue,
              fontFamily: 'Roboto',
              fontSize: 17,
              fontWeight: FontWeight.w300),
        ),
      ),
      primaryYAxis: NumericAxis(
          labelStyle: TextStyle(color: Colors.deepPurple, height: 1),
          rangePadding: ChartRangePadding.none),
      series: <ChartSeries>[
        _scatterPlotScatterSeries(chartDataOptimizeList, trendLineOn),
      ]);
}

_timeScatterSeries(chartDataList) {
// Renders scatter series
  final double size = _sizeManager(chartDataList.length);
  return ScatterSeries<ChartData, DateTime>(
    opacity: math.min(_opacityManager(chartDataList.length) * 2, 1),
    markerSettings:
        MarkerSettings(height: size, width: size, shape: DataMarkerType.circle),
    animationDuration: 3000,
    enableTooltip: true,
    dataSource: chartDataList,
    trendlines: <Trendline>[
      Trendline(
          type: TrendlineType.movingAverage,
          color: Colors.teal,
          width: 2,
          opacity: 0.7,
          enableTooltip: true,
          period: 7,
          animationDuration: 5000.0)
    ],
    xValueMapper: (ChartData data, _) => data.dateTime,
    yValueMapper: (ChartData data, _) => data.value,
  );
}

_scatterPlotScatterSeries(chartDataOptimizeList, trendLineOn) {
  List<Trendline>? trendLine;
  if (trendLineOn){
    trendLine = <Trendline>[
/*      Trendline(
          type: TrendlineType.polynomial,
          color: Colors.grey,
          width: 2,
          opacity: 0.9,
          enableTooltip: true,
          period: 7,
          animationDuration: 5000.0),*/
      Trendline(
          type: TrendlineType.linear,
          color: Colors.teal,
          width: 2,
          opacity: 0.9,
          enableTooltip: true,
          period: 7,
          animationDuration: 5000.0)
    ];
  }
  // Renders scatter chart
  final double size = _sizeManager(chartDataOptimizeList.length);
  return ScatterSeries<ChartDataOptimize, num>(
    opacity: _opacityManager(chartDataOptimizeList.length),
    // //0.23,
    markerSettings:
        MarkerSettings(height: size, width: size, shape: DataMarkerType.circle),
    animationDuration: 3000,
    enableTooltip: true,
    dataSource: chartDataOptimizeList,
    xValueMapper: (ChartDataOptimize data, _) => data.value1,
    yValueMapper: (ChartDataOptimize data, _) => data.value2,
    trendlines: trendLine,
  );
}

class ChartData {
  ChartData(this.dateTime, this.value);

  final DateTime dateTime;
  final double value;
}

double _opacityManager(num) {
  // print('num dots:$num');
  double opacity = 0.1;
  if (num < 3) {
    opacity = 1.0;
  } else if (num < 10) {
    opacity = 0.9;
  } else if (num < 25) {
    opacity = 0.8;
  } else if (num < 50) {
    opacity = 0.7;
  } else if (num < 100) {
    opacity = 0.6;
  } else if (num < 200) {
    opacity = 0.5;
  } else if (num < 400) {
    opacity = 0.3;
  } else if (num < 800) {
    opacity = 0.25;
  } else if (num < 1600) {
    opacity = 0.2;
  } else if (num < 3200) {
    opacity = 0.2;
  } else if (num <= 6400) {
    opacity = 0.2;
  }
  return opacity;
}

double _sizeManager(num) {
  double size = 13.0;
  if (num < 3) {
    size = 12.0;
  } else if (num < 10) {
    size = 11.0;
  } else if (num < 25) {
    size = 10.0;
  } else if (num < 50) {
    size = 9.0;
  } else if (num < 100) {
    size = 8.0;
  } else if (num < 200) {
    size = 7.0;
  } else if (num < 400) {
    size = 5.0;
  } else if (num < 800) {
    size = 4.5;
  } else if (num < 1600) {
    size = 4.0;
  } else if (num < 3200) {
    size = 3.0;
  } else if (num < 6400) {
    size = 2.0;
  } else if (num < 15000) {
    size = 1.0;
  }
  return size;
}
