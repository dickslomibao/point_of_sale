import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/screen/add_product_screen.dart';
import 'package:point_of_sales/screen/checkout_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../components/add_order_qty_modal_components.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../models/customer_model.dart';
import '../models/product_model.dart';
import '../provider/order_screen_provider.dart';
import '../provider/theme_color.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key, this.customer});
  final CustomerModel? customer;
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var qtyController = TextEditingController();
  var barcodeController = TextEditingController();

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    context.read<OrderScreenProvider>().addORder(
          context,
          barcodeScanRes,
        );
  }

  @override
  void initState() {
    context.read<OrderScreenProvider>().initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final read = context.read<OrderScreenProvider>();
    final watch = context.watch<OrderScreenProvider>();
    final theme = context.read<ThemeColorProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanBarcodeNormal();
        },
        child: const Icon(
          Icons.document_scanner_outlined,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Order",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (read.orderList.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CheckOutScreen(
                      order: read.orderList,
                      productList: watch.productList,
                      customer: widget.customer,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.shopping_cart_checkout_outlined,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Check out",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (read.orderList.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              width: 1,
              color: Colors.white70,
            ),
          if (read.productList.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddProductScreenForOrder(
                      onTap: (Product p) {
                        context.read<OrderScreenProvider>().addORder(
                              context,
                              p.barcode,
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 20,
                    ),
                    Text(
                      "Add",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
      body: watch.isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : read.orderList.isEmpty
              ? Center(
                  child: Text(
                    read.productList.isNotEmpty
                        ? 'Scan or add item'
                        : 'You need to add \n product to generate order.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("Product",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 0,
                              child: Text("Qty",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              width: 130,
                              child: Text("Sub total",
                                  textAlign: TextAlign.end,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: read.orderList.length,
                          itemBuilder: (_, index) {
                            Product item = watch.productList.singleWhere(
                                (element) =>
                                    element.id ==
                                    read.orderList[index].productId);

                            int sublength = read.orderList[index]
                                .subTotal()
                                .toString()
                                .length;
                            double subwidth = 69 - sublength.toDouble();

                            return Card(
                              child: Dismissible(
                                // confirmDismiss: (direction) {
                                //   return showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         title: Text('Opps..'),
                                //         content: Text(
                                //             "Are you sure you want to remove ${item.name} ?"),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.of(context).pop(false);
                                //             },
                                //             child: Text(
                                //               'Cancel',
                                //               style: TextStyle(
                                //                 fontSize: 15,
                                //                 fontWeight: FontWeight.w500,
                                //                 color: Colors.red,
                                //               ),
                                //             ),
                                //           ),
                                //           ElevatedButton(
                                //             style: ElevatedButton.styleFrom(
                                //               backgroundColor:
                                //                   Colors.green[700],
                                //             ),
                                //             onPressed: () {
                                //               Navigator.of(context).pop(true);
                                //             },
                                //             child: Text(
                                //               "Ok",
                                //               style: TextStyle(
                                //                 fontSize: 15,
                                //                 fontWeight: FontWeight.w500,
                                //               ),
                                //             ),
                                //           )
                                //         ],
                                //       );
                                //     },
                                //   );
                                // },
                                onDismissed: (DismissDirection direction) {
                                  setState(() {
                                    read.orderList.removeWhere((element) =>
                                        element.productId == item.id);
                                  });
                                },
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  alignment: Alignment.centerLeft,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Color.fromRGBO(229, 57, 53, 1),
                                  ),
                                ),
                                key: ValueKey(read.orderList[index]),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: theme.primary,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Price: ${item.price.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, .8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<OrderScreenProvider>()
                                                    .minus(item.id);
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                            Text(
                                              " ${read.orderList[index].qty.toString()}",
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .8),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<OrderScreenProvider>()
                                                    .addORder(
                                                      context,
                                                      item.barcode,
                                                    );
                                              },
                                              icon: const Icon(Icons.add),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 80,
                                        child: Text(
                                          " ${read.orderList[index].subTotal().toStringAsFixed(2)}",
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(0, 0, 0, .8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
//  ListTile(
//                                   onTap: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (_) {
//                                         return MyAlertQtyModal(
//                                           qty: read.orderList[index].qty,
//                                           tempProduct: item,
//                                           controller: qtyController,
//                                           add: () {
//                                             if (qtyController.text == "") {
//                                               return 2;
//                                             } else if (int.tryParse(
//                                                     qtyController.text) ==
//                                                 null) {
//                                               return 3;
//                                             } else if (int.parse(
//                                                     qtyController.text) <=
//                                                 0) {
//                                               return 4;
//                                             } else {
//                                               int qty = int.parse(
//                                                       qtyController.text) +
//                                                   read.orderList[index].qty;
//                                               if (qty > item.stock) {
//                                                 return 0;
//                                               } else {
//                                                 setState(() {
//                                                   read.orderList[index]
//                                                       .qty = qty;
//                                                 });
//                                               }
//                                             }
//                                             return 1;
//                                           },
//                                         );
//                                       },
//                                     );
//                                   },
//                                   title: Text(
//                                     item.name,
//                                     style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.green[800],
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     "Price: ${item.price}",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500,
//                                       color:
//                                           const Color.fromRGBO(0, 0, 0, .8),
//                                     ),
//                                   ),
//                                   trailing: Wrap(
//                                     alignment: WrapAlignment.center,
//                                     crossAxisAlignment:
//                                         WrapCrossAlignment.center,
//                                     children: [
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           IconButton(
//                                               onPressed: () {},
//                                               icon: Icon(Icons.remove)),
//                                           Text(
//                                             " ${read.orderList[index].qty.toString()}",
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500,
//                                               color: const Color.fromRGBO(
//                                                   0, 0, 0, .8),
//                                             ),
//                                           ),
//                                           IconButton(
//                                               onPressed: () {},
//                                               icon: Icon(Icons.add)),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         width: subwidth,
//                                       ),
//                                       Text(
//                                         " ${read.orderList[index].subTotal()}",
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500,
//                                           color: const Color.fromRGBO(
//                                               0, 0, 0, .8),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),