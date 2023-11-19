import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/inventory_product_card_components.dart';
import '../helpers/productdb.dart';
import 'inventory_product_details_screen.dart';

class InventoryScreen extends StatefulWidget {
  InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    var p = _productlist.where((element) => element.barcode == barcodeScanRes);
    if (p.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return InventoryDetailsScreen(product: p.first);
        },
      ));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Invalid Barcode"),
        ),
      );
    }
  }

  var _productlist = [];
  bool _isLoading = true;

  void _getProductList() async {
    final data = await ProductDBHelper.getList();
    setState(() {
      _productlist = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              scanBarcodeNormal();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.document_scanner_outlined,
                size: 30,
              ),
            ),
          )
        ],
        title: const Text(
          "Inventory",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _productlist.isEmpty
              ? const Center(
                  child: Text(
                    'Product is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _productlist.length,
                    itemBuilder: (context, index) {
                      return InventoryProductCard(
                        onUpdate: () {
                          _getProductList();
                        },
                        product: _productlist[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return InventoryDetailsScreen(
                                  product: _productlist[index],
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
    );
  }
}
