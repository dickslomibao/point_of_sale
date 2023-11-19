import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/product_model.dart';

import '../color.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({super.key, required this.product});
  Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var _category = [];
  List<InvoiceLine> _productOrderList = [];
  bool _isLoading = true;

  void _getList() async {
    final data = await CategoryDBHelper.getSingleList(widget.product.catId);
    final list =
        await InvoiceLineDBHelper.getListofSingleProduct(widget.product.id);
    setState(() {
      _productOrderList = list;
      _category = data;
      _isLoading = false;
    });
  }

  int _totalSold() {
    int total = 0;
    _productOrderList.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  double _totalSales() {
    double total = 0;
    _productOrderList.forEach((element) {
      total += element.subTotal();
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
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: const TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${widget.product.name}",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Descriptions: ${widget.product.description}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                              Text(
                                "Barcode: ${widget.product.barcode}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                              Text(
                                "Category: ${_category.isEmpty ? '<not found>' : _category.last[CategoryDBHelper.colTitle]}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                              Text(
                                "Retail price: ${widget.product.retailPrice}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                              Text(
                                "Price: ${widget.product.price}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                              Text(
                                "Stock: ${widget.product.stock}",
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                  color: widget.product.stock < 6
                                      ? Colors.red
                                      : Colors.black87,
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
                        "Product summary:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 0, 0, .7),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Card(
                        color: primary,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total sold items: ${_totalSold()}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Total Sales: ${_totalSales()}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      drawer: const MyDrawer(),
    );
  }
}
