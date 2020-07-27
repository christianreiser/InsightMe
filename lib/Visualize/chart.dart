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
import 'dart:math';

class Chart extends StatelessWidget {
  static DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();

//  reset chart
  LineChart chart = null;

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
  //  reset _correlationCoefficient
  num _correlationCoefficient = null;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          correlation(),
          pValue(),
          //statisticWithIcons(),
        ]);
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
                return Text(
                    'Correlation Coeffiecient: $_correlationCoefficient');
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

  Future<num> _getCorrelationCoefficient(attribute1, attribute2) async {
    debugPrint('called _getCorrelationCoefficient');

    /*
  * read csv and transform
  * */
    // todo maybe in different file
    final directory = await getApplicationDocumentsDirectory();
    final input =
        new File(directory.path + "/correlation_matrix.csv").openRead();
    final correlationMatrix = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    //debugPrint('correlationMatrix $correlationMatrix');

    int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
    int attributeIndex2 =
        fluCa.transpose(correlationMatrix)[0].indexOf(attribute2);
    debugPrint('correlationMatrix[attributeIndex1][attributeIndex2] ${correlationMatrix[attributeIndex1][attributeIndex2]}');
    debugPrint('correlationMatrix[attributeIndex2][attributeIndex1] ${correlationMatrix[attributeIndex2][attributeIndex1]}');
    debugPrint('0');

    // min max is needed as correlation matrix is only half filled and row<column
    _correlationCoefficient =
        correlationMatrix[min(attributeIndex1,attributeIndex2)][max(attributeIndex1,attributeIndex2)];
    return _correlationCoefficient;
  }

  Widget statisticWithIcons() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
        children: <Widget>[
          Row(children: [
            Container(
                //padding: const EdgeInsets.all(5.0),
                decoration: _statisticsBoxDecoration(),
                child: SizedBox(
                  width: 117,
                  height: 12,
                  child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 9, child: Container(color: Colors.teal)),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                        ],
                      )),
                )),
            Text(' relationship', textScaleFactor: 1.3),
          ]),
          SizedBox(height: 10),
          Row(children: [
            Icon(Icons.star),
            Icon(Icons.star),
            Icon(Icons.star),
            Icon(Icons.star),
            Icon(Icons.star_half),
            Text(' confidence', textScaleFactor: 1.3),
          ]),
        ]);
  }

  BoxDecoration _statisticsBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.5),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //         <--- border radius here
          ),
    );
  }
}
