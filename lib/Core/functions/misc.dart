import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:insightme/Database/attribute.dart';
import 'package:path_provider/path_provider.dart';

import '../../Journal/searchOrCreateAttribute.dart' as soca;
import '../../strings.dart';


getFirstLetter(String title) {
  /* get first letter for yellow circle avatar */
  if (title.length > 0) {
    // to avoid error when title.length == 0
    return title.substring(0, 1);
  } else {
    return ' ';
  }
}

List<List<dynamic>> transposeChr(List<List<dynamic>> colsInRows) {
  int nRows = colsInRows.length;
  if (colsInRows.length == 0) return colsInRows;

  int nCols = colsInRows[0].length;
  if (nCols == 0) throw new StateError("Degenerate matrix");

  // Init the transpose to make sure the size is right
  List<List<dynamic>> rowsInCols = new List.filled(nCols, []);
  for (int col = 0; col < nCols; col++) {
    rowsInCols[col] =
    new List.filled(nRows, new StackableValuePoint.initial());
  }

  // Transpose
  for (int row = 0; row < nRows; row++) {
    for (int col = 0; col < nCols; col++) {
      rowsInCols[col][row] = colsInRows[row][col];
    }
  }
  return rowsInCols;
}

Future<String> save2DListToCSVFile(dailySummariesList, path) async {
  /// save dailySummariesList to file and returns csv
  final directory = await getApplicationDocumentsDirectory();
  final pathOfTheFileToWrite = directory.path + path;
  //debugPrint('targetPath $pathOfTheFileToWrite');
  File file = File(pathOfTheFileToWrite);
  //debugPrint('file $file');
  String csv = const ListToCsvConverter().convert(dailySummariesList);
  debugPrint('csv:\n $csv');
  file.writeAsString(csv);
  return csv;
}

// add attributes to DB if new
Future<bool> saveAttributeToDBIfNew(_attribute, _dBAttributeList) async {
  bool addedNewAttributeToDB;
  bool _exactMatch = false;

  // go through all db attributes one by one and compare
  //debugPrint('_exactMatch before search: $_exactMatch');
  for (int i = 0; i < _dBAttributeList.length; i++) {
    // check if there is a exact attribute match
    if (_dBAttributeList[i]
        .title
        .toLowerCase()
        .compareTo(_attribute.toLowerCase()) ==
        0) {
      _exactMatch = true;
      //debugPrint('exact match: ${_dBAttributeList[i].title} vs $_attribute');
    }
  }

  // save attribute if new
  if (_exactMatch == false) {
    //debugPrint('create new attribute: $_attribute');

    // add to faster searchable list
    // todo important: ask user if additive or average
    _dBAttributeList.add(Attribute(
        _attribute, 'imported', defaultLabelColor, defaultAggregation));

    // save to db
    soca.SearchOrCreateAttributeState() // todo important performance: await and result feedback
        .saveAttribute(Attribute(
        _attribute, 'imported', defaultLabelColor, defaultAggregation));

    addedNewAttributeToDB = true;
  } else {
    //debugPrint('not creating new attribute as there is a exact match: $_attribute exists in $_dBAttributeList');
    addedNewAttributeToDB = false;
  }
  return addedNewAttributeToDB;
}