import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // static ThemeData otherTheme = const ThemeData(primaryColor: Colors.blue)

  static ThemeData defaultTheme = ThemeData(
      // primarySwatch: Colors.orange,
      appBarTheme: AppBarTheme(color: AppColors.darkGray, elevation: 0),
      primaryColor: AppColors.primary,

      // accentColor: AppColors.primary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: GoogleFonts.lato().fontFamily,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 7)),
            backgroundColor:
                MaterialStateProperty.all(Colors.white.withAlpha(0)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(70)),
            textStyle:
                MaterialStateProperty.all(const TextStyle(color: Colors.black)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(color: Colors.white.withAlpha(70), width: 2),
              ),
            )
            // shape: MaterialStateProperty.all(Border.cir)
            ),
      ),
      buttonTheme: ButtonThemeData(
          focusColor: Colors.white.withAlpha(100),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          buttonColor: Colors.white,
          // textTheme: TextTheme,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: Colors.white))),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        labelPadding: const EdgeInsets.all(0),
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white.withAlpha(50)),
      ),
      textTheme: TextTheme(
        bodySmall: const TextStyle(color: Colors.white, fontSize: 10),
        titleMedium: TextStyle(color: AppColors.gray2, fontSize: 10),
        titleSmall: const TextStyle(color: Colors.white, fontSize: 10),
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontFamily:
              GoogleFonts.montserrat(fontWeight: FontWeight.w700).fontFamily,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily:
              GoogleFonts.montserrat(fontWeight: FontWeight.w700).fontFamily,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily:
              GoogleFonts.montserrat(fontWeight: FontWeight.w700).fontFamily,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily:
              GoogleFonts.montserrat(fontWeight: FontWeight.w700).fontFamily,
        ),
        headlineSmall: TextStyle(
          color: AppColors.gray2,
          fontSize: 12,
          fontFamily:
              GoogleFonts.montserrat(fontWeight: FontWeight.w400).fontFamily,
        ),
        titleLarge: TextStyle(
          color: AppColors.gray3,
          fontSize: 13,
          fontFamily:
              GoogleFonts.montserrat(fontWeight: FontWeight.w400).fontFamily,
        ),
        bodyLarge: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      scaffoldBackgroundColor: AppColors.darkGray);
}

class AppColors {
  static Color primary = blue;
  static Color darkGray = const Color.fromRGBO(26, 27, 38, 1);
  static Color lightGray = gray2;
  static Color turquoise = const Color.fromRGBO(42, 195, 222, 1);
  static Color red = const Color.fromRGBO(247, 118, 142, 1);
  static Color green = const Color.fromRGBO(158, 206, 106, 1);
  static Color yellow = const Color.fromRGBO(224, 175, 104, 1);
  static Color orange = const Color.fromRGBO(255, 158, 100, 1);
  static Color blue = const Color.fromRGBO(125, 207, 255, 1);
  static Color purple = const Color.fromRGBO(187, 154, 247, 1);
  static Color gray1 = const Color.fromRGBO(154, 165, 206, 1);
  static Color gray2 = const Color.fromRGBO(86, 95, 137, 1);
  static Color gray3 = const Color.fromRGBO(65, 72, 104, 1);
}
