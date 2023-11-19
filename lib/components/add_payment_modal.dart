import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/provider/customer_view_screen_provider.dart';
import 'package:point_of_sales/screen/customer_screen.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class AddPaymentModal extends StatelessWidget {
  AddPaymentModal({
    Key? key,
    required this.balance,
    required this.customerId,
  }) : super(key: key);

  final TextEditingController controller = TextEditingController();

  final double balance;
  final String customerId;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Text(
        'Add Payment',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      content: Container(
        width: width * .75,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldComponents(
                label: "Amount",
                controller: controller,
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700]),
                  onPressed: () async {
                    await context
                        .read<CustomerViewScreenProvider>()
                        .makePayment(customerId, double.parse(controller.text));
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
