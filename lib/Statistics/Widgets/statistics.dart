import 'package:flutter/material.dart';

/// correlation coefficient and p-value widgets



Widget statistics(context, corrCoeff, _pValue) {
  /// correlation coefficient and p-value widgets
  return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // stretch for max chart width
      children: <Widget>[
        Row(children: [
          _correlationBar(corrCoeff),
          Text(' correlation ', textScaleFactor: 1.3),
          TextButton(
            /* info note for correlation coefficient */
            // to reduce height of correlation info button
            child: Icon(Icons.info, color: Colors.grey),
            onPressed: () {
              debugPrint('info pressed');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Pearson correlation coefficient = $corrCoeff.'
                    ' Bar shows the absolute value.'),
              ));
            },
          )
        ]),

        /// confidence
        // todo feature: p-value
//         Row(children: [
//           _confidenceStars(_pValue),
//           Text(' confidence', textScaleFactor: 1.3),
//           TextButton(
//             /* info note for p-Value */
//             // to reduce height of correlation info button
//             child: Icon(Icons.info, color: Colors.grey),
//             onPressed: () {
//               debugPrint('info pressed');
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text('p-Value = $_pValue.'),
//               ));
//             },
//           )
//         ]),
      ]);
}

Container _correlationBar(_correlationCoefficient) {
  /// input: _correlationCoefficient
  /// output: Widget: _correlationBar

  final int _absIntCorrCoeff = (_correlationCoefficient.abs() * 100).toInt();
  debugPrint('_absIntCorrCoeff: $_absIntCorrCoeff');

  return Container(
    /// correlation / correlation bar
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
              child: Container(color: _barColor(_correlationCoefficient))),
          Expanded(
            flex: (100 - _absIntCorrCoeff),
            child: Container(),
          ),
        ]),
      ),
    ),
  );
}

Color _barColor(_correlationCoefficient) {
  Color barColor;
  if (_correlationCoefficient >= 0) {
    barColor = Colors.teal;
  } else {
    barColor = Colors.red;
  }
  return barColor;
}

Row _confidenceStars(_pValue) {
  /// from _Value to confidence stars:
  ///
  /// p-Value   | stars
  /// -----------------
  /// 0.50-0.45 | 0.5
  /// 0.45-0.40 | 1.0
  /// 0.40-0.35 | 1.5
  /// 0.35-0.30 | 2.0
  /// 0.30-0.25 | 2.5
  /// 0.25-0.20 | 3.0
  /// 0.20-0.15 | 3.5
  /// 0.15-0.10 | 4.0
  /// 0.10-0.05 | 4.5
  /// 0.05-0.00 | 5.0
  /// 1.00-0.50 | 0.0

  if (_pValue <= 0.5 && _pValue > 0.45) {
    return Row(children: [
      Icon(Icons.star_half),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.45 && _pValue > 0.40) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.4 && _pValue > 0.35) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star_half),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.35 && _pValue > 0.3) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.3 && _pValue > 0.25) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star_half),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.25 && _pValue > 0.2) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star_border),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.2 && _pValue > 0.15) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star_half),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.15 && _pValue > 0.1) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star_border),
    ]);
  } else if (_pValue <= 0.1 && _pValue > 0.05) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star_half),
    ]);
  } else if (_pValue <= 0.05) {
    return Row(children: [
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
      Icon(Icons.star),
    ]);
  } else {
    ///_pValue > 0.5
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
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );
}
