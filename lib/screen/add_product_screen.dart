import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key, required this.add, required this.undo})
      : super(key: key);

  Function add;
  Function undo;
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var barcodeController = TextEditingController();
  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var descController = TextEditingController();

  var qtyController = TextEditingController();
  var priceController = TextEditingController();
  var retailPrice = TextEditingController();
  var catId = 0;
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    if (barcodeScanRes != "-1") {
      if (await validateCode(barcodeScanRes)) {
        setState(() {
          barcodeController.text = barcodeScanRes;
        });
      }
    }
  }

  Future<bool> validateCode(String code) async {
    var checkProduct = await ProductDBHelper.checkBarCode(code: code);

    if (checkProduct.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Barcode is already assigned."),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Barcode: ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        onChanged: (value) async {
                          if (!await validateCode(value)) {
                            setState(() {
                              barcodeController.text = "";
                            });
                          }
                        },
                        controller: barcodeController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      scanBarcodeNormal();
                    },
                    icon: const Icon(
                      Icons.document_scanner_outlined,
                      color: Color.fromRGBO(56, 142, 60, 1),
                    ),
                  ),
                ],
              ),
              TextFieldComponents(
                label: "Name",
                controller: nameController,
              ),
              Text(
                "Category: ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              FutureBuilder(
                future: CategoryDBHelper.getList(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> category) {
                  if (category.hasData) {
                    if (catId == 0 && category.data!.isNotEmpty) {
                      catId = category.data![0]['id'];
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: category.data!.isEmpty
                          ? const Text("You must add categories.")
                          : DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                // Initial Value
                                value: catId,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: category.data!.map((item) {
                                  return DropdownMenuItem(
                                    value: item['id']!,
                                    child: Text(item['title']!),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  catId = int.parse(value.toString());
                                  setState(() {});
                                },
                              ),
                            ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              TextFieldComponents(
                label: "Description",
                controller: descController,
              ),
              TextFieldComponents(
                label: "Quantity",
                controller: qtyController,
                keyboardType: TextInputType.number,
              ),
              TextFieldComponents(
                label: "Retail Price",
                controller: retailPrice,
                keyboardType: TextInputType.number,
              ),
              TextFieldComponents(
                label: "Selling Price",
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700]),
                  onPressed: () {
                    List<TextEditingController> inputList = [
                      barcodeController,
                      nameController,
                      descController,
                      qtyController,
                      priceController
                    ];
                    final List<String> error = [
                      'Barcode is required',
                      'Name is required',
                      'Description is required',
                      'Quatity is required',
                      'Price is required',
                    ];
                    bool isOk = true;
                    for (int i = 0; i < inputList.length; i++) {
                      if (inputList[i].text == "") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(error[i]),
                          ),
                        );
                        isOk = false;
                        break;
                      }
                    }

                    if (isOk) {
                      if (catId == 0) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text("Category is required"),
                          ),
                        );
                        return;
                      }
                      if (int.tryParse(inputList[3].text.toString()) == null) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content:
                                Text("Invalid Quantity. Positive integer only"),
                          ),
                        );
                        return;
                      }
                      if (int.parse(inputList[3].text.toString()) < 0) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text("Quantity cannot be negative."),
                          ),
                        );
                        return;
                      }
                      if (double.tryParse(inputList[4].text.toString()) ==
                          null) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text("Invalid Price. Check your input"),
                          ),
                        );
                        return;
                      }
                      if (double.parse(inputList[4].text.toString()) <= 0) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text("Price cannot be negative."),
                          ),
                        );
                        return;
                      }
                      var temp = Product(
                        barcode: barcodeController.text,
                        name: nameController.text,
                        catId: catId,
                        description: descController.text,
                        stock: int.parse(qtyController.text),
                        price: double.parse(priceController.text),
                        retailPrice: double.parse(retailPrice.text),
                      );
                      widget.add(temp);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[700],
                          content: Text(
                            'Successfuly added',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Undo',
                            onPressed: () {
                              widget.undo();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Add item",
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
