import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/theme_color.dart';

class LowStockProductCard extends StatelessWidget {
  LowStockProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

    return Card(
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
              "Stocks: ${product.stock}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
