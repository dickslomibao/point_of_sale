import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/theme_color.dart';
import '../screen/product_details_screen.dart';

class PopularProductCard extends StatelessWidget {
  PopularProductCard(
      {Key? key,
      required this.product,
      required this.totalsales,
      required this.totalsold})
      : super(key: key);

  final Product product;

  double totalsales;
  int totalsold;
  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ProductDetailsScreen(
            product: product,
          ),
        );
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${product.name}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme.primary,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "Price: ${product.name == "<Product Not Found>" ? '<Price not found>' : product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Total Sales: ${product.name == "<Product Not Found>" ? '<Price not found>' : totalsales.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "Total sold: $totalsold",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
