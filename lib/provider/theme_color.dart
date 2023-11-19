import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeColorProvider extends ChangeNotifier {
  List<Color> colors = [
    Color(0xFF860A35),
    Color(0xFF4F6F52),
    Color(0xFF3D30A2),
    Color(0xFF190482),
    Color(0xFFF9B572),
    Color(0xFFCD5C08),
    Color(0xFFC70039),
    Color(0xFFD83F31),
    Color(0xFF610C9F),
    Color(0xFF451952),
    Color(0xFF3D246C),
    Color(0xFF40128B),
    Color(0xFFFFB84C),
    Color(0xFF9A208C),
    Color(0xFFFE6244),
    Color(0xFFA86464),
  ];

  Color primary = Color(0xFF2DA15F);
  MaterialColor myColor = const MaterialColor(
    0xFF2DA15F,
    <int, Color>{
      50: Color(0xFF2DA15F),
      100: Color(0xFF2DA15F),
      200: Color(0xFF2DA15F),
      300: Color(0xFF2DA15F),
      400: Color(0xFF2DA15F),
      500: Color(0xFF2DA15F),
      600: Color(0xFF2DA15F),
      700: Color(0xFF2DA15F),
      800: Color(0xFF2DA15F),
      900: Color(0xFF2DA15F),
    },
  );

  void changeColor(Color colorCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color', colorCode.value);
    primary = colorCode;
    myColor = MaterialColor(
      0xFF2DA15F,
      <int, Color>{
        50: colorCode,
        100: colorCode,
        200: colorCode,
        300: colorCode,
        400: colorCode,
        500: colorCode,
        600: colorCode,
        700: colorCode,
        800: colorCode,
        900: colorCode,
      },
    );
    print('asd');
    notifyListeners();
  }
}
