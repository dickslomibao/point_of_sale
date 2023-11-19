import 'package:flutter/material.dart';
import 'package:point_of_sales/color.dart';
import 'package:point_of_sales/provider/customer_view_screen_provider.dart';
import 'package:point_of_sales/provider/order_screen_provider.dart';
import 'package:point_of_sales/provider/print_reciept_provider.dart';
import 'package:point_of_sales/provider/theme_color.dart';
import 'package:point_of_sales/screen/main_screen.dart';
import 'package:point_of_sales/screen/pin_verification_screen.dart';
import 'package:point_of_sales/screen/print.dart';
import 'package:point_of_sales/screen/setpin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

bool havePin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final preferences = await SharedPreferences.getInstance();
  havePin = preferences.containsKey('pin');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomerViewScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PrintRecieptProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeColorProvider(),
        )
      ],
      child: Consumer<ThemeColorProvider>(
        builder: (context, value, child) {
          print('asd123');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: value.myColor,
              appBarTheme: AppBarTheme(
                backgroundColor: value.primary,
              ),
            ),

            // home: PrintScreen(),
            home:
                havePin ? PinVerificationScreen() : SetPinVerificationScreen(),
            routes: {
              '/home': (context) => MainScren(),
            },
          );
        },
      ),
    ),
  );
}
