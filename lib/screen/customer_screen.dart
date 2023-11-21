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
import '../components/text_field_component.dart';
import '../helpers/customerdb.dart';
import '../models/customer_model.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key, this.f});
  final Function? f;
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<CustomerModel> customer = [];
  List<CustomerModel> clone = [];
  bool _isLoading = true;
  void getCustomerList() async {
    customer = await CustomerDBHelper.getList();
    clone = customer;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomerList();
  }

  TextEditingController searchController = TextEditingController();

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
                children: const [
                  Icon(
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
          : clone.isEmpty
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
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFieldComponents(
                          label: "Search",
                          controller: searchController,
                          onchange: (value) {
                            setState(() {
                              if (value == "") {
                                customer = clone;
                                return;
                              }
                              customer = clone
                                  .where((e) => e.name.contains(value))
                                  .toList();
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: customer.length,
                          itemBuilder: (context, index) {
                            final c = customer[index];
                            return CustomerCard(
                              customer: c,
                              onDismissed: () {},
                              onTap: () {
                                if (widget.f != null) {
                                  widget.f!(c);
                                  return;
                                }
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
                    ],
                  ),
                ),
      drawer: MyDrawer(),
    );
  }
}
