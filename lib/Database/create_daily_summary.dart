import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import 'attribute.dart';
import 'database_helper_attribute.dart';
import 'database_helper_entry.dart';
import 'entry.dart';

class WriteDailySummariesCSV {
  Future<File> writeDailySummariesCSV() async {
    /*
    * reads from db,
    * writes daily summaries csv
    * */

    // query attributes from db
    List<Attribute> attributeList =
        await DatabaseHelperAttribute().getAttributeList();
    int attributeListLength = attributeList.length;

    // get Attribute Title List
    List<String?> attributeTitleList =
        await getAttributeTitleList(attributeList, attributeListLength);

    // add Attribute Titles To Daily Summaries
    List<List<dynamic>> dailySummariesList = []; // list of daily summaries
    dailySummariesList.add(attributeTitleList);

    // add entries to daily summaries list
    dailySummariesList = await addEntriesToDailySummaries(
        attributeListLength, attributeTitleList, dailySummariesList);


    // save to file
    return await _saveDailySummariesToFile(dailySummariesList);
  }

  Future<List<String?>> getAttributeTitleList(
      attributeList, attributeListLength) async {
    /*
    adding attribute titles to dailySummariesList
    * for that: create a list of the attribute titles and add it
    * Also: gets
    */
    List<String?> attributeTitleList = List.filled(
        attributeListLength + 1, null); // length = #attributes + 1 for date
    attributeTitleList[0] = 'date';
    for (int attributeCount = 0;
        attributeCount < attributeListLength;
        attributeCount++) {
      attributeTitleList[attributeCount + 1] =
          attributeList[attributeCount].title;
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

    rowToAdd[0] = entryList[0].date!.substring(0, 10); // add newest date as date
    int entryListLength = entryList.length;

    /* fill rowToAdd with data and add to dailySummariesList */
    // iterate through all entries
    for (int entryCount = 0; entryCount < entryListLength; entryCount++) {
      // debugPrint('progress: $entryCount of $entryListLength.');
      // if date of entry matches row date:
      if (entryList[entryCount].date!.substring(0, 10) == rowToAdd[0]) {
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
        //debugPrint('rowToAdd $rowToAdd');
        // clear rowToAdd from yesterdays values
        rowToAdd = List.filled(attributeListLength + 1, null);
        // set new date
        rowToAdd[0] = entryList[entryCount].date!.substring(0, 10);
        //debugPrint('date: ${entryList[entryCount].date}');
        // get column index (same as above):
        int columnIndex =
            attributeTitleList.indexOf(entryList[entryCount].title);
        // overwrite null with value (same as above):
        rowToAdd[columnIndex] = entryList[entryCount].value;
      }
    }
    dailySummariesList.add(rowToAdd); // add to dailySummariesList
    return dailySummariesList;
  }

  Future<File> _saveDailySummariesToFile(dailySummariesList) async {
    /// save dailySummariesList to file and returns csv
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/daily_summaries.csv";
    File file = File(pathOfTheFileToWrite);
    String csv = const ListToCsvConverter().convert(dailySummariesList);
    await file.writeAsString(csv);
    return file;
  }
}
