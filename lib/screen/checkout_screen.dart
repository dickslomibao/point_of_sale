import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:point_of_sales/screen/customer_screen.dart';
import 'package:point_of_sales/screen/transaction_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/product_model.dart';
import '../components/checkout_user_money_modal.dart';
import '../components/success_transaction_mode.dart';
import '../models/customer_model.dart';
import '../provider/customer_view_screen_provider.dart';
import '../provider/theme_color.dart';

class CheckOutScreen extends StatelessWidget {
  CheckOutScreen(
      {super.key,
      required this.order,
      required this.productList,
      this.customer});
  List<InvoiceLine> order;
  List<Product> productList;
  CustomerModel? customer;
  double totalPrice() {
    double total = 0;
    order.forEach((item) {
      total += item.subTotal();
    });
    return total;
  }

  int totalItem() {
    int total = 0;
    order.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  var amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final theme = context.read<ThemeColorProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Check out",
          style: TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Items:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Sub Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemCount: order.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Product product = productList.singleWhere(
                            (temp) => temp.id == order[index].productId);
                        double subtotal =
                            order[index].productPrice * order[index].qty;
                        return Container(
                          // color: Colors.amber,

                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Price: ${order[index].productPrice.toStringAsFixed(2)} ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                " * ${order[index].qty} = ${subtotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // child: ListTile(
                          //   contentPadding: const EdgeInsets.symmetric(
                          //       horizontal: 0.0, vertical: 0),
                          //   title: Text(
                          //     product.name,
                          //     style: const TextStyle(
                          //       fontSize: 17,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          //   subtitle: Text(
                          //     "Price: ${order[index].productPrice.toStringAsFixed(2)} ",
                          //     style: const TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          //   trailing: Text(
                          //     " * ${order[index].qty} = ${subtotal.toStringAsFixed(2)}",
                          //     style: const TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Price: ",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: theme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Php ${totalPrice().toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: theme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primary,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(18),
                  border: OutlineInputBorder(),
                  labelText: "Cash Tendered",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: theme.primary,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 52,
                width: double.infinity,
                color: theme.primary,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                  ),
                  onPressed: () async {
                    final pref = await SharedPreferences.getInstance();
                    if (context.mounted) {
                      if (amountController.text == "") {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('Cash tendered is required.'),
                            );
                          },
                        );
                        return;
                      }
                      if (double.tryParse(amountController.text) == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content:
                                  Text('Invalid amount. Check your input.'),
                            );
                          },
                        );
                        return;
                      }
                      double amount = double.parse(amountController.text);
                      if (totalPrice() > amount) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text(
                              "Insufficient Amount.",
                            ),
                          ),
                        );
                      } else {
                        final uuid = const Uuid().v4();
                        InvoiceDBHelper.insert(
                          Invoice(
                            id: uuid,
                            custumerPayAmount: totalPrice(),
                            totalAmount: totalPrice(),
                            processBy: pref.getString('id') ?? "",
                            customerId: customer == null
                                ? '0'
                                : customer!.id.toString(),
                            tenderedAmount: amount,
                          ),
                        );
                        for (var temp in order) {
                          temp.invoiceId = uuid;
                          InvoiceLineDBHelper.insert(temp);
                          ProductDBHelper.minus(
                              id: temp.productId, qty: temp.qty);
                        }
                        double change = amount - totalPrice();

                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: TransactionSuccessScreen(
                            change: change,
                            customer: customer,
                            orderId: uuid,
                            cashTendered: amount,
                            totalPrice: totalPrice(),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Pay",
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
                    final pref = await SharedPreferences.getInstance();
                    if (customer != null) {
                      if (context.mounted) {
                        final uuid = const Uuid().v4();
                        InvoiceDBHelper.insert(
                          Invoice(
                            id: uuid,
                            custumerPayAmount: 0,
                            totalAmount: totalPrice(),
                            processBy: pref.getString('id') ?? "",
                            customerId: customer == null
                                ? '0'
                                : customer!.id.toString(),
                            tenderedAmount: 0,
                          ),
                        );
                        for (var temp in order) {
                          temp.invoiceId = uuid;
                          InvoiceLineDBHelper.insert(temp);
                          ProductDBHelper.minus(
                              id: temp.productId, qty: temp.qty);
                        }

                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: TransactionSuccessScreen(
                            change: 0,
                            customer: customer,
                            orderId: uuid,
                            cashTendered: 0,
                            totalPrice: totalPrice(),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomerScreen(
                              f: (CustomerModel c) {
                                if (context.mounted) {
                                  final uuid = const Uuid().v4();
                                  InvoiceDBHelper.insert(
                                    Invoice(
                                      id: uuid,
                                      custumerPayAmount: 0,
                                      totalAmount: totalPrice(),
                                      processBy: pref.getString('id') ?? "",
                                      customerId: c.id.toString(),
                                      tenderedAmount: 0,
                                    ),
                                  );
                                  for (var temp in order) {
                                    temp.invoiceId = uuid;
                                    InvoiceLineDBHelper.insert(temp);
                                    ProductDBHelper.minus(
                                        id: temp.productId, qty: temp.qty);
                                  }
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    withNavBar: false,
                                    screen: TransactionSuccessScreen(
                                      change: 0,
                                      customer: customer,
                                      orderId: uuid,
                                      cashTendered: 0,
                                      totalPrice: totalPrice(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Check out as Credit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
