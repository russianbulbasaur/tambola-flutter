import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/screens/welcome_screen.dart';

void main() {
  runApp(const TambolaApp());
}

class TambolaApp extends StatelessWidget {
  const TambolaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(designSize: const Size(390,844),
    builder: (_,child){
      return MaterialApp(
        builder: (context,child) => child!,
        theme: Resources.lightThemeData,
        onGenerateRoute: Resources.route,
      );
    },);
  }
}

