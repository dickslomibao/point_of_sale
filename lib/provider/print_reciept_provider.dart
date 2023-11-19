import 'dart:math';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../helpers/customerdb.dart';
import '../models/customer_model.dart';
import '../models/invoice_line_model.dart';
import '../models/product_model.dart';

class PrintRecieptProvider extends ChangeNotifier {
  String orderId = "";
  Invoice? invoice;
  List<InvoiceLine>? invoiceLine;
  CustomerModel? customer;
  AccountModel? staff;

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  BluetoothDevice? device;

  Future initData(String orderID) async {
    orderId = orderID;
    initPrinter();
    invoice = await InvoiceDBHelper.getInvoiceWithId(orderId);
    invoiceLine = await InvoiceLineDBHelper.getInvoiceOrderList(orderId);
    customer =
        await CustomerDBHelper.getSingleList(invoice!.customerId.toString());
    staff = await AccountDbHelper.getSingleList(invoice!.processBy.toString());
  }

  void initPrinter() {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));
    bluetoothPrint.state.listen((state) async {
      debugPrint('******************* cur device status: $state');
      switch (state) {
        case BluetoothPrint.CONNECTED:
          print('connetded');

          break;
        case BluetoothPrint.DISCONNECTED:
          break;
        default:
          break;
      }
    });
  }

  Future<List<LineText>> startPrinting(List<LineText> additional) async {
    DateTime now = DateTime.now();
    List<LineText> list = [];

    list.add(
      LineText(
        type: LineText.TYPE_QRCODE,
        content: orderId,
        weight: 1,
        height: 100,
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Itrack',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(type: LineText.TYPE_TEXT, content: " ", linefeed: 1),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "--------------------------------",
        linefeed: 1,
        align: LineText.ALIGN_CENTER,
      ),
    );
    if (customer != null) {
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: 'Customer: ${customer!.name}',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      );
    }
    if (staff != null) {
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: 'Process by: ${staff!.name}',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      );
    }

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Date: ${DateFormat('MM/dd/yy h:mm:ss a').format(DateTime.parse(invoice!.date))}',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Print Date: ${DateFormat('MM/dd/yy h:mm:ss a').format(now)}',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "--------------------------------",
        linefeed: 1,
        align: LineText.ALIGN_CENTER,
      ),
    );

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Product Item(s)',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(
      LineText(type: LineText.TYPE_TEXT, content: " ", linefeed: 1),
    );
    for (var element in invoiceLine!) {
      Product? p =
          await ProductDBHelper.getSingleProduct(element.productId.toString());
      if (p == null) {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: '--Product Not Found--',
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          ),
        );
      } else {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: '${p.name} (${p.measurement})',
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          ),
        );
      }
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content:
              '${element.productPrice} * ${element.qty} = ${element.subTotal()}',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      );
    }
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "--------------------------------",
        linefeed: 1,
        align: LineText.ALIGN_CENTER,
      ),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total amount: Php ${invoice!.totalAmount.toStringAsFixed(2)}',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
    );
    list.addAll(additional);

    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: "--------------------------------",
        linefeed: 1,
        align: LineText.ALIGN_CENTER,
      ),
    );
    list.add(
      LineText(type: LineText.TYPE_TEXT, content: " ", linefeed: 1),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Itrack',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(type: LineText.TYPE_TEXT, content: " ", linefeed: 1),
    );
    list.add(
      LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Developed by Information Technology student of Pangasinan State University, Urdaneta Campus.',
        weight: 0,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
    );
    list.add(
      LineText(type: LineText.TYPE_TEXT, content: " ", linefeed: 1),
    );
    list.add(
      LineText(type: LineText.TYPE_TEXT, content: " ", linefeed: 1),
    );
    return list;
  }
}
