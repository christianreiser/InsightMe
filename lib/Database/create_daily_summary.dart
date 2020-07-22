import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:insightme/globals.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert' show utf8;

import 'attribute.dart';
import 'entry.dart';
import 'database_helper_attribute.dart';
import 'database_helper_entry.dart';
import 'package:flutter_charts/flutter_charts.dart';
//import 'package:starfruit/starfruit.dart';


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
  rowToAdd[0] = entryList[0].date.substring(0, 10); // add newest date as date
  int entryListLength = entryList.length;

  // get number of days in db
  // todo use this number for fixes list size for faster computation
  int numDays = DateTime.parse(entryList[0].date.substring(0, 10))
      .difference(
          DateTime.parse(entryList[entryListLength - 1].date.substring(0, 10)))
      .inDays + 1; // todo: if one day has no data at all, this breaks

  // save numDays
  final prefs = await SharedPreferences.getInstance();
  // set value
  prefs.setInt('numDays', numDays);

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
  final fields = await input
      .transform(utf8.decoder)
      .transform(new CsvToListConverter())
      .toList();
  List<List<dynamic>> rowForEachAttribute = transpose(fields);
  debugPrint('fields $rowForEachAttribute');

  /*
  * correlation
  * */
  List<dynamic> averageSpeed = rowForEachAttribute[1];
  List<dynamic> distance = rowForEachAttribute[6];
  debugPrint('distance $distance');
  Map<num, num> xYValuesMap = {};
//  dateTimeValueMap[DateTime.parse(
//    (filteredEntryList[0].date),
//  )] = 1.0; // =1 is needed
  debugPrint('numDays $numDays');
  for (int ele = 1; ele < numDays; ele++) {
    // 1 to skipp label
    xYValuesMap[(averageSpeed[ele])] = distance[ele];
  }
  debugPrint('xYValuesMap $xYValuesMap');
  //Get correlation coefficient
  print("Calculate correlation coefficient:");
  print(xYValuesMap.corCoefficient);
  print("");
}
