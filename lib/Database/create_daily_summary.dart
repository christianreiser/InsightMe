import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'attribute.dart';
import 'entry.dart';
import 'database_helper_attribute.dart';
import 'database_helper_entry.dart';

class WriteDailySummariesCSV {
  Future<List<List<dynamic>>> writeDailySummariesCSV() async {
    /*
  * reads from db,
  * writes daily summaries csv
  * */
    List<List<dynamic>> spreadsheet = []; // list of rows
    List<Attribute> attributeList =
        await DatabaseHelperAttribute().getAttributeList();
    List<String> attributeTitleList =
        List(attributeList.length + 1); // length = #attributes + 1 for date
    attributeTitleList[0] = 'date';
    List<Entry> entryList = await DatabaseHelperEntry().getEntryList();
//  debugPrint('attributeList $attributeList');
//  debugPrint('attributeListLen ${attributeList.length}');

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
//  debugPrint('rowToAddL ${rowToAdd.length}');
//  debugPrint('entryList[0] ${entryList.length}');
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
//  debugPrint('saved numDays=$numDays in SharedPreferences');
    debugPrint('starting creating daily summaries csv');

    // iterate through all entries
    for (int entryCount = 0; entryCount < entryListLength; entryCount++) {
      //debugPrint('${entryCount / entryListLength} % done');
      // if date of entry matches row date:
      if (entryList[entryCount].date.substring(0, 10) == rowToAdd[0]) {
        // get column index:
        int columnIndex =
            attributeTitleList.indexOf(entryList[entryCount].title);
        // overwrite null with value:
        rowToAdd[columnIndex] = entryList[entryCount].value;
//      debugPrint(
//          'added: columnIndex $columnIndex, value ${entryList[entryCount].value}, date ${rowToAdd[0]}');
        // if date of entry does not match row date means a new date started:
      } else {
        spreadsheet.add(rowToAdd); // add yesterday to spreadsheet
//      debugPrint('rowToAdd $rowToAdd');
        // clear rowToAdd from yesterdays values
        rowToAdd = List.filled(attributeList.length + 1, null);
        // set new date
        rowToAdd[0] = entryList[entryCount].date.substring(0, 10);
        // get column index (same as above):
        int columnIndex =
            attributeTitleList.indexOf(entryList[entryCount].title);
        // overwrite null with value (same as above):
        rowToAdd[columnIndex] = entryList[entryCount].value;
      }
    }
    spreadsheet.add(rowToAdd); // add to spreadsheet

//  debugPrint('attributeSpreadsheet $spreadsheet');

    /*
  * save to file
  * */
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/daily_summaries.csv";
//  final directoryTarget =
//      await getExternalStorageDirectory(); // todo: currently works only on andoid
//  debugPrint('directoryTarget $directoryTarget');
    debugPrint('targetPath $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    debugPrint('file $file');
    String csv = const ListToCsvConverter().convert(spreadsheet);
    //debugPrint('csv $csv');
    file.writeAsString(csv);
    debugPrint('daily_summaries.csv written');
//  }
    return spreadsheet;
  }
}

