import 'dart:convert' show utf8;
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as fluCa;
import 'package:flutter_charts/flutter_charts.dart';
import 'package:path_provider/path_provider.dart';

Future<num> readCorrelationCoefficient(attribute1, attribute2) async {
  var correlationMatrix = await readCorrelationMatrix();

  int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
  int attributeIndex2 =
      fluCa.transpose(correlationMatrix)[0].indexOf(attribute2);
  return correlationMatrix[attributeIndex1][attributeIndex2];
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
  debugPrint('got correlationMatrix $correlationMatrix');
  return correlationMatrix;
}

removeFirstEntryOfEachRow(matrix) {
  /// 1. transpose
  /// 2. remove
  /// 3. transpose back
  // transpose to make remove label column work
  List<List<dynamic>> matrixT = List<List<dynamic>>.from(transpose(matrix));
  matrixT.removeAt(0); // remove label column
  return List<List<dynamic>>.from(transpose(matrixT)); // transpose back;
}

listArgExtreme(numList) {

  //final vector = Vector.fromList(numList);
  final maxValue = numList.reduce((curr, next) => curr > next ? curr : next);
  final minValue = numList.reduce((curr, next) => curr < next ? curr : next);
  print('minValue ${minValue}');
  double extreme;
  if (maxValue >= -minValue) {
    extreme = maxValue;
  } else if (maxValue < -minValue) {
    extreme = minValue;
  } else {
    debugPrint('UNHANDLED EXCEPTION: EXTREMEVALUE');
  }

  /// get extremest index
  print('numList; $numList');
  print('numList.runtimeType ${numList.runtimeType}');

  //List<dynamic> numListT = [0.0, 0.01, 0.02];
  final int argExtreme = numList.indexWhere(
      (element) => element == extreme);

  debugPrint('argExtreme $argExtreme');
  return argExtreme;
}

Future<String> sortedAttributeList(selectedAttribute1, selectedAttribute2) async {
  //todo refactoring

  // readCorrelationMatrix
  List<List<dynamic>> dynamicLabeledCorrelationMatrix =
      await readCorrelationMatrix();
  debugPrint(
      'dynamicTwiceLabeledCorrelationMatrix:good: $dynamicLabeledCorrelationMatrix');

  // separate lables
  final List<dynamic> labels = dynamicLabeledCorrelationMatrix.removeAt(0);
  debugPrint(
      'dynamicLabeledCorrelationMatrix:good: $dynamicLabeledCorrelationMatrix');

  //List<num> numList = convertDynamicListWithNullsToNumList(dynamicCorrelationMatrix);
  //debugPrint('numList:: $numList');

  /// if one selectedAttribute is on all
  print('selectedAttribute1: $selectedAttribute1');
  String nextSttributeName;
  if (selectedAttribute1 != 'All') {
    var correlationCoefficientsOfOneAttribute =
        await readCorrelationCoefficientsOfOneAttribute(selectedAttribute1);

    // filter Nulls
    correlationCoefficientsOfOneAttribute =
        convertNullTo0(correlationCoefficientsOfOneAttribute);
    print(
        'correlationCoefficientsOfOneAttribute $correlationCoefficientsOfOneAttribute');

    int argExtreme =
        listArgExtreme(correlationCoefficientsOfOneAttribute);
    print('argExtreme: $argExtreme');

    nextSttributeName = labels[argExtreme+1];
    print(nextSttributeName);
  }
  //
  // /// if no selectedAttributes is on all
  // else if (selectedAttribute2 != 'All') {} else {
  //   debugPrint('ERROR unhandled selected attribute combination');
  // }
  else {
    nextSttributeName = 'Happiness';
  }
  return nextSttributeName;
}
