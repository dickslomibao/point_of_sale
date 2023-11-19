import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/screen/credits_screen.dart';
import 'package:point_of_sales/screen/settings.screen.dart';
import 'package:point_of_sales/screen/account_screen.dart';
import 'package:point_of_sales/screen/switchstore_screen.dart';
import 'package:point_of_sales/screen/transaction_screen.dart';
import 'package:provider/provider.dart';
import '../provider/theme_color.dart';
import '../screen/change_theme_screen.dart';
import '../screen/product_screen.dart';
import '../screen/sales_screen.dart';
import '/screen/category_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'drawer_link_component.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final theme = context.read<ThemeColorProvider>();

    return Drawer(
      backgroundColor: theme.primary,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.track_changes_outlined,
                  color: Colors.white,
                  size: 70,
                ),
                Center(
                  child: Text(
                    "iTrack",
                    style: GoogleFonts.lato(fontSize: 35, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.white,
            height: height * .75,
            child: Column(
              children: [
                DrawerLink(
                  icon: const Icon(Icons.category_outlined),
                  title: "Category",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: CategoryScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => CategoryScreen(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.card_travel_outlined),
                  title: "Transaction",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: TransactionScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => TransactionScreen(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.money_outlined),
                  title: "Reports",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: SalesScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => SalesScreen(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.credit_card),
                  title: "Credits",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: CreditsScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => CreditsScreen(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.storefront_rounded),
                  title: "Stores",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: Switchstore(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => Switchstore(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.supervised_user_circle),
                  title: "Account",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AccountScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => AccountScreen(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.settings),
                  title: "Settings",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: SettingsScreenn(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => SettingsScreenn(),
                    //   ),
                    // );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.settings),
                  title: "Color Theme",
                  onPress: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: ThemeScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => SettingsScreenn(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
