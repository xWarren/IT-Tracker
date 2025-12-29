import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimensions.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CustomColors.white,
    primaryColor: CustomColors.primary,
    fontFamily: "Inter",
    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.white,
      elevation: 0,
      titleTextStyle: TextStyle(color: CustomColors.black, fontSize: 16.0, fontWeight: FontWeight.w500)
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent, elevation: 0.0),
    scrollbarTheme: const ScrollbarThemeData(
      trackVisibility: WidgetStatePropertyAll(true),
      radius: Radius.circular(Dimensions.radiusMedium),
      thumbColor: WidgetStatePropertyAll(CustomColors.tertiary),
      trackColor: WidgetStatePropertyAll(CustomColors.tertiary)
    )
  );
}