import 'package:point_of_sales/models/account_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../database/table_handler.dart';
import '../models/category_model.dart';

class AccountDbHelper {
  static const dbVersion = 1;
  static const tblName = 'staff';
  static const colId = 'id';
  static const colName = 'name';
  static const colFeatures = 'features';
  static const colbirthDate = 'birthdate';
  static const colPin = 'pin';
  static const colStatus = 'status';
  static Future<Database> openDb() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(
      p.join(dbpath, DatabaseHandler.dbname),
    );
  }

  static Future<void> createDB(Database db) async {
    await db.execute(
      '''
          CREATE TABLE $tblName(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colName TEXT NOT NULL,
          $colFeatures TEXT NOT NULL,
          $colbirthDate TEXT NOT NULL,
          $colPin TEXT NOT NULL,
          $colStatus INTEGER DEFAULT 1
          )
          ''',
    );
    print('Staff table created');
  }

  static Future<int> insert(AccountModel account) async {
    final db = await openDb();
    int id = await db.insert(
      tblName,
      account.toMap(),
    );
    return id;
  }

  static Future<void> firestoreInsert(element) async {
    final db = await openDb();
    await db.insert(tblName, element,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<AccountModel>> getList() async {
    final db = await openDb();
    final data = await db.query(tblName, where: '$colId != ?', whereArgs: [1]);

    return data.map((e) => AccountModel.fromJson(e)).toList();
  }

  static Future<int> delete(int id) async {
    final db = await openDb();
    return db.delete(tblName, where: '$colId = ?', whereArgs: [id]);
  }

  static Future<AccountModel?> getSingleList(String id) async {
    final db = await openDb();
    final data = await db.query(tblName, where: '$colId = ?', whereArgs: [id]);
    return data.isEmpty ? null : AccountModel.fromJson(data.first);
  }

  static Future<Map<String, Object?>> getSingleListUsingPin(String pin) async {
    final db = await openDb();
    final data =
        await db.query(tblName, where: '$colPin = ?', whereArgs: [pin]);
    return data.isEmpty ? {} : data.first;
  }

  static void update(Category category) async {
    final db = await openDb();
    db.update(
      tblName,
      category.toMap(),
      where: '$colId = ?',
      whereArgs: [category.id],
    );
  }
}
