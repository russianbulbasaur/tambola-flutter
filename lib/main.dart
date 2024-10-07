import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
        builder: (context,child) => ResponsiveBreakpoints(breakpoints:const [
              Breakpoint(start: 0, end: 450, name: MOBILE),
              Breakpoint(start: 451, end: 800, name: TABLET),
              Breakpoint(start: 801, end: 1920, name: DESKTOP),
              Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ], child: child!),
        theme: Resources.lightThemeData,
        initialRoute: "/",
        onGenerateRoute: Resources.route,
      );
    },
    child: const WelcomeScreen(),);
  }
}

