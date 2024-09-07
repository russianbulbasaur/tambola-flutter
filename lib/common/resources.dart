import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tambola/screens/welcome_screen.dart';

import '../models/user.dart';

class Resources{
  static User? user;

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
  static String ipPort = "127.0.0.1:8000";

  static Route route(RouteSettings settings){
    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder:(context){
          return const WelcomeScreen();
        });
      default:
        return MaterialPageRoute(builder: (context){
          return const WelcomeScreen();
        });
    }
  }
}