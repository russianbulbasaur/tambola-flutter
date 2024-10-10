import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tambola/blocs/player_game_blocs/join_game_bloc.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/repositories/game_respository/game_repository.dart';

import '../blocs/user_blocs/user_bloc.dart';
import '../dialogs/login_dialog.dart';
import '../firebase_options.dart';
import '../models/user.dart';
import 'arena/players_ticket_screen.dart';

class JoinGameScreen extends StatefulWidget {
  final String? code;
  const JoinGameScreen({super.key,required this.code});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final UserBloc _userBloc = UserBloc(null);

  @override
  void initState() {
    if(kDebugMode) log("Join code : ${widget.code}");
    if(widget.code!=null) Future.delayed(const Duration(seconds: 1),checkForUser);
    super.initState();
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  void checkForUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");
    if (userString==null) {
      loginDialog();
      return;
    }
    _userBloc.reloadUser();
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
      return child;
    },
        barrierDismissible: false) as User;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user.toMap()));
    _userBloc.reloadUser();
  }

  @override
  Widget build(BuildContext context){
    return BlocBuilder<UserBloc,User?>(
    bloc: _userBloc,builder: (context,state){
      if(state==null) {
        return SizedBox(
          height: 50.h,
          width: 50.h,
          child: CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor,));
      }
      Resources.user = state;
      return gameJoinBloc();
    });
  }


  Widget gameJoinBloc(){
    return RepositoryProvider(create: (context)=>GameRepository(),
    child: BlocProvider(create: (context) => JoinGameBloc.autoJoin(null,
        RepositoryProvider.of<GameRepository>(context),widget.code!),
    child: BlocListener<JoinGameBloc,JoinGameBlocResponse?>(listener: (context,state){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        Resources.user!.isHost = false;
        return PlayersTicketScreen(game: state!.game!);
      }));
    },listenWhen: (prev,curr) => (curr!=null && curr.game!=null),
    child: SizedBox(
        height: 50.h,
        width: 50.h,
        child: CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor,)),),),);
  }
}
