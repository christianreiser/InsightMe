import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starfruit/starfruit.dart';
import 'dart:io';
import 'dart:convert' show utf8;

import 'attribute.dart';
import 'entry.dart';
import 'database_helper_attribute.dart';
import 'database_helper_entry.dart';
import 'package:flutter_charts/flutter_charts.dart';

Future<List<List<dynamic>>> writeDBToCSV() async {
  List<List<dynamic>> spreadsheet = []; // list of rows
  List<Attribute> attributeList =
      await DatabaseHelperAttribute().getAttributeList();
  List<String> attributeTitleList =
      List(attributeList.length + 1); // length = #attributes + 1 for date
  attributeTitleList[0] = 'date';
  List<Entry> entryList = await DatabaseHelperEntry().getEntryList();
  debugPrint('attributeList $attributeList');
  debugPrint('attributeListLen ${attributeList.length}');

  //attributeList.insert(0, 'date');

  for (int attributeCount = 0;
      attributeCount < attributeList.length;
      attributeCount++) {
    attributeTitleList[attributeCount + 1] =
        attributeList[attributeCount].title;
  }
  spreadsheet.add(attributeTitleList); // add attributes to spreadsheet

  // ini first row to add
  List<dynamic> rowToAdd =
      List.filled(attributeList.length + 1, null); // start with row of nulls
  debugPrint('rowToAddL ${rowToAdd.length}');
  debugPrint('entryList[0] ${entryList.length}');
  rowToAdd[0] = entryList[0].date.substring(0, 10); // add newest date as date
  int entryListLength = entryList.length;

  // get number of days in db
  // todo use this number for fixes list size for faster computation
  int numDays = DateTime.parse(entryList[0].date.substring(0, 10))
          .difference(DateTime.parse(
              entryList[entryListLength - 1].date.substring(0, 10)))
          .inDays +
      1; // todo: if one day has no data at all, this breaks

  // save numDays
  final prefs = await SharedPreferences.getInstance();
  // set value
  prefs.setInt('numDays', numDays);
  debugPrint('saved numDays=$numDays in SharedPreferences');

  // iterate through all entries
  for (int entryCount = 0; entryCount < entryListLength; entryCount++) {
    debugPrint('${entryCount / entryListLength}');
    // if date of entry matches row date:
    if (entryList[entryCount].date.substring(0, 10) == rowToAdd[0]) {
      // get column index:
      int columnIndex = attributeTitleList.indexOf(entryList[entryCount].title);
      // overwrite null with value:
      rowToAdd[columnIndex] = entryList[entryCount].value;
//      debugPrint(
//          'added: columnIndex $columnIndex, value ${entryList[entryCount].value}, date ${rowToAdd[0]}');
      // if date of entry does not match row date means a new date started:
    } else {
      spreadsheet.add(rowToAdd); // add yesterday to spreadsheet
      debugPrint('rowToAdd $rowToAdd');
      // clear rowToAdd from yesterdays values
      rowToAdd = List.filled(attributeList.length + 1, null);
      // set new date
      rowToAdd[0] = entryList[entryCount].date.substring(0, 10);
      // get column index (same as above):
      int columnIndex = attributeTitleList.indexOf(entryList[entryCount].title);
      // overwrite null with value (same as above):
      rowToAdd[columnIndex] = entryList[entryCount].value;
    }
  }
  spreadsheet.add(rowToAdd); // add to spreadsheet

  debugPrint('attributeSpreadsheet $spreadsheet');

  final directory = await getApplicationDocumentsDirectory();
  final pathOfTheFileToWrite = directory.path + "/daily_summaries.csv";
  final directoryTarget =
      await getExternalStorageDirectory(); // todo: currently works only on andoid
  debugPrint('directoryTarget $directoryTarget');

//   needs writing permission
//  PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
//    debugPrint('permissionResult $permissionResult');
//  if (permissionResult == PermissionStatus.authorized){
  // code of read or write file in external storage (SD card)
//    final pathOfTheFileToWrite = directoryTarget.parent.parent.parent.parent.path + "/Download/daily_summaries.csv";
//    final pathOfTheFileToWrite = directoryTarget.path + "/Download/daily_summaries.csv";
  debugPrint('targetPath $pathOfTheFileToWrite');
  File file = File(pathOfTheFileToWrite);
  debugPrint('file $file');
  String csv = const ListToCsvConverter().convert(spreadsheet);
  debugPrint('csv $csv');
  file.writeAsString(csv);
  debugPrint('file written');
//  }
  return spreadsheet;
}

readDailySummariesCSV() async {
  /*
  * read csv and transform
  * */

  // get numDays
  final prefs = await SharedPreferences.getInstance();
  int numDays = prefs.getInt('numDays') ?? null;

  final directory = await getApplicationDocumentsDirectory();
  final input = new File(directory.path + "/daily_summaries.csv").openRead();
  final rowForEachDay = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();

  /* separate labels from values*/
  final List<dynamic> labels =
      rowForEachDay.removeAt(0); // separate labels from values
  labels.removeAt(0); // remove date-label
  debugPrint('labels $labels');
  debugPrint('rowForEachDay $rowForEachDay');

  /* remove dates from values*/
  var rowForEachAttribute = List<List<dynamic>>.from(
      transpose(rowForEachDay)); // make list variable length
  rowForEachAttribute.removeAt(0); // remove dates
//  List<List<num>> rowForEachAttributeNum = rowForEachAttribute.cast<List<num>>();
  debugPrint('rowForEachAttribute $rowForEachAttribute');

  /*
  * correlation
  * */
  debugPrint('numDays $numDays');
  int numLabels = labels.length;
  List<num> correlationCoefficients = List.filled(numLabels, null);
  List<String> attribute1 = List.filled(numLabels, null);
  List<String> attribute2 = List.filled(numLabels, null);
  int labelCount = 0;
  // 1 to skip date
  for (int attributeCount1 = 0;
      attributeCount1 < numLabels;
      attributeCount1++) {
    // 1 to skip date
    for (int attributeCount2 = 0;
        attributeCount2 < numLabels;
        attributeCount2++) {
      // skip self and double correlation with if:
      if (attributeCount2 > attributeCount1) {
        labelCount++;
        Map<num, num> xYStats = {};
        debugPrint(
            '\nNow labels: ${labels[attributeCount1]} and ${labels[attributeCount2]}.');

        // 1 to skip label
        for (int valueCount = 0; valueCount < numDays; valueCount++) {
          debugPrint('valueCount: $valueCount');
          debugPrint(
              'rowForEachAttribute[attributeCount1][valueCount])] ${rowForEachAttribute[attributeCount1][valueCount]}');
          debugPrint(
              'rowForEachAttribute[attributeCount2][valueCount])] ${rowForEachAttribute[attributeCount2][valueCount]}');
          if (rowForEachAttribute[attributeCount1][valueCount] != null &&
              rowForEachAttribute[attributeCount1][valueCount] != 'null' &&
              rowForEachAttribute[attributeCount2][valueCount] != null &&
              rowForEachAttribute[attributeCount2][valueCount] != 'null') {
            debugPrint('there is no null');
            // todo fragile: breaks if cardinality attributeCount1 =! # attributeCount1, because attributeCount1 is the key.
            //  todo: maybe with cUtils.zip or check cardinality with .cardinality.

            xYStats[(rowForEachAttribute[attributeCount1][valueCount])] =
                rowForEachAttribute[attributeCount2][valueCount];
            debugPrint('xYStats $xYStats');
          } else {
            debugPrint('skipping because value is null');
          }
        }

        //Get correlation coefficient
        debugPrint('xYStats.length ${xYStats.length}');
        debugPrint('labelCount: $labelCount');
        if (xYStats.length > 2) {
          debugPrint('computing correlation');
//          debugPrint(
//              'Correlating ${labels[attributeCount1]} and ${labels[attributeCount2]}. Coefficient: ${StarStatsXY(xYStats).corCoefficient}\n');

          correlationCoefficients[labelCount] =
              StarStatsXY(xYStats).corCoefficient;
          debugPrint('attribute1[labelCount] = labels[attributeCount1];');
          attribute1[labelCount] = labels[attributeCount1];
          debugPrint('attribute2[labelCount] = labels[attributeCount2];');
          attribute2[labelCount] = labels[attributeCount2];
          debugPrint('after attribute2[labelCount] = labels[attributeCount2];');
        } else {
          debugPrint(
              'skipping: requirement not full-filled: at least 3 values needed for correlation\n');
        }
        debugPrint('correlationCoefficients: $correlationCoefficients');
        debugPrint('attribute1: $attribute1');
        debugPrint('attribute2: $attribute2\n\n');
        debugPrint('____________________________________\n\n');
      }
    }
  }
}
