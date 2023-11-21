import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customer_model.dart';
import '../provider/customer_view_screen_provider.dart';
import '../provider/print_reciept_provider.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({
    super.key,
    required this.change,
    this.customer,
    required this.orderId,
    this.cashTendered = 0,
    required this.totalPrice,
  });
  final double change;
  final double totalPrice;
  final CustomerModel? customer;
  final String orderId;
  final double cashTendered;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Transaction Success",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cashTendered == 0)
                        const Text(
                          "Upaid Checkout",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Total price: ${totalPrice}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      if (cashTendered != 0)
                        Text(
                          "Cash Tendered: ${cashTendered}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      if (cashTendered != 0)
                        Text(
                          "Change: ${change}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final read = context.read<PrintRecieptProvider>();
                      await read.initData(orderId);
                      if (await read.bluetoothPrint.isConnected ?? false) {
                        List<LineText> add = [
                          LineText(
                            type: LineText.TYPE_TEXT,
                            content:
                                'Cash Tendered: Php ${cashTendered.toStringAsFixed(2)}',
                            weight: 0,
                            align: LineText.ALIGN_LEFT,
                            linefeed: 1,
                          ),
                          LineText(
                            type: LineText.TYPE_TEXT,
                            content: 'Change: Php ${change.toStringAsFixed(2)}',
                            weight: 0,
                            align: LineText.ALIGN_LEFT,
                            linefeed: 1,
                          ),
                        ];
                        if (cashTendered == 0) {
                          add = [
                            LineText(
                              type: LineText.TYPE_TEXT,
                              content: 'Unpaid',
                              weight: 0,
                              align: LineText.ALIGN_LEFT,
                              linefeed: 1,
                            ),
                          ];
                        }
                        final data = await read.startPrinting(add);
                        await read.bluetoothPrint.printReceipt({}, data);
                        if (context.mounted) {
                          // if (customer != null) {
                          //   context
                          //       .read<CustomerViewScreenProvider>()
                          //       .initData(customer!.id.toString());
                          //   Navigator.of(context).pop();
                          //   Navigator.of(context).pop();
                          //   Navigator.of(context).pop();

                          //   return;
                          // }6587
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        }
                        return;
                      }
                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Available Printer',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text('Refresh')),
                                  ],
                                ),
                                StreamBuilder<List<BluetoothDevice>>(
                                  stream: read.bluetoothPrint.scanResults,
                                  initialData: [],
                                  builder: (_, snapshot) => Column(
                                    children: snapshot.data!
                                        .map(
                                          (d) => ListTile(
                                            title: Text(d.name ?? ''),
                                            subtitle: Text(d.address ?? ''),
                                            onTap: () async {
                                              read.device = d;
                                              await read.bluetoothPrint
                                                  .connect(read.device!);
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Print Reciept",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 52,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
