import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/theme_color.dart';
import '../screen/product_details_screen.dart';
import 'add_stock_modal_component.dart';
import 'edit_product_modal_component.dart';

class InventoryProductCard extends StatelessWidget {
  InventoryProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onUpdate,
  }) : super(key: key);

  final Product product;
  Function onTap;
  Function onUpdate;
  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        onTap: () {
          onTap();
        },
        title: Text(
          product.name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: theme.primary,
          ),
        ),
        subtitle: Text(
          "Stock: ${product.type == 1 ? product.stock.toString() : 'Sub-standard product'}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(0, 0, 0, .7),
          ),
        ),
        trailing: Visibility(
          visible: product.type == 1,
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return MyAlertAddStock(
                    stock: product.stock,
                    productId: product.id,
                    onUpdate: () {
                      onUpdate();
                    },
                  );
                },
              );
            },
            icon: Icon(
              Icons.edit_note_outlined,
              color: Color.fromRGBO(56, 142, 60, 1),
            ),
          ),
        ),
      ),
    );
  }
}
