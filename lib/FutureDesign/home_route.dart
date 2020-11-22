import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeRoute extends StatelessWidget {
  static Map<DateTime, double> dateTimeMap1 = {
    DateTime(1): 1,
    DateTime(2): 3,
    DateTime(3): 3,
    DateTime(4): 4,
    DateTime(5): 3
  };
  static Map<DateTime, double> dateTimeMap2 = {
    DateTime(1): 2,
    DateTime(2): 5,
    DateTime(3): 4,
    DateTime(4): 6,
    DateTime(5): 3
  };

  static LineChart chart = LineChart.fromDateTimeMaps(
      [dateTimeMap1, dateTimeMap2],
      [Colors.green, Colors.blue],
      ['time with friends', 'mood'], // chart label name
      tapTextFontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      // ChangeNotifierProvider for state management
      child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch, // max chart width
          children: <Widget>[
            //TITLE
            Text(
              ' Insights',
              style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),
            Text('You have a better day when you spend more time with friends'),
            //todo back in
            SizedBox(height: 15),
            statistics(context, -0.6, 0.02),
            SizedBox(height: 25),
            Expanded(
              child: AnimatedLineChart(chart),
            ),
          ]),
    ); // type lineChart
  }

  Widget statistics(context, _correlationCoefficient, _pValue) {
    //final double _correlationCoefficient = -0.5;
    final int _absIntCorrCoeff = (_correlationCoefficient.abs() * 100).toInt();
    debugPrint('_absIntCorrCoeff: $_absIntCorrCoeff');
    //final num _pValue = 0.05;
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // stretch for max chart width
        children: <Widget>[
          Row(children: [
            Container(
              /*
              * correlation / relationship bar
              * */
              //padding: const EdgeInsets.all(5.0),
              decoration: _statisticsBoxDecoration(),
              child: SizedBox(
                width: 117,
                height: 12,
                child: SizedBox(
                  width: 5,
                  height: 5,
                  child: Row(children: [
                    Expanded(
                        flex: (_absIntCorrCoeff),
                        child: Container(color: Colors.teal)),
                    Expanded(
                      flex: (100 - _absIntCorrCoeff),
                      child: Container(),
                    ),
                  ]),
                ),
              ),
            ),
            Text(' relationship', textScaleFactor: 1.3),
            FlatButton(
              /* info note for correlation coefficient */
              // to reduce height of relationship info? button
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Icon(Icons.info, color: Colors.grey),
              onPressed: () {
                debugPrint('info pressed');
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Pearson correlation coefficient = $_correlationCoefficient.'
                          ' Bar shows the absolute value.'),
                ));
              },
            )
          ]),
//          Row(children: [
//            Icon(Icons.star),
//            Icon(Icons.star),
//            Icon(Icons.star),
//            Icon(Icons.star),
//            Icon(Icons.star_half),
//            Text(' confidence', textScaleFactor: 1.3),
//          ]),
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
//}
