import 'dart:convert' show utf8;
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insightme/Core/functions/misc.dart';
import 'package:path_provider/path_provider.dart';

Future<num> readCorrelationCoefficient(attribute1, attribute2) async {
  //debugPrint('attribute1: $attribute1, attribute2: $attribute2');
  var correlationMatrix = await readCorrelationMatrix();
  int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
  //debugPrint('2');
  int attributeIndex2 = transposeChr(correlationMatrix)[0].indexOf(attribute2);
  debugPrint('correlationMatrix[attributeIndex1][attributeIndex2]: ${correlationMatrix[attributeIndex1][attributeIndex2]}');
  final num correlationCoefficient = correlationMatrix[attributeIndex1][attributeIndex2];
  return correlationCoefficient;
}

Future<List<dynamic>> readCorrelationCoefficientsOfOneAttribute(
    attribute) async {
  print('attribute::: $attribute');
  var correlationMatrix = await readCorrelationMatrix();

  int attributeIndex = correlationMatrix[0].indexOf(attribute);
  print('attributeIndex $attributeIndex');
  debugPrint(
      'correlationMatrix[attributeIndex]: ${correlationMatrix[attributeIndex]}');
  var correlationCoefficientsOfOneAttribute = correlationMatrix[attributeIndex];
  correlationCoefficientsOfOneAttribute.removeAt(0);
  return correlationCoefficientsOfOneAttribute;
}

// handleOneSpecificOneAll(
//     selectedAttribute, correlationCoefficientsOfOneAttribute) async {
//
// }

List<dynamic> convertNullTo0(dynamicListWithNulls) {
  for (int i = 0; i < dynamicListWithNulls.length; i++) {
    if (dynamicListWithNulls[i] == 'null') {
      dynamicListWithNulls[i] = 0;
    }
  }
  return dynamicListWithNulls;
}

Future<List<List>> readCorrelationMatrix() async {
  final directory = await getApplicationDocumentsDirectory();
  final input = new File(directory.path + "/correlation_matrix.csv").openRead();
  final correlationMatrix = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();
  // debugPrint('got correlationMatrix: $correlationMatrix');
  return correlationMatrix;
}

listArgExtreme(numList) {
  //final vector = Vector.fromList(numList);
  final maxValue = numList.reduce((curr, next) => curr > next ? curr : next);
  final minValue = numList.reduce((curr, next) => curr < next ? curr : next);
  print('minValue $minValue');
  double extreme;
  if (maxValue >= -minValue) {
    extreme = maxValue;
  } else if (maxValue < -minValue) {
    extreme = minValue;
  } else {
    debugPrint('UNHANDLED EXCEPTION: EXTREME-VALUE');
  }

  /// get extremest index
  print('numList; $numList');
  print('numList.runtimeType ${numList.runtimeType}');

  //List<dynamic> numListT = [0.0, 0.01, 0.02];
  final int argExtreme = numList.indexWhere((element) => element == extreme);

  debugPrint('argExtreme $argExtreme');
  return argExtreme;
}

// Future<String> sortedAttributeList(
//     selectedAttribute1, selectedAttribute2) async {
//   // readCorrelationMatrix
//   List<List<dynamic>> dynamicLabeledCorrelationMatrix =
//       await readCorrelationMatrix();
//   debugPrint(
//       'dynamicTwiceLabeledCorrelationMatrix:good: $dynamicLabeledCorrelationMatrix');
//
//   // separate labels
//   final List<dynamic> labels = dynamicLabeledCorrelationMatrix.removeAt(0);
//   debugPrint(
//       'dynamicLabeledCorrelationMatrix:good: $dynamicLabeledCorrelationMatrix');
//
//   /// if one selectedAttribute is on all
//   print('selectedAttribute1: $selectedAttribute1');
//   String nextAttributeName;
//   if (selectedAttribute1 != 'All') {
//     var correlationCoefficientsOfOneAttribute =
//         await readCorrelationCoefficientsOfOneAttribute(selectedAttribute1);
//
//     // filter Nulls
//     correlationCoefficientsOfOneAttribute =
//         convertNullTo0(correlationCoefficientsOfOneAttribute);
//     print(
//         'correlationCoefficientsOfOneAttribute $correlationCoefficientsOfOneAttribute');
//
//     int argExtreme = listArgExtreme(correlationCoefficientsOfOneAttribute);
//     print('argExtreme: $argExtreme');
//
//     nextAttributeName = labels[argExtreme + 1];
//     debugPrint('nextAttributeName $nextAttributeName');
//   }
//   //
//   // /// if no selectedAttributes is on all
//   // else if (selectedAttribute2 != 'All') {} else {
//   //   debugPrint('ERROR unhandled selected attribute combination');
//   // }
//   else {
//     nextAttributeName = 'Happiness';
//   }
//   return nextAttributeName;
// }
