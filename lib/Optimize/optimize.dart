import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Optimize extends StatelessWidget {
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
            statistics(context, -0.6, 0.07),
            SizedBox(height: 25),
            Expanded(
              child: AnimatedLineChart(chart),
            ),
          ]),
    ); // type lineChart
  }

  Widget statistics(context, _correlationCoefficient, _pValue) {
    //final num _pValue = 0.07;
    //final num _correlationCoefficient = 0.87;

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // stretch for max chart width
        children: <Widget>[
          Row(children: [
            _correlationBar(_correlationCoefficient),
            Text(' correlation ', textScaleFactor: 1.3),
            FlatButton(
              /* info note for correlation coefficient */
              // to reduce height of correlation info button
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
          Row(children: [
            _confidenceStars(_pValue),
            Text(' confidence', textScaleFactor: 1.3),
            FlatButton(
              /* info note for p-Value */
              // to reduce height of correlation info button
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Icon(Icons.info, color: Colors.grey),
              onPressed: () {
                debugPrint('info pressed');
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('p-Value = $_pValue.'),
                ));
              },
            )
          ]),
        ]);
  }


  Container _correlationBar(_correlationCoefficient) {
    /*
    * input: _correlationCoefficient
    * output: Widget: _correlationBar
    * */

    final int _absIntCorrCoeff = (_correlationCoefficient.abs() * 100).toInt();
    debugPrint('_absIntCorrCoeff: $_absIntCorrCoeff');

    return Container(
      /*
              * correlation / correlation bar
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
    );
  }



  Row _confidenceStars(_pValue) {
    /*
    * from _Value to confidence stars:
    *
    * p-Value   | stars
    * -----------------
    * 0.50-0.45 | 0.5
    * 0.45-0.40 | 1.0
    * 0.40-0.35 | 1.5
    * 0.35-0.30 | 2.0
    * 0.30-0.25 | 2.5
    * 0.25-0.20 | 3.0
    * 0.20-0.15 | 3.5
    * 0.15-0.10 | 4.0
    * 0.10-0.05 | 4.5
    * 0.05-0.00 | 5.0
    * 1.00-0.50 | 0.0
    * */

    if (_pValue <= 0.5 && _pValue > 0.45) {
      return Row(children: [
        Icon(Icons.star_half),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.45 && _pValue > 0.40) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.4 && _pValue > 0.35) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.35 && _pValue > 0.3) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.3 && _pValue > 0.25) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.25 && _pValue > 0.2) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.2 && _pValue > 0.15) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.15 && _pValue > 0.1) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_border),
      ]);
    }
    else if (_pValue <= 0.1 && _pValue > 0.05) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half),
      ]);
    }
    else if (_pValue <= 0.05) {
      return Row(children: [
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
      ]);
    }
    else { //_pValue > 0.5
      return Row(children: [
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
        Icon(Icons.star_border),
      ]);
    }
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
