import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../provider/theme_color.dart';

class LatestProductCard extends StatelessWidget {
  const LatestProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${product.name}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: theme.primary,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Stock: ${product.stock}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Price: ${product.price}",
              style: TextStyle(
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
