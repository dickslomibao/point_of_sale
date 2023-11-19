import 'package:point_of_sales/helpers/invoicedb.dart';

class Invoice {
  String id;
  double custumerPayAmount;
  double totalAmount;
  String date;
  String processBy;
  String customerId;
  double tenderedAmount;
  Invoice({
    required this.id,
    required this.custumerPayAmount,
    this.totalAmount = 0,
    this.date = "",
    required this.processBy,
    required this.customerId,
    required this.tenderedAmount,
  });
  Map<String, dynamic> toMap() {
    return {
      InvoiceDBHelper.colId: id,
      InvoiceDBHelper.colPay: custumerPayAmount,
      InvoiceDBHelper.colTotalAmount: totalAmount,
      InvoiceDBHelper.colDate: DateTime.now().toString(),
      InvoiceDBHelper.colProccessBy: processBy,
      InvoiceDBHelper.colCustomerId: customerId,
      InvoiceDBHelper.colTenderedAmount: tenderedAmount,
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      customerId: json[InvoiceDBHelper.colCustomerId].toString(),
      custumerPayAmount: double.parse(json[InvoiceDBHelper.colPay].toString()),
      id: json[InvoiceDBHelper.colId].toString(),
      processBy: json[InvoiceDBHelper.colProccessBy].toString(),
      date: json[InvoiceDBHelper.colDate],
      totalAmount:
          double.parse(json[InvoiceDBHelper.colTotalAmount].toString()),
      tenderedAmount:
          double.parse(json[InvoiceDBHelper.colTenderedAmount].toString()),
    );
  }
}
