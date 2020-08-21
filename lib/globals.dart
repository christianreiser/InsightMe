// import './../globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';


import 'package:flutter/cupertino.dart';

import 'Database/attribute.dart';
import 'Database/database_helper_entry.dart';
import 'Database/entry.dart';
import 'Database/database_helper_attribute.dart';
String mostRecentAddedEntryName;
String secondMostRecentAddedEntryName;
List<Attribute> attributeList; // list to avoid async db operations
List<Entry> entryList; // list to avoid async db operations
int entryListLength;
int attributeListLength;

class Global {
  //


  Future<List<Attribute>> updateAttributeList() async {
    debugPrint('called updateAttributeList');
    attributeList = await DatabaseHelperAttribute().getAttributeList();
    debugPrint('done await DatabaseHelperAttribute().getAttributeList()');
    attributeListLength = attributeList.length;
    debugPrint('attributeList.length: ${attributeList.length}');
    return attributeList;
  }

  Future<List<Entry>> updateEntryList() async {
    entryList = await DatabaseHelperEntry().getEntryList();
    entryListLength = entryList.length;
    return entryList;
  }



}

//// Read
//Future<String> readRecentAddedEntryName() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  debugPrint('mostRecentAddedEntryName1; $mostRecentAddedEntryName');
//  mostRecentAddedEntryName = prefs.getString('mostRecentAddedEntryName') ?? '??';
//  debugPrint('mostRecentAddedEntryName2; $mostRecentAddedEntryName');
//  secondMostRecentAddedEntryName = prefs.getString('secondMostRecentAddedEntryName') ?? 'new1';
//  return mostRecentAddedEntryName;
//}
//
////save
//void writeRecentAddedEntryName() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await prefs.setString('mostRecentAddedEntryName', mostRecentAddedEntryName);
//  await prefs.setString('secondMostRecentAddedEntryName', secondMostRecentAddedEntryName);
//}
