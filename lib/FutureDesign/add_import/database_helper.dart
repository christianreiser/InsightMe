import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper _INSTANCE = new DatabaseHelper.make();

  factory DatabaseHelper() => _INSTANCE;

  static Database _db;

  DatabaseHelper.make();
}