import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/provider/customer_view_screen_provider.dart';
import 'package:point_of_sales/screen/transaction_details_screen.dart';
import 'package:provider/provider.dart';

import '../components/add_payment_modal.dart';
import '../models/customer_model.dart';
import '../provider/theme_color.dart';
import 'order_screen.dart';

class CustomerViewScren extends StatefulWidget {
  const CustomerViewScren({super.key, required this.customer});
  final CustomerModel customer;
  @override
  State<CustomerViewScren> createState() => _CustomerViewScrenState();
}

class _CustomerViewScrenState extends State<CustomerViewScren> {
  @override
  void initState() {
    context.read<CustomerViewScreenProvider>().isLoading = true;
    context
        .read<CustomerViewScreenProvider>()
        .initData(widget.customer.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<CustomerViewScreenProvider>();
    final theme = context.read<ThemeColorProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Customer Details",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Icon(
            Icons.payment_outlined,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: watch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(0, 0, 0, 0.1))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Name: ${watch.customer!.name}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Phone Number: ${watch.customer!.phonenumber}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Balance: Php ${watch.getBalance().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      children: [
                        if (watch.getBalance() > 0)
                          Expanded(
                            child: Container(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AddPaymentModal(
                                      balance: watch.getBalance(),
                                      customerId: widget.customer.id.toString(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: theme.primary),
                                child: const Text(
                                  "Make a payment",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (watch.getBalance() > 0)
                          const SizedBox(
                            width: 10,
                          ),
                        Expanded(
                          child: Container(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: theme.primary,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OrderScreen(
                                      customer: widget.customer,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Make an order",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Transactions:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Sort by:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: theme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: watch.invoice == null || watch.invoice!.isEmpty
                        ? const Center(
                            child: Text(
                              "No transaction yet.",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ListView.builder(
                              itemCount: watch.invoice!.length,
                              itemBuilder: (context, index) {
                                final invoice = watch.invoice![index];
                                return Card(
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
                                            invoice: invoice,
                                          ),
                                        ),
                                      );
                                    },
                                    subtitle: Text(
                                      "Total Price: ${invoice.totalAmount}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(0, 0, 0, .7),
                                      ),
                                    ),
                                    title: Text(
                                      "Date: ${invoice.date}",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: theme.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
