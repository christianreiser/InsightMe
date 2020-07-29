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
  Future<String> writeDailySummariesCSV() async {
    /*
    * reads from db,
    * writes daily summaries csv
    * */

    /*initialize*/
    List<List<dynamic>> dailySummariesList = []; // list of daily summaries

    /* query data from db*/
    List<Attribute> attributeList =
        await DatabaseHelperAttribute().getAttributeList();
    List<Entry> entryList = await DatabaseHelperEntry().getEntryList();

    /* adding attribute titles to dailySummariesList
    * for that: create a list of the attribute titles and add it */
    List<String> attributeTitleList =
        List(attributeList.length + 1); // length = #attributes + 1 for date
    attributeTitleList[0] = 'date';
    for (int attributeCount = 0;
        attributeCount < attributeList.length;
        attributeCount++) {
      attributeTitleList[attributeCount + 1] =
          attributeList[attributeCount].title;
      debugPrint('attributeCount $attributeCount');
      debugPrint(
          'attributeTitleList[attributeCount + 1]: ${attributeTitleList[attributeCount + 1]}');
    }
    dailySummariesList
        .add(attributeTitleList); // add attributes to dailySummariesList

    /* create rowToAdd List.
    * It will contain data of one day which will be added to dailySummariesList.
    * 1. ini list with nulls and add newest date
    * */

    // ini first row to add: start with row of nulls
    List<dynamic> rowToAdd = List.filled(attributeList.length + 1, null);
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

    /* save numDays */
    // todo: numDays used in correlations but should be possible without for faster performance
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setInt('numDays', numDays);

    /* fill rowToAdd with data and add to dailySummariesList */
    debugPrint('starting creating daily summaries csv');

    // iterate through all entries
    for (int entryCount = 0; entryCount < entryListLength; entryCount++) {
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
        dailySummariesList.add(rowToAdd); // add yesterday to dailySummariesList
        debugPrint('rowToAdd $rowToAdd');
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
    dailySummariesList.add(rowToAdd); // add to dailySummariesList

//  debugPrint('attributedailySummariesList $dailySummariesList');

    /*
    * save to file
    * */
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/daily_summaries.csv";
//  final directoryTarget =
//      await getExternalStorageDirectory(); // todo: currently works only on android
//  debugPrint('directoryTarget $directoryTarget');
    debugPrint('targetPath $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    debugPrint('file $file');
    String csv = const ListToCsvConverter().convert(dailySummariesList);
    //debugPrint('csv $csv');
    file.writeAsString(csv);
    debugPrint('daily_summaries.csv written');
//  }

    return csv;
  }
}
