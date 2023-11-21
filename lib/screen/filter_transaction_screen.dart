import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/account_model.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import 'package:point_of_sales/screen/transaction_details_screen.dart';
import 'package:provider/provider.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/inventory_product_card_components.dart';
import '../helpers/productdb.dart';
import '../provider/theme_color.dart';
import 'inventory_product_details_screen.dart';

class FillteredTransactionScreen extends StatefulWidget {
  const FillteredTransactionScreen({
    super.key,
    required this.startDate,
    required this.endDate,
    this.staff,
  });
  final String startDate;
  final String endDate;
  final AccountModel? staff;
  @override
  State<FillteredTransactionScreen> createState() =>
      _FillteredTransactionScreenState();
}

class _FillteredTransactionScreenState
    extends State<FillteredTransactionScreen> {
  List<Invoice> invoice = [];
  bool _isLoading = true;
  double totalSales = 0;
  void initDate() async {
    final data = await InvoiceDBHelper.getFilteredTransaction(
      widget.startDate,
      widget.endDate,
    );
    for (var element in data) {
      totalSales += element.totalAmount;
    }
    setState(() {
      invoice = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    initDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Filtered Result",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : invoice.isEmpty
              ? const Center(
                  child: Text(
                    "No result ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.staff != null)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Staff name: ${widget.staff!.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total Sales of result: ${totalSales.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.staff == null)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.1),
                            ),
                          ),
                          child: Text(
                            'Total Sales: ${totalSales.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      Text(
                        'Results: (${invoice.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: invoice.length,
                          itemBuilder: (context, index) {
                            final i = invoice[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12.0,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionDetailsScreen(
                                            invoice: i,
                                          ),
                                        ),
                                      );
                                    },
                                    subtitle: Text(
                                      "Total Price: ${i.totalAmount}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(0, 0, 0, .7),
                                      ),
                                    ),
                                    title: Text(
                                      "Date: ${i.date}",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: theme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      drawer: const MyDrawer(),
    );
  }
}
