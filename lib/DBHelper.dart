
import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class DatabaseHelper {
  static final _databaseName = "WORDSDB.db";
  static final _databaseVersion = 1;
  static final table = 'WORDS';
  static final columnId = 'ID';
  static final columnName = 'WORD';
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
 CREATE TABLE $table (
 $columnId INTEGER PRIMARY KEY AUTOINCREMENT ,
 $columnName TEXT NOT NULL
 )
 ''');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : 'LIME',
    };
   await db.insert(table,row);
     row = {
      DatabaseHelper.columnName : 'KIWI',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'PLUM',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'CORN',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'TAKE',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'GIVE',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'LOVE',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'HATE',
    };
    await db.insert(table,row);
    row = {
      DatabaseHelper.columnName : 'READ',
    };
    await db.insert(table,row);
    prefs.setInt("idx", 0);
    prefs.setInt("score",0);
  }
  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
// après on peut définir les autres méthodes delete, update, etc.
}