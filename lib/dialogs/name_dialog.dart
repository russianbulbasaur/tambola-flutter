import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/repositories/user_repository/user_repository.dart';

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
      decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
      height: MediaQuery.of(context).size.height/3,
      child: dialogContent(),
    );
  }

  Widget dialogContent(){
    return Column(children: [
      titleBanner(),
      SizedBox(height: 50.h,),
      nameField(),
      SizedBox(height: 20.h,),
      createButton(context)
    ],);
  }


  Widget nameField(){
    return Material(
        child: TextField(controller: _nameController,));
  }

  Widget titleBanner(){
    return Container(height: 50.h,
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
      child: Center(
        child:Text("Your Name",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 50.sp,
              color: Theme.of(context).dialogBackgroundColor
          ),),
      ),);
  }

  Widget createButton(BuildContext subContext){
    return AppButton(size: Size(300.w,50.w),
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
