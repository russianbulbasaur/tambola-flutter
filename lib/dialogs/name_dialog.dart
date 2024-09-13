import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/common/resources.dart';

import '../common/app_button.dart';
import '../models/user.dart';

class NameDialog extends StatefulWidget {
  const NameDialog({super.key});

  @override
  State<NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      height: 317.h,
      child: dialogContent(),
    );
  }

  Widget dialogContent(){
    return Stack(fit: StackFit.expand,
      children: [
        Align(alignment: Alignment.topCenter,
          child: titleBanner(),),
        Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nameField(),
            SizedBox(height: 20.h,),
            createButton(context)
          ],
        )
      ],
    );
  }


  Widget nameField(){
    return Material(color: Colors.transparent,
      child: Container(width: 190.w,
        height: 43.h,
        color: Colors.transparent,
        child: TextField(controller: _nameController,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white
        ),
        decoration: InputDecoration(border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide(color: Colors.white70)),
        fillColor: Theme.of(context).primaryColorDark,
        filled: true),),
      ),
    );
  }

  Widget titleBanner(){
    return Container(height: 50.h,
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
      child: Center(
        child:Text("Your Name",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 30.sp,
              color: Theme.of(context).dialogBackgroundColor
          ),),
      ),);
  }

  Widget createButton(BuildContext subContext){
    return AppButton(size: Size(278.w,41.h),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        onPressed:  createUser,
        child: Text("Continue"));
  }

  void createUser(){
    print(_nameController.text);
    if(_nameController.text.isEmpty) return;
    Resources.user = User(Random().nextInt(100000),_nameController.text);
    Navigator.pop(context);
  }
}
