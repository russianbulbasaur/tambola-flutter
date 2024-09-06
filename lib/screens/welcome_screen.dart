import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/dialogs/create_game_dialog.dart';
import 'package:tambola/dialogs/join_game_dialog.dart';
import 'package:tambola/dialogs/name_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).primaryColor,
      body:
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w,top:50.h,right: 20.w,bottom: 50.h),
          child: body(),
        ),
      ),);
  }
  
  Widget body(){
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          titleAndImage(),
          SizedBox(height: 50.h,),
          buttonsAndFooter(),
      ],),
    );
  }

  Widget titleAndImage(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:CrossAxisAlignment.center,children: [
      Text("TAMBOLA",style:
      Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 100.sp,
        letterSpacing: 5.w
      ),),
      SizedBox(height: 10.h,),
      Image.asset("assets/images/welcome_screen_image.png"),
    ],);
  }

  Widget footerText(){
    return Text("Welcome to Tambola Web! Tap, match, and shout 'Tambola!' Dive into the excitement now!",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 30.sp
      ),
    textAlign: TextAlign.center,);
  }
  
  Widget buttonsAndFooter(){
    return Padding(
      padding: EdgeInsets.only(left: 150.w,right: 150.w),
      child: Column(children: [
        AppButton(size: Size(MediaQuery.of(context).size.width,35.h),
            backgroundColor:Theme.of(context).secondaryHeaderColor,
            child: const Text("Create Game"),
            onPressed: () => initUserDialog(const CreateGameDialog())),
        SizedBox(height: 10.h,),
        AppButton(size: Size(MediaQuery.of(context).size.width,35.h),
            backgroundColor:Theme.of(context).primaryColorDark,
            child: const Text("Join Game"),
            onPressed: () => initUserDialog(const JoinGameDialog())),
        SizedBox(height: 30.h,),
        footerText()
      ],),
    );
  }

  void initUserDialog(Widget child) async{
    await showGeneralDialog(context: context,
        transitionBuilder: (context,anim1,anim2,child){
          return BackdropFilter(filter:
          ImageFilter.blur(sigmaX: 11,sigmaY: 11,),
            child: Center(
              child: Wrap(children: [
                Transform.scale(
                  scaleX: anim1.value,
                  scaleY: anim1.value,
                  child: const NameDialog(),
                )
              ],),
            ),
          );
        }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return child;
        });
    if(Resources.user!=null) createDialog(child);
  }

  void createDialog(Widget child) async{
    Object? result = await showGeneralDialog(context: context,
        transitionBuilder: (context,anim1,anim2,child){
           return BackdropFilter(filter:
           ImageFilter.blur(sigmaX: 11,sigmaY: 11,),
             child: Center(
               child: Wrap(children: [
                 Transform.scale(
                   scaleX: anim1.value,
                   scaleY: anim1.value,
                   child: child,
                 )
               ],),
             ),
           );
        }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
           return child;
        });
  }
}
