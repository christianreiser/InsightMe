// import './../globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';


import 'Database/attribute.dart';
import 'Database/database_helper_attribute.dart';
DatabaseHelperAttribute databaseHelperAttribute = DatabaseHelperAttribute();


String mostRecentAddedEntryName;
String secondMostRecentAddedEntryName;
List<Attribute> attributeList; // list to avoid async db operations
int entryListLength;
int attributeListLength; // todo useful for visualization, and searchOrCreate

class Global {
  //
  updateAttributeList() async {
    attributeList = await databaseHelperAttribute.getAttributeList();
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
