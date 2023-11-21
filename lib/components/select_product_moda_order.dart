import 'package:flutter/material.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import '../models/product_model.dart';
import 'edit_product_modal_component.dart';

class SelectProductCard extends StatelessWidget {
  const SelectProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  final Product product;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        leading: const Icon(Icons.shopify),
        onTap: () {
          onTap();
        },
        title: Text(
          "${product.name}",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          "Price: ${product.price.toString()}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(0, 0, 0, .7),
          ),
        ),
      ),
    );
  }
}
