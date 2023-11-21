import 'package:point_of_sales/helpers/productdb.dart';

class Product {
  int id;
  String barcode;
  String name;
  int catId;
  String description;
  int stock;
  double price;
  double retailPrice;
  int type;
  Product({
    this.id = 0,
    required this.barcode,
    required this.name,
    required this.catId,
    required this.description,
    this.stock = 0,
    required this.price,
    required this.retailPrice,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      ProductDBHelper.colBarcode: barcode,
      ProductDBHelper.colTitle: name,
      ProductDBHelper.colCatId: catId,
      ProductDBHelper.colDescription: description,
      ProductDBHelper.colStock: stock,
      ProductDBHelper.colPrice: price,
      ProductDBHelper.colReatailPrice: retailPrice,
      ProductDBHelper.colType: type
    };
  }

  // List<dynamic> toList() {
  //   return [
  //     barcode,
  //     name,
  //     catId,
  //     description,
  //     stock,
  //     price,
  //   ];
  // }
}
