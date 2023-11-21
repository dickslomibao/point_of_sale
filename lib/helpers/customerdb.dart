import 'package:flutter/material.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../database/table_handler.dart';
import '../models/category_model.dart';
import '../models/customer_model.dart';

class CustomerDBHelper {
  static const dbVersion = 1;
  static const tblName = 'customer';
  static const colId = 'id';
  static const colName = 'name';
  static const colPhoneNumber = 'phonenumber';
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
          $colPhoneNumber TEXT NOT NULL,
          $colStatus INTEGER DEFAULT 1
          )
          ''',
    );
    debugPrint('Customer table created');
  }

  static Future<int> insert(CustomerModel customer) async {
    final db = await openDb();
    int id = await db.insert(
      tblName,
      customer.toMap(),
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> storeInFirebase() async {
    final db = await openDb();
    return await db.query(tblName);
  }

  static Future<void> firestoreInsert(element) async {
    final db = await openDb();
    await db.insert(tblName, element,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<CustomerModel>> getList() async {
    final db = await openDb();
    final data = await db.query(tblName);
    return data.map((e) => CustomerModel.fromJson(e)).toList();
  }

  static Future<int> delete(int id) async {
    final db = await openDb();
    return db.delete(tblName, where: '$colId = ?', whereArgs: [id]);
  }

  static Future<CustomerModel?> getSingleList(String id) async {
    final db = await openDb();
    final data = await db.query(tblName, where: '$colId = ?', whereArgs: [id]);
    return data.isEmpty ? null : CustomerModel.fromJson(data.first);
  }

  static void update(CustomerModel customer) async {
    final db = await openDb();
    db.update(
      tblName,
      customer.toMap(),
      where: '$colId = ?',
      whereArgs: [customer.id],
    );
  }
}
