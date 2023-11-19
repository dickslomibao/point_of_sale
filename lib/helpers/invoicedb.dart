import 'package:flutter/material.dart';
import 'package:point_of_sales/database/table_handler.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InvoiceDBHelper {
  static const tblName = 'invoice';
  static const colId = 'id';
  static const colPay = 'payment';
  static const colTotalAmount = 'total_amount';
  static const colDate = 'date_created';
  static const colProccessBy = 'process_by';
  static const colCustomerId = 'customer_id';
  static const colTenderedAmount = 'tendered_amount';

  static Future<Database> openDb() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(join(dbpath, DatabaseHandler.dbname));
  }

  static Future<void> createDB(Database db) async {
    await db.execute(
      '''
          CREATE TABLE $tblName(
            $colId TEXT PRIMARY KEY NOT NULL,
            $colPay DECIMAL,
            $colTotalAmount DECIMAL,
            $colTenderedAmount DECIMAL,
            $colDate DATETIME,
            $colProccessBy TEXT,
            $colCustomerId INTEGER DEFAULT 0
          )
      ''',
    );
    print('Invoice table created');
  }

  static Future<String> getTimeStamp(String id) async {
    final db = await openDb();

    List<Map<String, dynamic>> data =
        await db.query(tblName, where: '$colId = ?', whereArgs: [id]);
    return data.isEmpty ? "" : data.last[colDate];
  }

  static Future<void> firestoreInsert(element) async {
    final db = await openDb();
    await db.insert(tblName, element,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Invoice>> getList() async {
    List<Invoice> list = [];
    final db = await openDb();
    List<Map<String, dynamic>> data = await db.query(tblName);

    data.forEach((element) {
      list.add(Invoice(
        id: element[InvoiceDBHelper.colId],
        custumerPayAmount:
            double.parse(element[InvoiceDBHelper.colPay].toString()),
        totalAmount:
            double.parse(element[InvoiceDBHelper.colTotalAmount].toString()),
        date: element[InvoiceDBHelper.colDate],
        processBy: element[InvoiceDBHelper.colProccessBy].toString(),
        customerId: element[InvoiceDBHelper.colCustomerId].toString(),
        tenderedAmount:
            double.parse(element[InvoiceDBHelper.colTenderedAmount].toString()),
      ));
    });
    return list;
  }

  static Future<List<Map<String, dynamic>>> storeInFirebase() async {
    final db = await openDb();
    return await db.query(tblName);
  }

  static void insert(Invoice inv) async {
    final db = await openDb();
    await db.insert(
      tblName,
      inv.toMap(),
    );
  }

  static Future<void> update(Invoice inv, double amount) async {
    final db = await openDb();
    await db.update(
      tblName,
      {colPay: amount},
      where: '$colId = ?',
      whereArgs: [inv.id],
    );
  }

  static Future<List<Invoice>> getCustomerInvoice(String id) async {
    final db = await openDb();
    List<Map<String, dynamic>> data =
        await db.query(tblName, where: '$colCustomerId = ?', whereArgs: [id]);
    return data.map((e) => Invoice.fromJson(e)).toList();
  }

  static Future<Invoice?> getInvoiceWithId(String id) async {
    final db = await openDb();
    List<Map<String, dynamic>> data =
        await db.query(tblName, where: '$colId = ?', whereArgs: [id]);
    return data.isEmpty ? null : Invoice.fromJson(data.first);
  }
}
