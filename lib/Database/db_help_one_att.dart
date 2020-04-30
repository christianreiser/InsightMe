import 'package:lifetracker4/Database/entry.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'entry.dart';

class DbHelpOneAtt {

  static DbHelpOneAtt _dbHelpOneAtt;    // Singleton DbHelpOneAtt
  static Database _database;                // Singleton Database

  String entryTable = 'entry_table';
  String colId = 'id';
  String colTitle = 'title';
  String colValue = 'value';
  String colComment = 'comment';
  String colDate = 'date';

  DbHelpOneAtt._createInstance(); // Named constructor to create instance of DbHelpOneAtt

  factory DbHelpOneAtt() {

    if (_dbHelpOneAtt == null) {
      _dbHelpOneAtt = DbHelpOneAtt._createInstance(); // This is executed only once, singleton object
    }
    return _dbHelpOneAtt;
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
* storing the database and create the desired tables. I’m using entrys as the
* name of the database
* */
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'entrys.db';

    // Open/create the database at a given path
    var entrysDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return entrysDatabase;
  }

  /*creating the table*/
  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $entryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colValue TEXT, '
        '$colComment TEXT, $colDate TEXT)');
  }

  // Fetch Operation: Get all entry objects from database
  Future<List<Map<String, dynamic>>> getEntryMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $entryTable order by $colTitle ASC');
    var result = await db.query(entryTable, orderBy: '$colTitle ASC');
    return result;
  }

  // Insert Operation: Insert a entry object to database
  Future<int> insertEntry(Entry entry) async {
    Database db = await this.database; //  await keyword to wait for a future to complete
    var result = await db.insert(entryTable, entry.toMap());  // insert(table, row)
    return result;
  }

  // Update Operation: Update a entry object and save it to database
  Future<int> updateEntry(Entry entry) async {
    var db = await this.database;
    var result = await db.update(entryTable, entry.toMap(), where: '$colId = ?', whereArgs: [entry.id]);
    return result;
  }

  // Delete Operation: Delete a entry object from database
  Future<int> deleteEntry(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $entryTable WHERE $colId = $id');
    return result;
  }

  // Get number of entry objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $entryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'entry List' [ List<Entry> ]
  Future<List<Entry>> getEntryList() async {

    var entryMapList = await getEntryMapList(); // Get 'Map List' from database
    int countEntry = entryMapList.length;         // Count the number of map entries in db table

    List<Entry> entryList = List<Entry>();
    // For loop to create a 'entry List' from a 'Map List'
    for (int i = 0; i < countEntry; i++) {
      entryList.add(Entry.fromMapObject(entryMapList[i]));
    }

    return entryList;
  }

}