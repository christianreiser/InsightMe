//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_migration/sqflite_migration.dart';
//
//final initialScript = [
//  'CREATE TABLE $attributeTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
//      ' $colTitle TEXT)',
//];
//
//final migrations = [
//  '''
//  alter table $attributeTable add column note TEXT default 0;
//  '''
//];
//
//final config = MigrationConfig(
//    initializationScript: initialScript, migrationScripts: migrations);
//
//Future<Database> open() async {
//  final databasesPath = await getDatabasesPath();
//  final path = join(databasesPath, 'attributes.db');
//
//  return await openDatabaseWithMigration(path, config);
//}
