import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/staff_card_component.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import '../components/add_account_modal_component.dart';
import '../components/add_product_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/product_card_component.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<AccountModel> staffs = [];

  bool _isLoading = true;
  void _getStaffList() async {
    staffs = await AccountDbHelper.getList();
    print(staffs);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getStaffList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Staff",
          style: GoogleFonts.lato(
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
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        toolbarHeight: 60,
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : staffs.isEmpty
              ? Center(
                  child: Text(
                    'Account is empty',
                    style: GoogleFonts.poppins(
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
                        onTap: () {},
                        onUpdate: () {},
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
    );
  }
}
