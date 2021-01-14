import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as fluCa;
import 'package:path_provider/path_provider.dart';

Future<num> correlationCoefficient(attribute1, attribute2) async {
  /// read csv and transform
  // todo maybe in different file
  final directory = await getApplicationDocumentsDirectory();
  final input =
  new File(directory.path + "/correlation_matrix.csv").openRead();
  final correlationMatrix = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();
  debugPrint('got correlationMatrix $correlationMatrix');

  int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
  int attributeIndex2 =
  fluCa.transpose(correlationMatrix)[0].indexOf(attribute2);
  debugPrint(
      'correlationMatrix[attributeIndex1][attributeIndex2] ${correlationMatrix[attributeIndex1][attributeIndex2]}');
  debugPrint(
      'correlationMatrix[attributeIndex2][attributeIndex1] ${correlationMatrix[attributeIndex2][attributeIndex1]}');

  // min max is needed as correlation matrix is only half filled and row<column
  final num _correlationCoefficient =
  correlationMatrix[min(attributeIndex1, attributeIndex2)]
  [max(attributeIndex1, attributeIndex2)];
  debugPrint(
      '_getCorrelationCoefficient: _correlationCoefficient: $_correlationCoefficient');
  return _correlationCoefficient;
}