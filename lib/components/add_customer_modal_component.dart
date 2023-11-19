import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/models/product_model.dart';

import '../models/customer_model.dart';

class AddCustomerModal extends StatefulWidget {
  AddCustomerModal({Key? key, required this.add}) : super(key: key);

  Function add;

  @override
  State<AddCustomerModal> createState() => _AddCustomerModalState();
}

class _AddCustomerModalState extends State<AddCustomerModal> {
  var nameController = TextEditingController();
  var phoneNumber = TextEditingController();

  DateTime? selectedDate;
  String bdate = "";
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(
        () {
          selectedDate = picked;
          bdate =
              "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
        },
      );
    }
  }

  List<bool> features = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        color: Colors.white,
        width: width * .75,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Staff",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldComponents(
                label: "Name",
                controller: nameController,
              ),
              TextFieldComponents(
                label: "Phone Number",
                controller: phoneNumber,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700]),
                  onPressed: () async {
                    String name = nameController.text;
                    String number = phoneNumber.text;

                    if (name.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Name is required'),
                        ),
                      );
                    }
                    // if (pinController.text.isEmpty ||
                    //     pinController.text.length < 4) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => const AlertDialog(
                    //       content: Text('Pin is required'),
                    //     ),
                    //   );
                    // }

                    if (context.mounted) {
                      widget.add(
                        CustomerModel(
                          name: name,
                          phonenumber: number,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Add Customer",
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
