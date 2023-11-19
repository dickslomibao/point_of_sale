import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:point_of_sales/components/staff_card_component.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/screen/customer_view_screen.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import '../components/add_account_modal_component.dart';
import '../components/add_customer_modal_component.dart';
import '../components/add_product_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/customer_card_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/product_card_component.dart';
import '../helpers/customerdb.dart';
import '../models/customer_model.dart';

class CustomerScreen extends StatefulWidget {
  CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<CustomerModel> customer = [];

  bool _isLoading = true;
  void getCustomerList() async {
    customer = await CustomerDBHelper.getList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Customer",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AddCustomerModal(
                    add: (customer) async {
                      await CustomerDBHelper.insert(customer);
                      getCustomerList();
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    size: 24,
                  ),
                  Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : customer.isEmpty
              ? const Center(
                  child: Text(
                    'Customer is empty',
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
                    itemCount: customer.length,
                    itemBuilder: (context, index) {
                      final c = customer[index];
                      return CustomerCard(
                        customer: c,
                        onDismissed: () {},
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: CustomerViewScren(customer: c),
                            withNavBar: false,
                          );
                        },
                        onUpdate: () {},
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
    );
  }
}
