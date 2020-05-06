//import 'package:example/fake_chart_series.dart';
//import 'package:fl_animated_linechart/chart/area_line_chart.dart';
//import 'package:fl_animated_linechart/common/pair.dart';
//import 'package:fl_animated_linechart/fl_animated_linechart.dart';
//import 'package:flutter/material.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'fl_animated_chart demo'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> with FakeChartSeries {
//  int chartIndex = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    Map<DateTime, double> line1 = createLine2();
//    Map<DateTime, double> line2 = createLine2_2();
//
//    LineChart chart;
//
//    if (chartIndex == 0) {
//      chart = LineChart.fromDateTimeMaps(
//          [line1, line2], [Colors.green, Colors.blue], ['C', 'C'],
//          tapTextFontWeight: FontWeight.w400);
//    } else if (chartIndex == 1) {
//      chart = LineChart.fromDateTimeMaps(
//          [createLineAlmostSaveValues()], [Colors.green], ['C'],
//          tapTextFontWeight: FontWeight.w400);
//    } else {
//      chart = AreaLineChart.fromDateTimeMaps(
//          [line1], [Colors.red.shade900], ['C'],
//          gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);
//    }
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Container(
//        child: Column(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: [
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    FlatButton(
//                      shape: RoundedRectangleBorder(
//                          side: BorderSide(color: Colors.black45),
//                          borderRadius: BorderRadius.all(Radius.circular(3))),
//                      child: Text(
//                        'LineChart',
//                        style: TextStyle(
//                            color: chartIndex == 0
//                                ? Colors.black
//                                : Colors.black12),
//                      ),
//                      onPressed: () {
//                        setState(() {
//                          chartIndex = 0;
//                        });
//                      },
//                    ),
//                    FlatButton(
//                      shape: RoundedRectangleBorder(
//                          side: BorderSide(color: Colors.black45),
//                          borderRadius: BorderRadius.all(Radius.circular(3))),
//                      child: Text('LineChart2',
//                          style: TextStyle(
//                              color: chartIndex == 1
//                                  ? Colors.black
//                                  : Colors.black12)),
//                      onPressed: () {
//                        setState(() {
//                          chartIndex = 1;
//                        });
//                      },
//                    ),
//                    FlatButton(
//                      shape: RoundedRectangleBorder(
//                          side: BorderSide(color: Colors.black45),
//                          borderRadius: BorderRadius.all(Radius.circular(3))),
//                      child: Text('AreaChart',
//                          style: TextStyle(
//                              color: chartIndex == 2
//                                  ? Colors.black
//                                  : Colors.black12)),
//                      onPressed: () {
//                        setState(() {
//                          chartIndex = 2;
//                        });
//                      },
//                    ),
//                  ],
//                ),
//              ),
//              Expanded(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: AnimatedLineChart(
//                      chart,
//                      key: UniqueKey(),
//                    ), //Unique key to force animations
//                  )),
//              SizedBox(width: 200, height: 50, child: Text('')),
//            ]),
//      ),
//    );
//  }
//}






















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
  DatabaseHelperEntry helperEntry = DatabaseHelperEntry();

  List<Entry> filteredEntryList;
  List<Map<String, dynamic>> filteredEntryMapList;
  int countEntryFiltered = 0;
  int countAttribute = 0 ;




  @override
  Widget build(BuildContext context) {
/*    print('debug0');
    if (filteredEntryList == null) {
      filteredEntryList = List<Entry>();
    }

    // get data from DB
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    // TODO refactoring
    List<double>  valueList = [];
    List<DateTime>  dateList = [];
    print('dateList: $dateList');
    print('countEntryFiltered: $countEntryFiltered');

    for (int i = 0; i < countEntryFiltered; i++) {
      valueList.add(double.parse(this.filteredEntryList[i].value));
      // TODO parsing to date type needed?
      dateList.add(DateTime.parse((this.filteredEntryList[i].date)));
    }
    print('debug1');

    // update if empty
    if (valueList.isEmpty) {
      _updateFilteredEntryListView();
    }
    print('debug2');

    // create the lineCharts
    Map<DateTime, double> dateTimeMap;
    debugPrint('debug2.1');
    print('dateList.length $dateTimeMap');
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

    debugPrint('debug4');*/

    return SingleChildScrollView(
      child:
      getChart(),
//            Column(
//                mainAxisSize: MainAxisSize.max,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: [
//                  Expanded(
//                    //child: AnimatedLineChart(chart),
//                    child: Text('debug chart'),
//                  ),// type lineChart
//                ]
//            ),


    );// This trailing comma makes auto-formatting nicer for build methods.
  }






  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();
  List<Attribute> attributeList;
  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();


//  LineChart getLineChart() {
//    List<double>  valueList = [];
//    List<DateTime>  dateList = [];
//    // TODO unnecessarily complicated from db to chart:
//    // TODO from map(db) to list(helper) to other list(here)
//    for (int i = 0; i < countEntryFiltered; i++) {
//      valueList.add(double.parse(this.filteredEntryList[i].value));
//      // TODO parsing to date type needed?
//      debugPrint('1');
//      dateList.add(DateTime.parse((this.filteredEntryList[i].date)));
//      debugPrint('2');
//
//    }
//
//    // update if empty
//    if (valueList.isEmpty) {
//      _updateFilteredEntryListView();
//    }
////////////////////
//    // create the lineCharts
//    Map<DateTime, double> dateTimeMap;
//    for (var ele in valueList) {
//      dateTimeMap[dateList[ele.round()]] = valueList[ele.round()];
//      debugPrint('dateTimeMap $dateTimeMap');
//      debugPrint('ele $ele');
//    }
//
//    LineChart chart;
//    chart = LineChart.fromDateTimeMaps(
//        [dateTimeMap, dateTimeMap], [Colors.green, Colors.blue], ['C', 'C'], // TODO dateTimeMap change attribute
//        tapTextFontWeight: FontWeight.w400);
//
//    return chart;
//  }



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


//  // updateEntryMapListView depends on state
//  List<Map<String, dynamic>> _updateFilteredEntryMapListView() {
//    final Future<Database> dbFuture = databaseHelperEntry.initializeDatabase();
//    dbFuture.then((database) {
//      Future<List<Map<String, dynamic>>> entryMapListFuture = databaseHelperEntry.getFilteredEntryMapList('Productivity');
//      List<Map<String, dynamic>> valueMapListFuture = entryMapListFuture.value
//      entryMapListFuture.then((filteredEntryMapList) {
//        setState(() {
//          this.filteredEntryMapList = filteredEntryMapList;
//          this.countEntryFiltered = filteredEntryMapList.length;
//
//        });
//      });
//    });
//    return filteredEntryMapList;
//  }



  // Chart

  Widget getChart() {
    return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.0),
//        child: Sparkline( // TODO no error if data is still empty
//          data: getValueList(), //getValueList(), // TODO give pointer
//          //lineColor: Color(0xffff6101),
//          //pointsMode: PointsMode.all,
//          //pointSize: 8.0,
//
//        ),
          ),
          Text('{getValueList()}'),

        ]
    );
  }
}