import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/invoice_model.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import 'transaction_details_screen.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({super.key});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Invoice> invoice = [];
  bool _isLoading = true;

  void _getTransactionData() async {
    final data = await InvoiceDBHelper.getList();

    setState(() {
      invoice = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transactions",
          style: GoogleFonts.lato(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : invoice.isEmpty
              ? Center(
                  child: Text(
                    'Transaction is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: invoice.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // Rounded corners
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TransactionDetailsScreen(
                                invoice: invoice[index],
                              ),
                            ));
                          },
                          subtitle: Text(
                            "Total Price: ${invoice[index].totalAmount}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, .7),
                            ),
                          ),
                          title: Text(
                            "Date: ${invoice[index].date}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
    );
  }
}
