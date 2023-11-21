import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/customerdb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:point_of_sales/models/product_model.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../helpers/productdb.dart';
import '../models/customer_model.dart';

class TransactionDetailsScreen extends StatefulWidget {
  TransactionDetailsScreen({super.key, required this.invoice});
  Invoice invoice;

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List<Product> _productlist = [];
  List<InvoiceLine> _invoiceLine = [];
  bool _isLoading = true;
  AccountModel? account;
  CustomerModel? customer;
  void _getList() async {
    final inv = await InvoiceLineDBHelper.getList();
    final product = await ProductDBHelper.getList();
    account = await AccountDbHelper.getSingleList(widget.invoice.processBy);
    customer = await CustomerDBHelper.getSingleList(widget.invoice.customerId);
    setState(() {
      inv.forEach((element) {
        if (element.invoiceId == widget.invoice.id) {
          _invoiceLine.add(element);
        }
      });
      _productlist = product;
      _isLoading = false;
    });
  }

  int _totalItem() {
    int total = 0;
    _invoiceLine.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction Details",
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Price: Php ${widget.invoice.totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if ((widget.invoice.totalAmount -
                                    widget.invoice.custumerPayAmount) !=
                                0)
                              Text(
                                "Balance: Php ${(widget.invoice.totalAmount - widget.invoice.custumerPayAmount).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total Product: ${_invoiceLine.length}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Total Items: ${_totalItem()}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (customer != null)
                              Text(
                                "Customer: ${customer!.name}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Text(
                              "Cash Tendered: Php ${widget.invoice.tenderedAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Process By: ${account!.name}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Order list:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, .7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _invoiceLine.length,
                      itemBuilder: (context, index) {
                        Product product = _productlist.singleWhere(
                          (temp) => temp.id == _invoiceLine[index].productId,
                          orElse: () => Product(
                            barcode: "",
                            name: "",
                            catId: 0,
                            description: "",
                            price: 0.00,
                            retailPrice: 0,
                          ),
                        );
                        return Card(
                          child: ListTile(
                            subtitle: Text(
                              "Total Price: ${_invoiceLine[index].subTotal()}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 0, 0, .7),
                              ),
                            ),
                            title: Text(
                              product.name != ""
                                  ? product.name
                                  : "<Product not found>",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            trailing: Text(
                              "Qty: ${_invoiceLine[index].qty}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 0, 0, .7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      drawer: const MyDrawer(),
    );
  }
}
