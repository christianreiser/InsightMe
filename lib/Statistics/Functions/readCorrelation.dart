import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as fluCa;
import 'package:flutter_charts/flutter_charts.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:path_provider/path_provider.dart';

Future<num> readCorrelationCoefficient(attribute1, attribute2) async {
  var correlationMatrix = await readCorrelationMatrix();

  int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
  int attributeIndex2 =
      fluCa.transpose(correlationMatrix)[0].indexOf(attribute2);

  // min max is needed as correlation matrix is only half filled and row<column
  final num _correlationCoefficient =
      correlationMatrix[min(attributeIndex1, attributeIndex2)]
          [max(attributeIndex1, attributeIndex2)];
  return _correlationCoefficient;
}

Future<List<List>> readCorrelationMatrix() async {
  final directory = await getApplicationDocumentsDirectory();
  final input = new File(directory.path + "/correlation_matrix.csv").openRead();
  final correlationMatrix = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();
  debugPrint('got correlationMatrix $correlationMatrix');
  return correlationMatrix;
}

todoFindNameFunction() async {
  //todo refactoring

  debugPrint('inside todoFindNameFunction');
  final String selectedAttribute1 = 'All';
  final String selectedAttribute2 = 'All';
  final correlationMatrix = await readCorrelationMatrix();
  debugPrint('correlationMatrix:: $correlationMatrix');
  correlationMatrix.removeAt(0);

  /// remove label row
  debugPrint('correlationMatrix:: $correlationMatrix');
  var correlationMatrixT = List.from(transpose(
      correlationMatrix)); // transpose to make remove label column work
  correlationMatrixT.removeAt(0); // remove label column
  debugPrint('correlationMatrixT:: $correlationMatrixT');

  /// convert list dynamic with 'null's to list double
  int rows = correlationMatrixT.length;
  int columns = correlationMatrixT[0].length;
  debugPrint('correlationMatrixT.l:: ${correlationMatrixT.length}');
  debugPrint('correlationMatrixT.dl:: ${correlationMatrixT[0].length}');
  List<List<double>> doubleList =
      List.generate(rows, (i) => List(columns), growable: false);
  for (int row = 0; row < correlationMatrixT.length; row++) {
    for (int column = 0; column < correlationMatrixT[0].length; column++) {
      if (correlationMatrixT[row][column] == 'null') {
        correlationMatrixT[row][column] = 0.0;
      }
      doubleList[row][column] = correlationMatrixT[row][column];
    }
  }
  print('doubleList $doubleList');

  /// absMax from matrix
  final matrix1 = Matrix.fromList(doubleList);
  final maxValue = matrix1.max();
  final minValue = matrix1.min();
  final List<double> maxMin = [maxValue, minValue];
  final double maxAbs = maxMin.reduce(max);
  debugPrint('maxAbs $maxAbs');

  /// if both selectedAttributes are on all
  if (selectedAttribute1 == 'All' && selectedAttribute2 == 'All') {
    debugPrint('inside All All');

    //debugPrint('correlationMatrix.reduce(max): ${correlationMatrix.reduce(max)}');
    //final minValue = matrix.min();
    //debugPrint('minValue $minValue');
  }

  /// if one selectedAttributes is on all
  else if ((selectedAttribute1 == 'All' && selectedAttribute2 != 'All') ||
      (selectedAttribute1 != 'All' && selectedAttribute2 == 'All')) {
  }

  /// if no selectedAttributes is on all
  else if (selectedAttribute1 != 'All' && selectedAttribute2 != 'All') {
  } else {
    debugPrint('ERROR unhandled selected attribute combination');
  }
}
