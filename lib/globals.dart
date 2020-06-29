// import './../globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';

import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();


String mostRecentAddedEntryName;
String secondMostRecentAddedEntryName;
List<Attribute> attributeList; // list to avoid async db operations

class Global {
  //
  updateAttributeList() async {
    debugPrint('attributeListOld $attributeList');
    attributeList = await databaseHelperAttribute.getAttributeList();
    debugPrint('attributeListNew $attributeList');
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
