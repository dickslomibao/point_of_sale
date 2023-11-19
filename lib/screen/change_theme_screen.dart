import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:point_of_sales/components/staff_card_component.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/provider/theme_color.dart';
import 'package:point_of_sales/screen/customer_view_screen.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import 'package:provider/provider.dart';
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

class ThemeScreen extends StatefulWidget {
  ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Color Theme",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          itemCount: theme.colors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                theme.changeColor(theme.colors[index]);
              },
              child: CircleAvatar(
                backgroundColor: theme.colors[index],
              ),
            );
          },
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
