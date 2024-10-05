import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tambola/blocs/user_blocs/user_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/dialogs/create_game_dialog.dart';
import 'package:tambola/dialogs/join_game_dialog.dart';
import 'package:tambola/dialogs/login_dialog.dart';
import 'package:tambola/dialogs/name_dialog.dart';
import 'package:tambola/firebase_options.dart';

import '../models/user.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final UserBloc _userBloc = UserBloc(null);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),loginDialog);
    super.initState();
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  void loginDialog() async{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    User user = await showGeneralDialog(context: context, pageBuilder: (context,anim1,anim2){
      return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaY: 3,
        sigmaX: 3
      ),child: const LoginDialog());
    },transitionBuilder: (context,anim1,anim2,child){
      return Transform.translate(offset: Offset(anim1.value, anim1.value),child: child,);
    },transitionDuration: const Duration(seconds: 2),
    barrierDismissible: false) as User;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user.toMap()));
    _userBloc.reloadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).primaryColor,
      body:
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:50.h,bottom: 50.h),
          child: body(),
        ),
      ),);
  }
  
  Widget body(){
    return BlocConsumer<UserBloc,User?>(bloc: _userBloc,builder: (context,state){
      Resources.user = state;
      return Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleAndImage(),
            SizedBox(height: 50.h,),
            buttonsAndFooter(),
          ],),
      );
    }, listener: (context,state){
      loginDialog();
    },listenWhen: (prev,curr) => curr==null,
    buildWhen: (prev,curr) => curr!=null,);
  }

  Widget titleAndImage(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:CrossAxisAlignment.center,children: [
      Text("TAMBOLA",style:
      Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 36.sp,
        letterSpacing: 5.w
      ),),
      SizedBox(height: 10.h,),
      Image.asset("assets/images/welcome_screen_image.png"),
    ],);
  }

  Widget footerText(){
    return Text("Welcome to Tambola Web! Tap, match, and shout 'Tambola!' Dive into the excitement now!",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 14.sp,
        fontWeight: FontWeight.w400
      ),
    textAlign: TextAlign.center,);
  }
  
  Widget buttonsAndFooter(){
    return Column(children: [
      AppButton(size: Size(278.w,41.h),
          backgroundColor:Theme.of(context).secondaryHeaderColor,
          child: const Text("Create Game"),
          onPressed: () => createDialog(const CreateGameDialog())),
      SizedBox(height: 10.h,),
      AppButton(size: Size(278.w,41.h),
          backgroundColor:Theme.of(context).primaryColorDark,
          child: const Text("Join Game"),
          onPressed: () => createDialog(const JoinGameDialog())),
      SizedBox(height: 30.h,),
      footerText()
    ],);
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
                   child: child,
                 )
               ],),
             ),
           );
        }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
           return child;
        },transitionDuration: const Duration(milliseconds: 700));
  }
}
