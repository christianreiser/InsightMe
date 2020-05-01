//import 'dart:io' show Directory;
//import 'package:path/path.dart' show join;
//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
//
//class DatabaseHelperVisualize {
//
//  static final _databaseName = "MyDatabase.db";
//  static final _databaseVersion = 1;
//
//  static final table = 'my_table';
//
//  static final columnId = '_id';
//  static final columnName = 'name';
//  static final columnAge = 'age';
//
//  // make this a singleton class
//  DatabaseHelperVisualize._privateConstructor();
//  static final DatabaseHelperVisualize instance = DatabaseHelperVisualize._privateConstructor();
//
//  // only have a single app-wide reference to the database
//  static Database _database;
//  Future<Database> get database async {
//    if (_database != null) return _database;
//    // lazily instantiate the db the first time it is accessed
//    _database = await _initDatabase();
//    return _database;
//  }
//
//  // this opens the database (and creates it if it doesn't exist)
//  _initDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, _databaseName);
//    return await openDatabase(path,
//        version: _databaseVersion,
//        onCreate: _onCreate);
//  }
//
//  // SQL code to create the database table
//  Future _onCreate(Database db, int version) async {
//    await db.execute('''
//          CREATE TABLE $table (
//            $columnId INTEGER PRIMARY KEY,
//            $columnName TEXT NOT NULL,
//            $columnAge INTEGER NOT NULL
//          )
//          ''');
//
//    // prepopulate a few rows (consider using a transaction)
//    await db.rawInsert('INSERT INTO $table ($columnName, $columnAge) VALUES("Bob", 23)');
//    await db.rawInsert('INSERT INTO $table ($columnName, $columnAge) VALUES("Mary", 32)');
//    await db.rawInsert('INSERT INTO $table ($columnName, $columnAge) VALUES("Susan", 12)');
//  }
//}
