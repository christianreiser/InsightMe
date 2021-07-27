import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import 'entry.dart';

class DatabaseHelperEntry {
  static DatabaseHelperEntry
      _databaseHelperEntry; // Singleton DatabaseHelperEntry
  static Database _database; // Singleton Database

  static final String entryTable = 'entry_table';
  static final String colId = 'id';
  static final String colTitle =
      'title'; // TODO minor: rename to attribute also for attribute_helper
  static final String colValue = 'value';
  static final String colComment = 'comment';
  static final String colDate = 'date'; // TODO minor: rename to dateTime

  DatabaseHelperEntry._createInstance(); // Named constructor to create instance of DatabaseHelperEntry

  factory DatabaseHelperEntry() {
    if (_databaseHelperEntry == null) {
      _databaseHelperEntry = DatabaseHelperEntry
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelperEntry;
  }

  /*
  * create the database object and provide it with a getter where we will
  * instantiate the database if it’s not. This is called lazy initialization.
  */
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  /*
  * If there is no object assigned to the database, we use the initializeDatabase
  * function to create the database. In this function, we will get the path for
  * storing the database and create the desired tables. I’m using entries as the
  * name of the database
  * */
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    debugPrint('getApplicationDocumentsDirectory');
//    Directory directory = await getApplicationDocumentsDirectory();
//    debugPrint('directory');
//    String path = directory.path + 'entries.db';

    debugPrint('openDatabase');
    // Open/create the database at a given path
    var entriesDatabase =
        await openDatabase('entries.db', version: 1, onCreate: _createDb);
    debugPrint('done ini $_database');
    return entriesDatabase;
  }

  /*creating the table*/
  void _createDb(Database db, int newVersion) async {
    // TODO performance: change the type of $colValue to REAL which means double
    await db.execute('CREATE TABLE $entryTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colValue TEXT, '
        '$colComment TEXT, $colDate TEXT)');
  }

  // Fetch Operation: Get all entry objects from database
  Future<List<Map<String, dynamic>>> getEntryMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $entryTable order by $colTitle ASC');
    var result = await db.query(entryTable, orderBy: '$colDate DESC');
    return result;
  }

  void deleteDb() async {
//    Directory directory = await getApplicationDocumentsDirectory();
//    String path = directory.path + 'entries.db';
    await deleteDatabase('entries.db');
    initializeDatabase();
  }

  // CHREI Fetch Operation: Get entry objects from database FILTERED ATTRIBUTES

  Future<List<Map<String, dynamic>>> getFilteredEntryMapList(
      attributeToFilter) async {
    // get single row
    List<String> columnsToSelect = [
      DatabaseHelperEntry.colValue,
      DatabaseHelperEntry.colDate,
      DatabaseHelperEntry.colId,
      DatabaseHelperEntry.colTitle,
      DatabaseHelperEntry.colComment,
    ];
    String whereString = '${DatabaseHelperEntry.colTitle} = ?';
    List<dynamic> whereArguments = [attributeToFilter];
    Database db = await this.database;

    var result = await db.query(entryTable,
        orderBy: '$colDate ASC',
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    return result;
  }

  // Insert Operation: Insert a entry object to database
  Future<int> insertEntry(Entry entry) async {
    Database db =
        await this.database; //  await keyword to wait for a future to complete
    var result =
        await db.insert(entryTable, entry.toMap()); // insert(table, row)
    return result;
  }

  // Update Operation: Update a entry object and save it to database
  Future<int> updateEntry(Entry entry) async {
    var db = await this.database;
    var result = await db.update(entryTable, entry.toMap(),
        where: '$colId = ?', whereArgs: [entry.id]);
    return result;
  }

  // CHREI: Rename Operation: Rename all entry object with given title and save it
  // to database
  Future<List<int>> renameEntry(newAttributeTitle, oldAttributeTitle) async {
    List<int> resultList = [];
    var db = await this.database;
    List<Entry> filteredEntryList =
        await getFilteredEntryList(oldAttributeTitle);
    for (int i = 0; i < filteredEntryList.length; i++) {
      filteredEntryList[i].title = newAttributeTitle;

      var result = await db.update(entryTable, filteredEntryList[i].toMap(),
          where: '$colId = ?', whereArgs: [filteredEntryList[i].id]);
      resultList.add(result);
    }
    return resultList;
  }

  // Delete Operation: Delete a entry object from database
  Future<int> deleteEntry(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $entryTable WHERE $colId = $id');
    return result;
  }

  // Get number of entry objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $entryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'entry List' [ List<Entry> ]
  Future<List<Entry>> getEntryList() async {
    var entryMapList = await getEntryMapList(); // Get 'Map List' from database
    int countEntry =
        entryMapList.length; // Count the number of map entries in db table

    List<Entry> entryList = [];
    // For loop to create a 'entry List' from a 'Map List'
    for (int i = 0; i < countEntry; i++) {
      entryList.add(Entry.fromMapObject(entryMapList[i]));
    }

    return entryList;
  }

  // CHREI get the 'Map List' [ List<Map> ] FILTERED and convert it to 'entry List FILTERED' [ List<Entry> ]
  Future<List<Entry>> getFilteredEntryList(attributeNameToFilter) async {
    var filteredEntryMapList = await getFilteredEntryMapList(
        attributeNameToFilter); // Get 'Map List' from database
    int countEntryFiltered = filteredEntryMapList
        .length; // Count the number of map entries in db table

    List<Entry> filteredEntryList = [];
    // For loop to create a 'entry List' from a 'Map List'
    for (int i = 0; i < countEntryFiltered; i++) {
      filteredEntryList.add(Entry.fromMapObject(filteredEntryMapList[i]));
    }
    return filteredEntryList;
  }
}
