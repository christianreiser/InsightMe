import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'attribute.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String attributeTable = 'attribute_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
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
* storing the database and create the desired tables. I’m using attributes as the
* name of the database
* */
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'attributes.db';

    // Open/create the database at a given path
    var attributesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return attributesDatabase;
  }

  /*creating the table*/
  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $attributeTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colDate TEXT)');
  }

  // Fetch Operation: Get all attribute objects from database
  Future<List<Map<String, dynamic>>> getAttributeMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $attributeTable order by $colTitle ASC');
    var result = await db.query(attributeTable, orderBy: '$colTitle ASC');
    return result;
  }

  // Insert Operation: Insert a attribute object to database
  Future<int> insertAttribute(Attribute attribute) async {
    Database db = await this.database;
    var result = await db.insert(attributeTable, attribute.toMap());
    return result;
  }

  // Update Operation: Update a attribute object and save it to database
  Future<int> updateAttribute(Attribute attribute) async {
    var db = await this.database;
    var result = await db.update(attributeTable, attribute.toMap(), where: '$colId = ?', whereArgs: [attribute.id]);
    return result;
  }


  // Delete Operation: Delete a attribute object from database
  Future<int> deleteAttribute(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $attributeTable WHERE $colId = $id');
    return result;
  }

  // Get number of attribute objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $attributeTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'attribute List' [ List<Attribute> ]
  Future<List<Attribute>> getAttributeList() async {

    var attributeMapList = await getAttributeMapList(); // Get 'Map List' from database
    int count = attributeMapList.length;         // Count the number of map entries in db table

    List<Attribute> attributeList = List<Attribute>();
    // For loop to create a 'attribute List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      attributeList.add(Attribute.fromMapObject(attributeMapList[i]));
    }

    return attributeList;
  }

}