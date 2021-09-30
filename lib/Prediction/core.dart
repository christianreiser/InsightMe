import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget scaledBar(start, end, scaleBounds, color, height, textBeforeBar, arrow) {
  const int accuracyFactor = 1000;
  if (start > end) {
    int tmp = start;
    start = end;
    end = tmp;
  }
  final int startCorrected =
      ((start - scaleBounds[0]) * accuracyFactor).toInt();
  final int endCorrected = ((end - scaleBounds[0]) * accuracyFactor).toInt();
  return Row(children: [
    /// left empty space
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
          child: arrow == true
              ? color == const Color(0xFF7DD181) //const Color(0xFF9dbc95)
                  ? FittedBox(child: Icon(Icons.arrow_forward_sharp))
                  : color == const Color(0xFFE15554) //const Color(0xFF855e78)
                      ? FittedBox(child: Icon(Icons.arrow_back_sharp))
                      : Container()
              : Container(),
        )),

    /// right empty space
    Expanded(
      flex: (((scaleBounds[1] - scaleBounds[0] + 1) * accuracyFactor).toInt() -
          accuracyFactor -
          endCorrected),
      child: Container(height: height),
    ),
  ]);
}

const kindaGreen = Color(0xFF7DD181);
const kindaRed = Color(0xFFE15554);
