import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core.dart';

BoxDecoration _predictionBoxDecoration() {
  return BoxDecoration(
    border: Border.all(width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(1.0)),
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment(0.8, 0.0),
      // 10% of the width, so there are ten blinds.
      colors: const <Color>[
        const Color(0xFFE15554),
        const Color(0xFFffd97d),
        const Color(0xFF7DD181)
      ], // red to yellow
    ),
  );
}

Widget gradientColorScale(predictions) {
  return Stack(
    children: <Widget>[
      Image(
        image: AssetImage('assets/tmp_phone_io/tokyo_crop.png'),
        height: 30,
      ),
      Container(
        height: 30.0,
        decoration: _predictionBoxDecoration(),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Stack(
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                scaledBar(
                    predictions.prediction - 0.1,
                    predictions.prediction + 0.1,
                    predictions.scaleBounds,
                    Colors.black,
                    12.0,
                    '',
                    false),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                scaledBar(
                    predictions.prediction - predictions.ci95,
                    predictions.prediction + predictions.ci95,
                    predictions.scaleBounds,
                    Colors.black,
                    2.0,
                    '',
                    false),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                scaledBar(
                    predictions.prediction - predictions.ci95,
                    predictions.prediction - predictions.ci95 + 0.05,
                    predictions.scaleBounds,
                    Colors.black,
                    12.0,
                    '',
                    false),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                scaledBar(
                    predictions.prediction + predictions.ci95 - 0.05,
                    predictions.prediction + predictions.ci95,
                    predictions.scaleBounds,
                    Colors.black,
                    12.0,
                    '',
                    false),
              ])
            ],
          ),
        ),
      ),
    ],
  );
}

numericScale(scaleBounds) {
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

Widget _scaleTile(num number) {
  return Column(
    children: [
      Container(color: Colors.black, height: 5, width: 1),
      Text('$number')
    ],
  );
}
