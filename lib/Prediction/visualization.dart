import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PredictionRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final num predictedMood = 7.0;
    final List<double> scaleBounds = [1, 9];
    final List<double> oneStdDev = [6, 8];
    final List<double> twoStdDev = [5, 9];

    BoxDecoration _predictionBoxDecoration() {
      return BoxDecoration(
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(1.0)),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment(0.8, 0.0),
          // 10% of the width, so there are ten blinds.
          colors: const <Color>[
            Colors.red,
            Colors.yellow,
            Colors.green
          ], // red to yellow
        ),
      );
    }

    Widget _scaledBar(start, end, scaleBounds, color, height, textBeforeBar) {
      final int startCorrected = ((start - scaleBounds[0]) * 10).toInt();
      print('$start $end $scaleBounds');

      final int endCorrected = ((end - scaleBounds[0]) * 10).toInt();
      print('$startCorrected $endCorrected $scaleBounds');
      return Row(children: [
        /// empty space
        Expanded(
            flex: (startCorrected),
            child: Container(
              alignment: Alignment.centerLeft,
              height: height,
              child: Row(
                children: [
                  SizedBox(width: 2),
                  Text(textBeforeBar),
                ],
              ),
            )),

        /// prediction
        Expanded(
            flex: (endCorrected - startCorrected),
            child: Container(
              height: height,
              color: color,
              child: color == Colors.green
                  ? FittedBox(child: Icon(Icons.arrow_forward_sharp))
                  : color == Colors.red
                      ? FittedBox(child: Icon(Icons.arrow_back_sharp))
                      : Container(),
            )),

        /// empty space
        Expanded(
          flex: ((scaleBounds[1] * 10).toInt() - 10 - endCorrected),
          child: Container(height: height),
        ),
      ]);
    }

    Container _gradientColorScale() {
      final double startPredictedMood = predictedMood - 0.1;
      final double endPredictedMood = (predictedMood + 0.1);
      return Container(
        height: 30.0,
        decoration: _predictionBoxDecoration(),
        child: FractionallySizedBox(
            widthFactor: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _scaledBar(startPredictedMood, endPredictedMood, scaleBounds,
                    Colors.blue, 8.0, ''),
                _scaledBar(oneStdDev[0], oneStdDev[1], scaleBounds, Colors.blue,
                    6.0, ''),
                _scaledBar(twoStdDev[0], twoStdDev[1], scaleBounds, Colors.blue,
                    3.0, ''),
              ],
            )),
      );
    }

    Widget _biDirectionalGanttChart(labelNames) {
      return Column(children: [
        _scaledBar(5, 6.1, scaleBounds, Colors.green, 16.0, 'Mood yesterday'),
        _scaledBar(6.1, 6.8, scaleBounds, Colors.green, 16.0, 'Humidity'),
        _scaledBar(6.3, 6.8, scaleBounds, Colors.red, 16.0, 'Body weight'),
        _scaledBar(6.3, 6.7, scaleBounds, Colors.green, 16.0, 'Running'),
        _scaledBar(6.7, 7.1, scaleBounds, Colors.green, 16.0, 'Steps'),
        _scaledBar(7.0, 7.1, scaleBounds, Colors.red, 16.0, 'CO2 level'),
      ]);
    }

    Widget _scaleTile(num number) {
      return Column(
        children: [
          Container(color: Colors.black, height: 5, width: 1),
          Text('$number')
        ],
      );
    }

    _numericScale() {
      var text = new List<int>.generate(scaleBounds[1].floor().toInt(), (i) {
        return i + 1;
      });
      return Container(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (var i in text) _scaleTile(i)],
          ),
        ),
      );
    }

    List<String> labelNames = [
      'mood yesterday',
      'humidity indoor',
      'body weight'
    ];

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(1, 8, 8, 8),
                child: Text(
                    'Mood prediction for today with confidence interval:')),
            _biDirectionalGanttChart(labelNames),
            _gradientColorScale(),
            _numericScale(),
          ],
        ),
      ),
    );
  }
}
