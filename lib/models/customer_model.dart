import 'package:point_of_sales/helpers/productdb.dart';

import '../helpers/accountdb.dart';
import '../helpers/customerdb.dart';

class CustomerModel {
  int id;
  String name;
  String phonenumber;
  int status;

  CustomerModel({
    this.id = 0,
    required this.name,
    required this.phonenumber,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      CustomerDBHelper.colName: name,
      CustomerDBHelper.colPhoneNumber: phonenumber,
      CustomerDBHelper.colStatus: status,
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json[CustomerDBHelper.colId],
      phonenumber: json[CustomerDBHelper.colPhoneNumber],
      name: json[CustomerDBHelper.colName],
      status: json[CustomerDBHelper.colStatus],
    );
  }
}
