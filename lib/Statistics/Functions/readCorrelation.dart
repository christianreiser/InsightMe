import "dart:collection";
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:insightme/Core/functions/misc.dart';
import 'package:path_provider/path_provider.dart';

Future<num> readCorrelationCoefficient(attribute1, attribute2) async {
  var correlationMatrix = await _readCorrelationMatrix();
  int attributeIndex1 = correlationMatrix[0].indexOf(attribute1);
  final int attributeIndex2 =
      transposeChr(correlationMatrix)[0].indexOf(attribute2);

  final num correlationCoefficient =
      correlationMatrix[attributeIndex1][attributeIndex2];
  return correlationCoefficient;
}

Future<Map<String, double>> readCorrelationCoefficients(
    attribute) async {
  // corr matrix
  var correlationMatrix = await _readCorrelationMatrix();

  // labels
  List<dynamic> attributeNames = correlationMatrix[0];

  // corr Coeffs Target
  int attributeIndex = attributeNames.indexOf(attribute);
  var corrCoeffsTarget = correlationMatrix[attributeIndex];
  corrCoeffsTarget.removeAt(0);
  attributeNames.removeAt(0);

  // ini self balancing key tree. key consists of 'value_label'
  final SplayTreeMap<String, Map<String, double>> corrCoeffTargetSplayTreeMap =
      SplayTreeMap<String, Map<String, double>>();

  // fill self balancing tree with coeffs
  for (int i = 0; i < attributeNames.length; i++) {
    var currentCoeff = corrCoeffsTarget[i];
    if (currentCoeff == null || currentCoeff == 'null') {
      currentCoeff = 0.00;
    }

    // abs
    String currentCoeffAbsString = '${double.parse('$currentCoeff').abs()}';

    // add zeros if missing
    currentCoeffAbsString = _treeSignificantDigits(currentCoeffAbsString);

    // fill tree
    final String valueKey = '${currentCoeffAbsString}_${attributeNames[i]}';
    corrCoeffTargetSplayTreeMap[valueKey] = {attributeNames[i]: currentCoeff};
  }

  final corrCoeffTargetSortedMapList =
      corrCoeffTargetSplayTreeMap.values.toList();

  final Map<String, double> corrCoeffTargetSortedMap = Map<String, double>();
  for (int i = corrCoeffTargetSortedMapList.length - 1; i >= 0; i--) {
    corrCoeffTargetSortedMap[corrCoeffTargetSortedMapList[i].keys.first] =
        corrCoeffTargetSortedMapList[i].values.first;
  }
  return corrCoeffTargetSortedMap;
}

String _treeSignificantDigits(numString) {
  if (numString.length < 3) {
    numString = numString + '00';
  } else if (numString.length < 4) {
    numString = numString + '0';
  }
  return numString;
}

Future<List<List>> _readCorrelationMatrix() async {
  final directory = await getApplicationDocumentsDirectory();
  final input = new File(directory.path + "/correlation_matrix.csv").openRead();
  final correlationMatrix = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();
  return correlationMatrix;
}
