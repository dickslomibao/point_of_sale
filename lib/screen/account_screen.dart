import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:point_of_sales/components/staff_card_component.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import 'package:point_of_sales/screen/transaction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/add_account_modal_component.dart';
import '../components/add_product_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/product_card_component.dart';
import 'account_details_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<AccountModel> staffs = [];
  bool isAdmin = false;
  bool _isLoading = true;
  void _getStaffList() async {
    staffs = await AccountDbHelper.getList();

    final s = await SharedPreferences.getInstance();
    if (s.getString('id') == "1") {
      isAdmin = true;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getStaffList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Staff",
          style: TextStyle(
            fontSize: 18,
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
                  return AddAccountModal(
                    add: (account) async {
                      await AccountDbHelper.insert(account);
                      _getStaffList();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              );
            },
            child: Visibility(
              visible: isAdmin,
              child: Container(
                margin: const EdgeInsets.only(right: 20),
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
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : !isAdmin
              ? const Center(
                  child: Text(
                    "Can't Access",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : staffs.isEmpty
                  ? const Center(
                      child: Text(
                        'Account is empty',
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
                        itemCount: staffs.length,
                        itemBuilder: (context, index) {
                          final s = staffs[index];
                          return StaffCard(
                            account: s,
                            onDismissed: () {},
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: AccountDetailsScreen(
                                  acoount: s,
                                ),
                                // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                            onUpdate: () {
                              _getStaffList();
                            },
                          );
                        },
                      ),
                    ),
      drawer: const MyDrawer(),
    );
  }
}
