import 'package:flutter/material.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/account_model.dart';

import '../helpers/customerdb.dart';
import '../models/customer_model.dart';
import '../models/invoice_line_model.dart';
import '../models/invoice_model.dart';

class AccountDetailsProvider extends ChangeNotifier {
  AccountModel? account;
  List<Invoice>? invoice;
  double salesToday = 0;
  bool isLoading = true;

  Future<void> initData(String id) async {
    account = await AccountDbHelper.getSingleList(id);
    invoice = await InvoiceDBHelper.getStaffInvoice(id);
    for (var element in invoice!) {
      final date = DateTime.now();
      final productDate = DateTime.parse(element.date);
      int yearToday = date.year;
      int monthToday = date.month;
      int productYear = productDate.year;
      int productMonth = productDate.month;

      if (yearToday == productYear) {
        if (monthToday == productMonth) {
          if (date.day == productDate.day) {
            salesToday += element.totalAmount;
          }
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  // double getBalance() {
  //   double balance = 0;
  //   final unPaid = invoice!
  //       .where((element) => element.custumerPayAmount != element.totalAmount)
  //       .toList();
  //   for (var element in unPaid) {
  //     balance += element.totalAmount - element.custumerPayAmount;
  //   }
  //   return balance;
  // }

  // Future<void> makePayment(String customerId, double amount) async {
  //   final unPaid = invoice!
  //       .where((element) => element.custumerPayAmount != element.totalAmount)
  //       .toList();
  //   for (var element in unPaid) {
  //     if (amount >= 1) {
  //       double b = element.totalAmount - element.custumerPayAmount;
  //       if (amount >= b) {
  //         await InvoiceDBHelper.update(element, element.totalAmount);
  //       } else {
  //         await InvoiceDBHelper.update(
  //             element, element.custumerPayAmount + amount);
  //         break;
  //       }
  //       amount = amount - b;
  //     }
  //   }
  //   await initData(customerId);
  // }
}
