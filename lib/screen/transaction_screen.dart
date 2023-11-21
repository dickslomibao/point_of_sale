import 'package:flutter/material.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/invoice_model.dart';

import '../components/drawer_component.dart';

import '../components/select_filtered_date_component.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const SelectFilteredTransaction();
                  },
                );
              },
              icon: const Icon(Icons.filter_list_outlined))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : invoice.isEmpty
              ? const Center(
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(0, 0, 0, .7),
                            ),
                          ),
                          title: Text(
                            "Date: ${invoice[index].date}",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      drawer: const MyDrawer(),
    );
  }
}
