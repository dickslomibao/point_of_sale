import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/accountdb.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/customerdb.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:uuid/uuid.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreenn extends StatefulWidget {
  const SettingsScreenn({super.key});

  @override
  State<SettingsScreenn> createState() => _SettingsScreennState();
}

class _SettingsScreennState extends State<SettingsScreenn> {
  var key = TextEditingController();
  SharedPreferences? _prefs;

  String? id;
  void alertInternet(String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
          title: const Text("Oops.."),
          content: Text(msg),
        );
      },
    );
  }

  void setGEtKey() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs!.containsKey("appid")) {
      await _prefs!.setString("appid", const Uuid().v4().substring(0, 8));
      id = _prefs!.getString("appid");
    }
    id = _prefs!.getString("appid");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setGEtKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('App id:\n${id}'),
                  );
                },
              );
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.green[700],
                ),
                onPressed: () async {
                  try {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        content: Text('Processing...'),
                      ),
                    );
                    final response =
                        await InternetAddress.lookup('www.google.com');

                    if (response.isNotEmpty) {
                      final category = await CategoryDBHelper.getList();
                      final product = await ProductDBHelper.storeInFirebase();
                      final invoice = await InvoiceDBHelper.storeInFirebase();
                      final line = await InvoiceLineDBHelper.storeInFirebase();
                      final account = await AccountDbHelper.storeInFirebase();
                      final customer = await CustomerDBHelper.storeInFirebase();
                      for (var element in account) {
                        await FirebaseFirestore.instance
                            .collection('account')
                            .doc(id)
                            .collection('account')
                            .doc(element[CategoryDBHelper.colId].toString())
                            .set(element);
                      }
                      for (var element in customer) {
                        await FirebaseFirestore.instance
                            .collection('customer')
                            .doc(id)
                            .collection('customer')
                            .doc(element[CategoryDBHelper.colId].toString())
                            .set(element);
                      }
                      for (var element in category) {
                        await FirebaseFirestore.instance
                            .collection('category')
                            .doc(id)
                            .collection('category')
                            .doc(element[CategoryDBHelper.colId].toString())
                            .set(element);
                      }
                      for (var element in product) {
                        await FirebaseFirestore.instance
                            .collection('product')
                            .doc(id)
                            .collection('product')
                            .doc(element[ProductDBHelper.colId].toString())
                            .set(element);
                      }
                      for (var element in invoice) {
                        await FirebaseFirestore.instance
                            .collection('invoice')
                            .doc(id)
                            .collection('invoice')
                            .doc(element[InvoiceDBHelper.colId].toString())
                            .set(element);
                      }

                      for (var element in line) {
                        await FirebaseFirestore.instance
                            .collection('invoiceLine')
                            .doc(id)
                            .collection('invoiceLine')
                            .doc(element[InvoiceLineDBHelper.colId].toString())
                            .set(element);
                      }

                      if (context.mounted) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ],
                              title: const Text("Success"),
                              content: const Text(
                                  "Your data is now exported on cloud firestore"),
                            );
                          },
                        );
                      }
                    }
                  } on SocketException catch (err) {
                    Navigator.of(context).pop();
                    alertInternet("Please check your internet Connection");
                  }
                },
                child: Text(
                  "Back up Data ",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                              ),
                              onPressed: () async {
                                try {
                                  print(key.text);
                                  final response = await InternetAddress.lookup(
                                      'www.google.com');
                                  if (response.isNotEmpty) {
                                    final category = await FirebaseFirestore
                                        .instance
                                        .collection("category")
                                        .doc(key.text)
                                        .collection("category")
                                        .get();
                                    final product = await FirebaseFirestore
                                        .instance
                                        .collection("product")
                                        .doc(key.text)
                                        .collection("product")
                                        .get();
                                    final invoice = await FirebaseFirestore
                                        .instance
                                        .collection("invoice")
                                        .doc(key.text)
                                        .collection("invoice")
                                        .get();
                                    final invoiceLine = await FirebaseFirestore
                                        .instance
                                        .collection("invoiceLine")
                                        .doc(key.text)
                                        .collection("invoiceLine")
                                        .get();
                                    final account = await FirebaseFirestore
                                        .instance
                                        .collection("account")
                                        .doc(key.text)
                                        .collection("account")
                                        .get();
                                    final customer = await FirebaseFirestore
                                        .instance
                                        .collection("customer")
                                        .doc(key.text)
                                        .collection("customer")
                                        .get();
                                    print(account.docs.first);
                                    if (category.docs.isEmpty &&
                                        product.docs.isEmpty &&
                                        invoice.docs.isEmpty &&
                                        invoiceLine.docs.isEmpty &&
                                        customer.docs.isEmpty &&
                                        account.docs.isEmpty) {
                                      return alertInternet(
                                          "Check your provided key.");
                                    } else {
                                      account.docs.forEach((element) async {
                                        await AccountDbHelper.firestoreInsert(
                                            element.data());
                                      });
                                      customer.docs.forEach((element) async {
                                        await CustomerDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      category.docs.forEach((element) async {
                                        await CategoryDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      product.docs.forEach((element) async {
                                        await ProductDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      invoice.docs.forEach((element) async {
                                        await InvoiceDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      invoiceLine.docs.forEach((element) async {
                                        await InvoiceLineDBHelper
                                            .firestoreInsert(element.data());
                                      });

                                      if (context.mounted) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              actions: [
                                                OutlinedButton(
                                                    onPressed: () {
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              '/home',
                                                              (route) => false);
                                                    },
                                                    child: const Text("Ok"))
                                              ],
                                              content: const Text(
                                                  "Data succesfully fetch."),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  }
                                } on SocketException catch (err) {
                                  alertInternet(
                                      "Please check your internet Connection");
                                }
                              },
                              child: const Text("Fetch data"),
                            ),
                          ],
                          content: TextField(
                            controller: key,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Your key'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Get data online",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.green[700],
                  ),
                ),
              )),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}
