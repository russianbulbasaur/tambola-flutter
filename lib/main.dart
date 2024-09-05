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
    return ScreenUtilInit(designSize: const Size(930,640),
    builder: (_,child){
      return MaterialApp(
        theme: Resources.lightThemeData,
        initialRoute: "/",
        onGenerateRoute: Resources.route,
      );
    },
    child: const WelcomeScreen(),);
  }
}

