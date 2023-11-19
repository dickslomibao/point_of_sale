import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/models/category_model.dart';

import '../models/customer_model.dart';
import '../models/product_model.dart';
import '../screen/product_details_screen.dart';
import 'edit_product_modal_component.dart';

class CustomerCard extends StatelessWidget {
  CustomerCard({
    Key? key,
    required this.customer,
    required this.onTap,
    required this.onDismissed,
    required this.onUpdate,
  }) : super(key: key);

  final CustomerModel customer;
  Function onTap;
  Function onDismissed;
  Function onUpdate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        background: Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Icon(
            Icons.delete,
            color: Color.fromRGBO(229, 57, 53, 1),
          ),
        ),
        direction: DismissDirection.startToEnd,
        key: ValueKey(customer),
        confirmDismiss: (direction) async {
          // return showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('Opps..'),
          //         content:
          //             Text("Are you sure you want to delete ${product.name} ?"),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.of(context).pop(false);
          //             },
          //             child: Text(
          //               'Cancel',
          //               style: TextStyle(
          //                 fontSize: 15,
          //                 fontWeight: FontWeight.w500,
          //                 color: Colors.red,
          //               ),
          //             ),
          //           ),
          //           ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Colors.green[700],
          //             ),
          //             onPressed: () {
          //               Navigator.of(context).pop(true);
          //             },
          //             child: Text(
          //               "Ok",
          //               style: TextStyle(
          //                 fontSize: 15,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //           )
          //         ],
          //       );
          //     });
        },
        onDismissed: (direction) {
          // ProductDBHelper.delete(product.id);
          // onDismissed();
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          onTap: () {
            onTap();
          },
          title: Text(
            customer.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            "Phone number: ${customer.phonenumber}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, .7),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return EditProductModal(
              //       onUpdate: () {
              //         onUpdate();
              //       },
              //       product: product,
              //     );
              //   },
              // );
            },
            icon: const Icon(
              Icons.edit_note_outlined,
              color: Color.fromRGBO(56, 142, 60, 1),
            ),
          ),
        ),
      ),
    );
  }
}
