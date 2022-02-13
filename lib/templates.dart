import 'package:flutter/material.dart';

import 'Prediction/visualization.dart';
import 'Statistics/Functions/readCorrelation.dart';

Widget futureBuilder() { /// don't copy this line
  /// v v v v v
  return FutureBuilder(
    future: readCorrelationCoefficients(''), /// modify1
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        final PredictionAutogenerated? snapshotData = snapshot.data as PredictionAutogenerated?; /// modify2
        print('snapshotData:,$snapshotData');
        return Container(); /// modify1
      } else {
        return CircularProgressIndicator();
      } // end else
    }, // end builder
  );
  /// ^ ^ ^ ^ ^ ^ ^
} // end function
