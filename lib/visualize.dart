import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Visualize extends StatefulWidget {
  final Widget child;

  Visualize({Key key, this.child}) : super(key: key);

  _VisualizeState createState() => _VisualizeState();
}

class _VisualizeState extends State<Visualize> {
  List<charts.Series<Value, int>> _seriesLineData;

/*  _getDBData() {
    List<Entry> entryList;

    this.entryList[position].value
  }*/


  _generateData() {
    var linevaluedata = [
      new Value(0, 45),
      new Value(1, 56),
      new Value(2, 55),
      new Value(3, 60),
      new Value(4, 61),
      new Value(5, 70),
    ];
    var linevaluedata1 = [
      new Value(0, 35),
      new Value(1, 46),
      new Value(2, 45),
      new Value(3, 50),
      new Value(4, 51),
      new Value(5, 60),
    ];

    var linevaluedata2 = [
      new Value(0, 20),
      new Value(1, 24),
      new Value(2, 25),
      new Value(3, 40),
      new Value(4, 45),
      new Value(5, 60),
    ];
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linevaluedata,
        domainFn: (Value value, _) => value.timeval,
        measureFn: (Value value, _) => value.valueval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: linevaluedata1,
        domainFn: (Value value, _) => value.timeval,
        measureFn: (Value value, _) => value.valueval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linevaluedata2,
        domainFn: (Value value, _) => value.timeval,
        measureFn: (Value value, _) => value.valueval,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Value, int>>();
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