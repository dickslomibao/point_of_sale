import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/product_model.dart';
import 'package:provider/provider.dart';

import '../color.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/sales_chart_component.dart';
import '../helpers/invoicedb.dart';
import '../models/sales_model.dart';
import '../provider/theme_color.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({super.key, required this.product});
  Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _controller;
  var _category = [];
  List<InvoiceLine> _productOrderList = [];
  bool _isLoading = true;
  List<Sales> sales = [
    Sales(name: "Mon", sales: 0),
    Sales(name: "Tue", sales: 0),
    Sales(name: "Wed", sales: 0),
    Sales(name: "Thu", sales: 0),
    Sales(name: "Fri", sales: 0),
    Sales(name: "Sat", sales: 0),
    Sales(name: "Sun", sales: 0),
  ];
  List<Sales> profitWeekly = [
    Sales(name: "Mon", sales: 0),
    Sales(name: "Tue", sales: 0),
    Sales(name: "Wed", sales: 0),
    Sales(name: "Thu", sales: 0),
    Sales(name: "Fri", sales: 0),
    Sales(name: "Sat", sales: 0),
    Sales(name: "Sun", sales: 0),
  ];
  List<Sales> soldItems = [
    Sales(name: "Mon", sales: 0),
    Sales(name: "Tue", sales: 0),
    Sales(name: "Wed", sales: 0),
    Sales(name: "Thu", sales: 0),
    Sales(name: "Fri", sales: 0),
    Sales(name: "Sat", sales: 0),
    Sales(name: "Sun", sales: 0),
  ];

  List<Sales> monthly = [
    Sales(name: 'Jan', sales: 0),
    Sales(name: 'Feb', sales: 0),
    Sales(name: 'Mar', sales: 0),
    Sales(name: 'Apr', sales: 0),
    Sales(name: 'May', sales: 0),
    Sales(name: 'Jun', sales: 0),
    Sales(name: 'Jul', sales: 0),
    Sales(name: 'Aug', sales: 0),
    Sales(name: 'Sep', sales: 0),
    Sales(name: 'Oct', sales: 0),
    Sales(name: 'Nov', sales: 0),
    Sales(name: 'Dec', sales: 0),
  ];
  List<Sales> monthlyProfit = [
    Sales(name: 'Jan', sales: 0),
    Sales(name: 'Feb', sales: 0),
    Sales(name: 'Mar', sales: 0),
    Sales(name: 'Apr', sales: 0),
    Sales(name: 'May', sales: 0),
    Sales(name: 'Jun', sales: 0),
    Sales(name: 'Jul', sales: 0),
    Sales(name: 'Aug', sales: 0),
    Sales(name: 'Sep', sales: 0),
    Sales(name: 'Oct', sales: 0),
    Sales(name: 'Nov', sales: 0),
    Sales(name: 'Dec', sales: 0),
  ];
  List<Sales> soldMontly = [
    Sales(name: 'Jan', sales: 0),
    Sales(name: 'Feb', sales: 0),
    Sales(name: 'Mar', sales: 0),
    Sales(name: 'Apr', sales: 0),
    Sales(name: 'May', sales: 0),
    Sales(name: 'Jun', sales: 0),
    Sales(name: 'Jul', sales: 0),
    Sales(name: 'Aug', sales: 0),
    Sales(name: 'Sep', sales: 0),
    Sales(name: 'Oct', sales: 0),
    Sales(name: 'Nov', sales: 0),
    Sales(name: 'Dec', sales: 0),
  ];

  List<Sales> yearlySales = [
    Sales(name: '2023', sales: 0),
    Sales(name: '2024', sales: 0),
    Sales(name: '2025', sales: 0),
    Sales(name: '2026', sales: 0),
    Sales(name: '2027', sales: 0),
    Sales(name: '2028', sales: 0),
    Sales(name: '2029', sales: 0),
    Sales(name: '2030', sales: 0),
  ];
  List<Sales> yearlyProfit = [
    Sales(name: '2023', sales: 0),
    Sales(name: '2024', sales: 0),
    Sales(name: '2025', sales: 0),
    Sales(name: '2026', sales: 0),
    Sales(name: '2027', sales: 0),
    Sales(name: '2028', sales: 0),
    Sales(name: '2029', sales: 0),
    Sales(name: '2030', sales: 0),
  ];
  List<Sales> yearlySold = [
    Sales(name: '2023', sales: 0),
    Sales(name: '2024', sales: 0),
    Sales(name: '2025', sales: 0),
    Sales(name: '2026', sales: 0),
    Sales(name: '2027', sales: 0),
    Sales(name: '2028', sales: 0),
    Sales(name: '2029', sales: 0),
    Sales(name: '2030', sales: 0),
  ];

  int soldToday = 0;
  double salesToday = 0;
  double profitToday = 0;

  int soldMonth = 0;
  double salesMonth = 0;
  double profitMonth = 0;
  void _getList() async {
    final data = await CategoryDBHelper.getSingleList(widget.product.catId);
    final list =
        await InvoiceLineDBHelper.getListofSingleProduct(widget.product.id);

    _productOrderList = list;
    _category = data;
    for (var element in _productOrderList) {
      final value = await InvoiceDBHelper.getTimeStamp(element.invoiceId);
      if (value != "") {
        final date = DateTime.now();
        final producDate = DateTime.parse(value);
        int weeKofYearToday = getWeekOfYear(date.toString());
        int productWeekOfYear = getWeekOfYear(value);

        if (date.year == producDate.year) {
          if (date.month == producDate.month) {
            salesMonth += element.subTotal();
            profitMonth +=
                (element.productPrice - element.retailPirce) * element.qty;
            soldMonth += element.qty;
            if (date.day == producDate.day) {
              salesToday += element.subTotal();
              profitToday +=
                  (element.productPrice - element.retailPirce) * element.qty;
              soldToday += element.qty;
            }
            if (weeKofYearToday == productWeekOfYear) {
              final productDate = DateTime.parse(value);
              int day = productDate.weekday;
              sales[day - 1].sales += element.subTotal();
              soldItems[day - 1].sales += element.qty;
              profitWeekly[day - 1].sales +=
                  (element.productPrice - element.retailPirce) * element.qty;
            }
          }
          monthly[producDate.month - 1].sales += element.subTotal();
          monthlyProfit[producDate.month - 1].sales +=
              (element.productPrice - element.retailPirce) * element.qty;
          soldMontly[producDate.month - 1].sales += element.qty;
        }
        yearlySales[producDate.year - 2023].sales += element.subTotal();
        yearlyProfit[producDate.year - 2023].sales +=
            (element.productPrice - element.retailPirce) * element.qty;
        yearlySold[producDate.year - 2023].sales += element.qty;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  int getWeekOfYear(String date) {
    final now = DateTime.parse(date);
    final firstJan = DateTime(now.year, 1, 1);
    final weekNumber = weeksBetween(firstJan, now);
    return weekNumber;
  }

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  int _totalSold() {
    int total = 0;
    _productOrderList.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  double _totalSales() {
    double total = 0;
    _productOrderList.forEach((element) {
      total += element.subTotal();
    });
    return total;
  }

  double totalProfit() {
    double total = 0;
    _productOrderList.forEach((element) {
      total += (element.productPrice - element.retailPirce) * element.qty;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _getList();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final theme = context.read<ThemeColorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: const TextStyle(
            fontSize: 21,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))],
      ),
      body: _isLoading
          ? Center(child: const CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${widget.product.name}",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: theme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Descriptions: ${widget.product.description}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            Text(
                              "Barcode: ${widget.product.barcode}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            Text(
                              "Category: ${_category.isEmpty ? '<not found>' : _category.last[CategoryDBHelper.colTitle]}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            Text(
                              "Retail price: ${widget.product.retailPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            Text(
                              "Price: ${widget.product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            if (widget.product.type == 2)
                              const Text(
                                "Stock: <Sub-standard product>",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            if (widget.product.type == 1)
                              Text(
                                "Stock: ${widget.product.stock}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  color: widget.product.stock < 6
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      labelColor: Colors.black,
                      controller: _controller,
                      tabs: const [
                        Tab(text: 'Info'),
                        Tab(text: 'Sales'),
                        Tab(text: 'Profit'),
                        Tab(text: 'Sold Items'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: TabBarView(controller: _controller, children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15.0,
                            bottom: 15,
                            left: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today:",
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sold items: ${soldToday}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Sales: ${salesToday.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Profit: ${profitToday.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Current month:",
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sold items: ${soldMonth}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Sales: ${salesMonth.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Profit: ${profitMonth.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Overall:",
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sold items: ${_totalSold()}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Sales: ${_totalSales().toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Profit: ${totalProfit().toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            height: 1.4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SalesChart(
                              data: sales,
                              title: "Daily Sales for this week",
                            ),
                            SalesChart(
                              data: monthly,
                              title: "Montly Sales",
                            ),
                            SalesChart(
                              data: yearlySales,
                              title: "Yearly Sales",
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SalesChart(
                              data: profitWeekly,
                              title: "Daily Profit for this week",
                            ),
                            SalesChart(
                              data: monthlyProfit,
                              title: "Montly Profit for this year",
                            ),
                            SalesChart(
                              data: yearlyProfit,
                              title: "Montly Profit for this year",
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SalesChart(
                              data: soldItems,
                              title: "Daily Sold items for this week",
                            ),
                            SalesChart(
                              data: soldMontly,
                              title: "Montly Sold items",
                            ),
                            SalesChart(
                              data: yearlySold,
                              title: "Montly Profit for this year",
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
      drawer: const MyDrawer(),
    );
  }
}
