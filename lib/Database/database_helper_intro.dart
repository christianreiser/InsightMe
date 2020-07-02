import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'intro.dart';

class DatabaseHelperIntro {
  static DatabaseHelperIntro
  _databaseHelperIntro; // Singleton DatabaseHelperIntro
  static Database _database; // Singleton Database

  static final String introTable = 'intro_table';
  static final String colId = 'id';
  static final String colTitle =
      'title'; // TODO rename to attribute also for attribute_helper
  static final String colValue = 'value';
  static final String colComment = 'comment';
  static final String colDate = 'date'; // TODO rename to time

  DatabaseHelperIntro._createInstance(); // Named constructor to create instance of DatabaseHelperIntro

  factory DatabaseHelperIntro() {
    if (_databaseHelperIntro == null) {
      _databaseHelperIntro = DatabaseHelperIntro
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelperIntro;
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
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'intros.db';

    // Open/create the database at a given path
    var introsDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return introsDatabase;
  }

  /*creating the table*/
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $introTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colValue TEXT, '
        '$colComment TEXT, $colDate TEXT)'); // TODO $colValue REAL for double
  }

  // Fetch Operation: Get all intro objects from database
  Future<List<Map<String, dynamic>>> getIntroMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $introTable order by $colTitle ASC');
    var result = await db.query(introTable, orderBy: '$colDate DESC');
    return result;
  }

  // CHREI Fetch Operation: Get intro objects from database FILTERED ATTRIBUTES

  Future<List<Map<String, dynamic>>> getFilteredIntroMapList(
      attributeToFilter) async {
    // get single row
    List<String> columnsToSelect = [
      DatabaseHelperIntro.colValue,
      DatabaseHelperIntro.colDate,
      DatabaseHelperIntro.colId,
      DatabaseHelperIntro.colTitle,
      DatabaseHelperIntro.colComment,
    ];
    String whereString = '${DatabaseHelperIntro.colTitle} = ?';
    List<dynamic> whereArguments = [attributeToFilter];
    Database db = await this.database;

    var result = await db.query(introTable,
        orderBy: '$colDate ASC',
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    //result.forEach((row) => print(row)); // needed?

    return result;
  }

  // Insert Operation: Insert a intro object to database
  Future<int> insertIntro(Intro intro) async {
    Database db =
    await this.database; //  await keyword to wait for a future to complete
    var result =
    await db.insert(introTable, intro.toMap()); // insert(table, row)
    return result;
  }

  // Update Operation: Update a intro object and save it to database
  Future<int> updateIntro(Intro intro) async {
    var db = await this.database;
    var result = await db.update(introTable, intro.toMap(),
        where: '$colId = ?', whereArgs: [intro.id]);
    return result;
  }

  // CHREI: Rename Operation: Rename all intro object with given title and save it
  // to database
  Future<List<int>> renameIntro(newAttributeTitle, oldAttributeTitle) async {
    List<int> resultList = [];
    var db = await this.database;
    List<Intro> filteredIntroList =
    await getFilteredIntroList(oldAttributeTitle);
    for (int i = 0; i < filteredIntroList.length; i++) {
      filteredIntroList[i].title = newAttributeTitle;

      var result = await db.update(introTable, filteredIntroList[i].toMap(),
          where: '$colId = ?', whereArgs: [filteredIntroList[i].id]);
      resultList.add(result);
    }
    return resultList;
  }

  // Delete Operation: Delete a intro object from database
  Future<int> deleteIntro(int id) async {
    var db = await this.database;
    int result =
    await db.rawDelete('DELETE FROM $introTable WHERE $colId = $id');
    return result;
  }

  // Get number of intro objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $introTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'intro List' [ List<Intro> ]
  Future<List<Intro>> getIntroList() async {
    var introMapList = await getIntroMapList(); // Get 'Map List' from database
    int countIntro =
        introMapList.length; // Count the number of map entries in db table

    List<Intro> introList = List<Intro>();
    // For loop to create a 'intro List' from a 'Map List'
    for (int i = 0; i < countIntro; i++) {
      introList.add(Intro.fromMapObject(introMapList[i]));
    }

    return introList;
  }

  // CHREI get the 'Map List' [ List<Map> ] FILTERED and convert it to 'intro List FILTERED' [ List<Intro> ]
  Future<List<Intro>> getFilteredIntroList(attributeNameToFilter) async {
    var filteredIntroMapList = await getFilteredIntroMapList(
        attributeNameToFilter); // Get 'Map List' from database
    int countIntroFiltered = filteredIntroMapList
        .length; // Count the number of map entries in db table

    List<Intro> filteredIntroList = List<Intro>();
    // For loop to create a 'intro List' from a 'Map List'
    for (int i = 0; i < countIntroFiltered; i++) {
      filteredIntroList.add(Intro.fromMapObject(filteredIntroMapList[i]));
    }
    //filteredIntroList.forEach((row) => print(row)); // todo needed?
    return filteredIntroList;
  }
}
