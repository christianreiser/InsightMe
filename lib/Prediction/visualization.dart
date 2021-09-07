import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PredictionRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    Container _gradientColorScale() {
      return Container(
        height: 30.0,
        decoration: _predictionBoxDecoration(),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(children: [
            /// empty space
            Expanded(flex: (19), child: Container(height: 12)),

            /// prediction interval
            Expanded(
                flex: (3), child: Container(height: 5, color: Colors.blue)),

            /// prediction
            Expanded(
                flex: (1), child: Container(height: 12, color: Colors.blue)),

            /// PI
            Expanded(
                flex: (3), child: Container(height: 5, color: Colors.blue)),

            /// empty space
            Expanded(
              flex: (10),
              child: Container(height: 12),
            ),
          ]),
        ),
      );
    }

    Widget _biDirectionalGanttChart(labelNames) {
      return Column(children: [
        Row(
          children: [
            Container(
              width: 195,
              color: Colors.black12,
              height: 18,
              child: Text(labelNames[0]),
            ),
            Container(width: 20, color: Colors.red, height: 18),
            Container(width: 10, color: Colors.black12, height: 18),
          ],
        )
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
      return Container(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _scaleTile(1),
              _scaleTile(2),
              _scaleTile(3),
              _scaleTile(4),
              _scaleTile(5),
              _scaleTile(6),
              _scaleTile(7),
              _scaleTile(8),
              _scaleTile(9),
            ],
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
            _gradientColorScale(),
            _numericScale(),
            _biDirectionalGanttChart(labelNames),
          ],
        ),
      ),
    );
  }
}
