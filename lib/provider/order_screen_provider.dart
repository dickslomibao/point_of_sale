import 'package:flutter/material.dart';
import '../components/add_order_qty_modal_components.dart';
import '../helpers/productdb.dart';
import '../models/customer_model.dart';
import '../models/invoice_line_model.dart';
import '../models/invoice_model.dart';
import '../models/product_model.dart';

class OrderScreenProvider extends ChangeNotifier {
  CustomerModel? customer;
  List<InvoiceLine> orderList = [];
  List<Product> productList = [];
  bool isLoading = true;

  Future<void> initData() async {
    orderList = [];
    productList = [];
    final data = await ProductDBHelper.getList();
    productList = data;
    isLoading = false;
    notifyListeners();
  }

  void minus(int pId) {
    for (var order in orderList) {
      if (order.productId == pId) {
        order.qty -= 1;
        if (order.qty == 0) {
          orderList.removeWhere((element) => element.productId == pId);
        }
        notifyListeners();
        break;
      }
    }
  }

  void addORder(
    BuildContext context,
    String barcodeScanRes,
  ) {
    bool barcodeIsValid = false;
    Product? product;
    for (var temp in productList) {
      if (temp.barcode == barcodeScanRes) {
        product = temp;
        barcodeIsValid = true;
        break;
      }
    }
    if (barcodeIsValid) {
      if (product!.stock <= 0 && product.type == 1) {
        showAlert(
            context: context, message: '${product.name} is out of stock.');
        return;
      }
      bool productIsNotIn = true;
      for (var order in orderList) {
        if (order.productId == product.id) {
          productIsNotIn = false;
          if ((order.qty + 1) > product.stock && product.type == 1) {
            showAlert(
                context: context,
                message: "The item have only ${product.stock} stock.");
          } else {
            order.qty += 1;
            notifyListeners();
            break;
          }
        }
      }
      if (productIsNotIn) {
        orderList.add(
          InvoiceLine(
            retailPirce: product.retailPrice,
            productId: product.id,
            productPrice: product.price,
            qty: 1,
          ),
        );
        notifyListeners();
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return MyAlertQtyModal(
        //       tempProduct: product!,
        //       controller: qtyController,
        //       add: () {
        //         if (qtyController.text == "") {
        //           showAlert(context: context, message: "Quantity is required.");
        //           return;
        //         }
        //         if (int.tryParse(qtyController.text) == null) {
        //           showAlert(context: context, message: "Invalid Quantity.");
        //           return;
        //         }
        //         if (int.parse(qtyController.text) <= 0) {
        //           showAlert(
        //               context: context,
        //               message: "Can't Add Zero or Negative value.");
        //           return;
        //         }
        //         int qty = int.parse(qtyController.text);
        //         if (qty > product!.stock) {
        //           showAlert(
        //               context: context,
        //               message: "The items have only ${product.stock} stock");
        //           return;
        //         }

        //         orderList.add(
        //           InvoiceLine(
        //             retailPirce: product.retailPrice,
        //             productId: product.id,
        //             productPrice: product.price,
        //             qty: qty,
        //           ),
        //         );
        //         notifyListeners();
        //         Navigator.of(context).pop();
        //       },
        //     );
        //   },
        // );
      }
    } else {
      showAlert(context: context, message: 'Item not found');
    }
    // qtyController.clear();
    // barcodeController.clear();
  }

  void showAlert({required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
      ),
    );
  }
}
