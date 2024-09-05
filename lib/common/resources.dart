import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Resources{
  static ThemeData lightThemeData = ThemeData(
    primaryColor: Colors.white,
    dialogBackgroundColor: const Color(0xff2c282e),
    secondaryHeaderColor: const Color(0xffe2dd30),
    primaryColorDark: const Color(0xff2c382e),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.roboto()
    )
  );

  //server url
  static String url = "";
}