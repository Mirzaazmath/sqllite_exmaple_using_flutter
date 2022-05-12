

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'car.dart';

class DatabaseHelper {

  static const _databaseName = "cardb.db";
  static const _databaseVersion = 1;

  static const table = 'cars_table';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnMiles = 'miles';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance= DatabaseHelper._privateConstructor();

  Future<Database?> get database async{
    _database ??= await _initDatabase();
    return _database;


  }

  _initDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,version: _databaseVersion, onCreate: _onCreate);
  }


  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnMiles TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int?> insert(Car car) async {
    Database? db = await instance.database;
    return await db?.insert(table, {'name': car.name, 'miles': car.miles});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>?> queryAllRows() async {
    Database? db = await instance.database;
    return await db?.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>?> queryRows(name) async {
    Database? db = await instance.database;
    return await db?.query(table, where: "$columnName LIKE '%$name%'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  /*Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery('SELECT COUNT(*) FROM $table'));
  }*/

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int?> update(Car car) async {
    Database? db = await instance.database;
    //int id = car.toMap()['id'];
    return await db?.update(table, car.toMap(), where: '$columnName = ?', whereArgs: [car.name]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int?> delete(String name) async {
    Database? db = await instance.database;
    return await db?.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }


}