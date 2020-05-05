import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sqflite/sqflite.dart';
import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


class VisChr extends StatefulWidget {
  VisChr({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VisChrState createState() => _VisChrState();
}

class _VisChrState extends State<VisChr> {
  DatabaseHelperEntry helperEntry = DatabaseHelperEntry();

  List<Entry> filteredEntryList;
  int countEntryFiltered = 0;
  int countAttribute = 0 ;

  @override
  Widget build(BuildContext context) {
    if (filteredEntryList == null) {
      filteredEntryList = List<Entry>();
    }
    return SingleChildScrollView(
        child:
/*          Flexible(
            child: RefreshIndicator(
              //key: refreshKey,
              onRefresh: () async {
                _updateFilteredEntryListView();
              },
              child: _getFilteredEntryListView(),
            ),
          ),*/
            mychart1Items('Title', 'priceval','subtitle'),

    );// This trailing comma makes auto-formatting nicer for build methods.
  }

// ENTRY LIST
  ListView _getFilteredEntryListView() {
    return ListView.builder(
      itemCount: countEntryFiltered,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            // Label
            title: Text(this.filteredEntryList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),

            // Value
            subtitle: Text(this.filteredEntryList[position].value),


            // Edit ICON
            trailing: Text(this.filteredEntryList[position].date),

            // onTAP TO EDIT
            onTap: () {
              debugPrint("tabbed");
              //var filteredQueryResult = helperEntry.getFilteredEntryList('Productivity'); //// TODO get from UI
              debugPrint("\nprint: ${this.filteredEntryList[position].title}\n");

            },
          ),
        );
      },
    );
  }

  List<double> getValueList() {
    List<double>  valueList = [];
    List<String>  dateList = [];
    _updateFilteredEntryListView();
    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    for (int i = 0; i < countEntryFiltered; i++) {
      valueList.add(double.parse(this.filteredEntryList[i].value));
      // TODO parsing to date type needed?
      dateList.add((this.filteredEntryList[i].date));
    }
    print('valueList: $valueList');
    print('data $data');
    return valueList;
  }


  List<double>  data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0]; // replace with db data


  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();
  List<Attribute> attributeList;

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





  //////////////////////
  Widget mychart1Items(String title, String priceVal,String subtitle) {
    return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(1.0),
        child: Sparkline(
          data: getValueList(), //getValueList(), // TODO give pointer
          //lineColor: Color(0xffff6101),
          //pointsMode: PointsMode.all,
          //pointSize: 8.0,

        ),
      ),
      Text('$data'),
      Text('${getValueList()}'),
    ]
    );
  }
}





////////////////////////

class Visualize extends StatefulWidget {
  final Widget child;

  Visualize({Key key, this.child}) : super(key: key);

  _VisualizeState createState() => _VisualizeState();
}

class _VisualizeState extends State<Visualize> {

  List<double>  valueList = [];
  List<String>  dateList = [];
  List<Entry> filteredEntryList;
  int countEntryFiltered = 0;
  DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();
  List<Attribute> attributeList;

  DatabaseHelperEntry databaseHelperEntry = DatabaseHelperEntry();



/*  // updateEntryListView depends on state
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
  }*/





  List<charts.Series<double, int>> _seriesLineData;

  _generateData() {
    if (filteredEntryList == null) {
      filteredEntryList = List<Entry>();
    }


    // TODO unnecessarily complicated from db to chart:
    // TODO from map(db) to list(helper) to other list(here)
    for (int i = 0; i < countEntryFiltered; i++) {
      valueList.add(double.parse(this.filteredEntryList[i].value));
      // TODO parsing to date type needed?
      dateList.add((this.filteredEntryList[i].date));
    }
    print(valueList);





/*    var lineValueData = [
      new Value(0, 45),
      new Value(1, 56),
      new Value(2, 55),
      new Value(3, 60),
      new Value(4, 61),
      new Value(5, 70),
    ];
    var lineValueData1 = [
      new Value(0, 35),
      new Value(1, 46),
      new Value(2, 45),
      new Value(3, 50),
      new Value(4, 51),
      new Value(5, 60),
    ];

    var lineValueData2 = [
      new Value(0, 20),
      new Value(1, 24),
      new Value(2, 25),
      new Value(3, 40),
      new Value(4, 45),
      new Value(5, 60),
    ];*/
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: valueList,
        domainFn: (double double, _) => 2, // chr: TODO: axis scaling?
        measureFn: (double double, _) => 25,
      ),
    );
/*    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: lineValueData1,
        domainFn: (Value value, _) => value.timeval,
        measureFn: (Value value, _) => value.valueval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: lineValueData2,
        domainFn: (Value value, _) => value.timeval,
        measureFn: (Value value, _) => value.valueval,
      ),
    );*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<double, int>>();
    //List<charts.Series<double, String>> _seriesLineData;

    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Timeline',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
            Expanded(
              child: charts.LineChart(
                  _seriesLineData,
                  defaultRenderer: new charts.LineRendererConfig(
                      includeArea: true, stacked: true),
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.ChartTitle('Time',
                        behaviorPosition: charts.BehaviorPosition.bottom,
                        titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                    new charts.ChartTitle('Value',
                        behaviorPosition: charts.BehaviorPosition.start,
                        titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                    new charts.ChartTitle('Labels',
                      behaviorPosition: charts.BehaviorPosition.end,
                      titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                    )
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pollution {
  String place;
  int time;
  int quantity;

  Pollution(this.time, this.place, this.quantity);
}



class Value {
  int timeval;
  int valueval;

  Value(this.timeval, this.valueval);
}