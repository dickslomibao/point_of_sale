import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:point_of_sales/components/search_product_component.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/product_model.dart';
import 'package:point_of_sales/provider/theme_color.dart';
import 'package:point_of_sales/screen/pin_verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../color.dart';
import '../components/change_user_modal_component.dart';
import '../components/drawer_component.dart';
import '../components/most_latest_product_card_component.dart';
import '../components/most_popular_product_card_component.dart';
import '../helpers/invoicelinedb.dart';
import '../helpers/productdb.dart';
import 'package:restart_app/restart_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _controller;
  List<Product> _productlist = [];
  List<Map<String, dynamic>> _popular = [];
  List<Product> _searchList = [];
  bool isSearch = false;
  bool _isLoading = true;
  int totalSoldItem = 0;
  double salesToday = 0;
  double receivable = 0;
  String name = "";
  void _loadData() async {
    final prefernces = await SharedPreferences.getInstance();
    context.read<ThemeColorProvider>().changeColor(
        Color(prefernces.getInt('color') ?? const Color(0xFF2DA15F).value));
    name = prefernces.getString('name') ?? "";
    final result = await InvoiceLineDBHelper.getPopularProduct();
    final listofInvoice = await InvoiceDBHelper.getList();
    final listofInvoiceLine = await InvoiceLineDBHelper.getList();
    final data = await ProductDBHelper.getList();
    setState(() {
      _productlist = data;
      _popular = result;
      listofInvoice.forEach((element) {
        final date = DateTime.now();
        final productDate = DateTime.parse(element.date);

        int yearToday = date.year;
        int monthToday = date.month;
        int productYear = productDate.year;
        int productMonth = date.month;
        if (yearToday == productYear) {
          if (monthToday == productMonth) {
            if (date.day == productDate.day) {
              salesToday += element.totalAmount;
              listofInvoiceLine.forEach((il) {
                if (il.invoiceId == element.id) {
                  totalSoldItem += il.qty;
                }
              });
              if (element.custumerPayAmount != element.totalAmount) {
                receivable += (element.totalAmount - element.custumerPayAmount);
              }
            }
          }
        }
      });
      receivable = salesToday - receivable;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom == 0;
    double width = MediaQuery.of(context).size.width;
    final theme = context.read<ThemeColorProvider>();
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () async {
                    SystemNavigator.pop();
                  },
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
              centerTitle: true,
              title: const Text(
                "iTrack",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isSearch
                    ? Expanded(
                        child: Container(
                            color: Colors.white,
                            child: SearchList(searchList: _searchList)),
                      )
                    : Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              if (!isSearch)
                                Container(
                                  decoration: BoxDecoration(
                                    color: theme.primary,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Hi, $name",
                                              style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Today's sales:",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: Text(
                                                    "Php ${salesToday.toStringAsFixed(2)}", // Peso sign
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "Receivable: Php ${receivable.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  255,
                                                  255,
                                                  255,
                                                  .9,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Sold Items Today:",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12),
                                                  child: Text(
                                                    totalSoldItem
                                                        .toString(), // Peso sign
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                    ),
                                                    height: 48,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        .15,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "Search product...",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(
                                                  Icons
                                                      .document_scanner_outlined,
                                                  size: 30,
                                                  color: Colors.white,
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
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TabBar(
                                  isScrollable: true,

                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  labelColor: Colors.black,
                                  controller: _controller, // length of tabs
                                  tabs: const [
                                    Tab(text: 'Popular'),
                                    Tab(text: 'Latest'),
                                    Tab(text: 'Low stock'),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _controller,
                                  children: [
                                    _popular.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "Data is empty",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .7),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _popular.length,
                                              itemBuilder: (context, index) {
                                                var product =
                                                    _productlist.singleWhere(
                                                  (element) =>
                                                      element.id ==
                                                      _popular[index]
                                                          ['product_id'],
                                                  orElse: () {
                                                    return Product(
                                                        barcode: "",
                                                        name:
                                                            "<Product Not Found>",
                                                        catId: 0,
                                                        description: "",
                                                        price: 0,
                                                        measurement: "",
                                                        retailPrice: 0);
                                                  },
                                                );
                                                return PopularProductCard(
                                                  product: product,
                                                  totalsales: double.parse(
                                                      _popular[index]
                                                              ['totalSales']
                                                          .toString()),
                                                  totalsold: _popular[index]
                                                      ['total'],
                                                );
                                              },
                                            ),
                                          ),
                                    _productlist.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "No item",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .7),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              itemCount:
                                                  _productlist.length >= 3
                                                      ? 3
                                                      : _productlist.length,
                                              itemBuilder: (context, index) {
                                                return LatestProductCard(
                                                    product:
                                                        _productlist[index]);
                                              },
                                            ),
                                          ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            drawer: const MyDrawer(),
          );
  }
}
