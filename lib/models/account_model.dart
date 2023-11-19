import 'package:point_of_sales/helpers/productdb.dart';

import '../helpers/accountdb.dart';

class AccountModel {
  int id;
  String name;
  String birthdate;
  String features;
  String pin;
  int status;
  AccountModel({
    this.id = 0,
    required this.name,
    required this.birthdate,
    required this.features,
    required this.pin,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      AccountDbHelper.colName: name,
      AccountDbHelper.colbirthDate: birthdate,
      AccountDbHelper.colFeatures: features,
      AccountDbHelper.colPin: pin,
    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json[AccountDbHelper.colId],
      birthdate: json[AccountDbHelper.colbirthDate],
      name: json[AccountDbHelper.colName],
      features: json[AccountDbHelper.colFeatures],
      pin: json[AccountDbHelper.colPin],
      status: json[AccountDbHelper.colStatus],
    );
  }
}
