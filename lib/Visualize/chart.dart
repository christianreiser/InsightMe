import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as fluCa;
import 'package:path_provider/path_provider.dart';
import './change_notifier.dart';
import 'package:provider/provider.dart';
import '../Database/database_helper_entry.dart';
import '../Database/entry.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert' show utf8;

class Chart extends StatelessWidget {
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

  /*
  * Get dateTime and values of entries from database and set as state
  * input: selectedAttribute
  * returns: dateTimeValueMap
  */
  Future<Map<DateTime, double>> _getDateTimeValueMap(selectedAttribute) async {
    debugPrint('selectedAttribute $selectedAttribute');
    List<Entry> filteredEntryList =
        await databaseHelperEntry.getFilteredEntryList(selectedAttribute);

    // create dateTimeValueMap:
    Map<DateTime, double> dateTimeValueMap = {};
    dateTimeValueMap[DateTime.parse(
      (filteredEntryList[0].date),
    )] = 1.0; // =1 is needed
    debugPrint('filteredEntryList.length ${filteredEntryList.length}');
    for (int ele = 0; ele < filteredEntryList.length; ele++) {
      dateTimeValueMap[DateTime.parse(
        (filteredEntryList[ele].date),
      )] = double.parse(filteredEntryList[ele].value);
    }
    return dateTimeValueMap;
  }

  // create chart
  LineChart chart = null; // needed such that old data is not shown if no info for current as its not overwritten

  Future<LineChart> _getChart(selectedAttribute1, selectedAttribute2) async {
    Map<DateTime, double> dateTimeValueMap1 =
        await _getDateTimeValueMap(selectedAttribute1);
    Map<DateTime, double> dateTimeValueMap2 =
        await _getDateTimeValueMap(selectedAttribute2);
    chart = LineChart.fromDateTimeMaps(
      [dateTimeValueMap1, dateTimeValueMap2],
      [Colors.green, Colors.blue],
      [selectedAttribute1, selectedAttribute2], // axis numbers
      tapTextFontWeight: FontWeight.w600,
    );

    // todo beginning new for correlation and pValue

    // todo end new for correlation and pValue
    return chart;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisualizationChangeNotifier>(
      builder: (context, schedule, _) => Expanded(
        child: FutureBuilder(
          future: _getChart(
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

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        correlation(),
        pValue(),
      ],
    );
  }

  Widget correlation() {
    return Container(
      child: Consumer<VisualizationChangeNotifier>(
        builder: (context, schedule, _) => Expanded(
          child: FutureBuilder(
            future: _getCorrelationCoefficient(
                schedule.selectedAttribute1, schedule.selectedAttribute2),
            builder: (context, snapshot) {
              // chart data arrived && data found
              debugPrint('_correlationCoefficient: $_correlationCoefficient');
              if (snapshot.connectionState == ConnectionState.done &&
                  _correlationCoefficient != null) {
                return Text('Correlation Coeffiecient: $_correlationCoefficient');
              }

              // chart data arrived but no data found
              else if (snapshot.connectionState == ConnectionState.done &&
                  _correlationCoefficient == null) {
                return Text('no correlation found');

                // else: i.e. data didn't arrive
              } else {
                return CircularProgressIndicator(); // when Future doesn't get data
              } // snapshot is current state of future
            },
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.,
    );
  }

  Widget pValue() {
    return Container(
      child: Text('pValue: -'),
    );
  }


  num _correlationCoefficient = null; // needed, otherwise old value is shown if same label shown twice
  Future<num> _getCorrelationCoefficient(attribute1, attribute2) async {
    /*
  * read csv and transform
  * */
    // todo maybe in different file
    final directory = await getApplicationDocumentsDirectory();
    final input = new File(directory.path + "/correlation_matrix.csv").openRead();
    final correlationMatrix = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
    int attributeIndex2 = fluCa.transpose(correlationMatrix)[0].indexOf(attribute2);
    _correlationCoefficient = correlationMatrix[attributeIndex1][attributeIndex2];

    // only one order possible, because correlation matrix is half filled. if wrong order change order
    if (_correlationCoefficient == null) {
      _correlationCoefficient = correlationMatrix[attributeIndex2][attributeIndex1];
    }


    return _correlationCoefficient;
  }
}
