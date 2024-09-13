import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final Size size;
  final Color backgroundColor;
  final Widget child;
  final Function() onPressed;
  const AppButton({super.key,required this.size,
    required this.backgroundColor,required this.child,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed:onPressed,
    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(backgroundColor),
    fixedSize: WidgetStatePropertyAll(size),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: 
    BorderRadius.circular(10.r)))),
    child: Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
      ],
    ),);
  }
}
