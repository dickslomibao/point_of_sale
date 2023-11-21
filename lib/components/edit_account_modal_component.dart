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

class EditAccountModal extends StatefulWidget {
  EditAccountModal({
    Key? key,
    required this.account,
    required this.onUpdate,
  }) : super(key: key);
  AccountModel account;
  Function onUpdate;

  @override
  State<EditAccountModal> createState() => _EditAccountModalState();
}

class _EditAccountModalState extends State<EditAccountModal> {
  var nameController = TextEditingController();
  var pinController = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.account.name;
    selectedDate = DateTime.parse(widget.account.birthdate);
    bdate = widget.account.birthdate;
    pinController.text = widget.account.pin;
    if (widget.account.features.contains('0')) {
      features[0] = true;
    }
    if (widget.account.features.contains('1')) {
      features[1] = true;
    }
    if (widget.account.features.contains('2')) {
      features[2] = true;
    }
    if (widget.account.features.contains('3')) {
      features[3] = true;
    }
    if (widget.account.features.contains('4')) {
      features[4] = true;
    }
    setState(() {});
  }

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
                    "Edit Staff",
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Birthdate: $bdate',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            await _selectDate(context);
                          },
                          child: Icon(Icons.calendar_today)),
                    ],
                  ),
                ),
              ),
              TextFieldComponents(
                label: "Pin",
                controller: pinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Staff Access:",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(
                    value: features[0],
                    onChanged: (val) {
                      setState(() {
                        features[0] = !features[0];
                      });
                    },
                  ),
                  Text(
                    'Category',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: features[1],
                    onChanged: (val) {
                      setState(() {
                        features[1] = !features[1];
                      });
                    },
                  ),
                  Text(
                    'Product and inventory',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: features[2],
                    onChanged: (val) {
                      setState(() {
                        features[2] = !features[2];
                      });
                    },
                  ),
                  Text(
                    'Orders and payment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: features[3],
                    onChanged: (val) {
                      setState(() {
                        features[3] = !features[3];
                      });
                    },
                  ),
                  Text(
                    'Transaction and reports',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: features[4],
                    onChanged: (val) {
                      setState(() {
                        features[4] = !features[4];
                      });
                    },
                  ),
                  Text(
                    'Customer',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
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
                    String f = "";

                    if (name.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Name is required'),
                        ),
                      );
                    }
                    if (pinController.text.isEmpty ||
                        pinController.text.length < 4) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Pin is required'),
                        ),
                      );
                    }
                    if (!features.contains(true)) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          content: Text('Plase select staff rule'),
                        ),
                      );
                    }
                    for (var i = 0; i < features.length; i++) {
                      if (features[i]) {
                        f += "$i,";
                      }
                    }
                    final r = await AccountDbHelper.getSingleListUsingPin(
                        pinController.text);

                    if (context.mounted) {
                      print(f);
                      if (r.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text('Pin already used'),
                          ),
                        );
                        return;
                      }
                    }
                  },
                  child: Text(
                    "Save",
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
