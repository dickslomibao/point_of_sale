import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/product_model.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../components/add_product_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/product_card_component.dart';
import '../components/select_product_moda_order.dart';
import '../components/text_field_component.dart';
import '../provider/order_screen_provider.dart';

class AddProductScreenForOrder extends StatefulWidget {
  AddProductScreenForOrder({super.key, required this.onTap});

  @override
  State<AddProductScreenForOrder> createState() =>
      _AddProductScreenForOrderState();
  Function onTap;
}

class _AddProductScreenForOrderState extends State<AddProductScreenForOrder> {
  List<Product> searchResult = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Product",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldComponents(
              label: "Product name or barcode",
              controller: searchController,
              onchange: (value) {
                setState(() {
                  if (value == "") {
                    searchResult = [];
                    return;
                  }
                  searchResult = context
                      .read<OrderScreenProvider>()
                      .productList
                      .where((element) =>
                          element.barcode.contains(value) ||
                          element.name.contains(value))
                      .toList();
                });
              },
            ),
            const Text(
              "Result:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: searchResult.isEmpty
                  ? const Center(
                      child: Text(
                        "No product found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, index) {
                        return SelectProductCard(
                          onTap: () {
                            widget.onTap(searchResult[index]);
                          },
                          product: searchResult[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
