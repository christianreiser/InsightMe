import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'attribute.dart';
import 'database_helper_attribute.dart';
import 'database_helper_entry.dart';
import 'entry.dart';

class WriteDailySummariesCSV {
  Future<String> writeDailySummariesCSV() async {
    /*
    * reads from db,
    * writes daily summaries csv
    * */

    // query attributes from db
    List<Attribute> attributeList =
        await DatabaseHelperAttribute().getAttributeList();
    int attributeListLength = attributeList.length;

    // get Attribute Title List
    List<String> attributeTitleList =
        await getAttributeTitleList(attributeList, attributeListLength);

    // add Attribute Titles To Daily Summaries
    List<List<dynamic>> dailySummariesList = []; // list of daily summaries
    dailySummariesList.add(attributeTitleList);

    // add entries to daily summaries list
    dailySummariesList = await addEntriesToDailySummaries(
        attributeListLength, attributeTitleList, dailySummariesList);

    debugPrint('dailySummariesList $dailySummariesList');

    // save to file
    return await saveDailySummariesToFile(dailySummariesList);
  }

  Future<List<String>> getAttributeTitleList(
      attributeList, attributeListLength) async {
    /*
    adding attribute titles to dailySummariesList
    * for that: create a list of the attribute titles and add it
    * Also: gets
    */
    List<String> attributeTitleList =
        List.filled(attributeListLength + 1, null); // length = #attributes + 1 for date
    attributeTitleList[0] = 'date';
    for (int attributeCount = 0;
        attributeCount < attributeListLength;
        attributeCount++) {
      attributeTitleList[attributeCount + 1] =
          attributeList[attributeCount].title;
      debugPrint('attributeCount $attributeCount');
      debugPrint(
          'attributeTitleList[attributeCount + 1]: ${attributeTitleList[attributeCount + 1]}');
    }
    return attributeTitleList;
  }

  Future<List<List<dynamic>>> addEntriesToDailySummaries(
      attributeListLength, attributeTitleList, dailySummariesList) async {
    /* create rowToAdd List.
    * It will contain data of one day which will be added to dailySummariesList.
    * 1. ini list with nulls and add newest date
    * */

    // query entries from db
    List<Entry> entryList = await DatabaseHelperEntry().getEntryList();

    // ini first row to add: start with row of nulls
    List<dynamic> rowToAdd = List.filled(attributeListLength + 1, null);


    rowToAdd[0] = entryList[0].date.substring(0, 10); // add newest date as date
    debugPrint('date: ${entryList[0].date}');
    int entryListLength = entryList.length;

    // save NumDays In Shared Preferences. used in correlations
    saveNumDaysInSharedPreferences(entryList, entryListLength);

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
        rowToAdd = List.filled(attributeListLength + 1, null);
        // set new date
        rowToAdd[0] = entryList[entryCount].date.substring(0, 10);
        debugPrint('date: ${entryList[entryCount].date}');
        // get column index (same as above):
        int columnIndex =
            attributeTitleList.indexOf(entryList[entryCount].title);
        // overwrite null with value (same as above):
        rowToAdd[columnIndex] = entryList[entryCount].value;
      }
    }
    dailySummariesList.add(rowToAdd); // add to dailySummariesList
    debugPrint('rowToAdd $rowToAdd');
    return dailySummariesList;
  }

  void saveNumDaysInSharedPreferences(entryList, entryListLength) async {
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
  }

  Future<String> saveDailySummariesToFile(dailySummariesList) async {
    /*
    * save dailySummariesList to file and returns csv
    * */
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/daily_summaries.csv";
    //debugPrint('targetPath $pathOfTheFileToWrite');
    File file = File(pathOfTheFileToWrite);
    //debugPrint('file $file');
    String csv = const ListToCsvConverter().convert(dailySummariesList);
    debugPrint('csv $csv');
    file.writeAsString(csv);
    return csv;
  }
}
