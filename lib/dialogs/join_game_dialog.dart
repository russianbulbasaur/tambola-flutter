import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/screens/arena/players_ticket_screen.dart';

import '../blocs/host_game_blocs/create_game_bloc.dart';
import '../blocs/player_game_blocs/join_game_bloc.dart';
import '../common/app_button.dart';
import '../common/resources.dart';
import '../models/user.dart';
import '../repositories/game_respository/game_repository.dart';

class JoinGameDialog extends StatefulWidget {
  const JoinGameDialog({super.key});

  @override
  State<JoinGameDialog> createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
      decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
      height: MediaQuery.of(context).size.height/3,
      child: dialogContent(),
    );
  }

  Widget dialogContent(){
    return RepositoryProvider(
      create: (context) => GameRepository(),
      child: BlocProvider(
          create: (context) => JoinGameBloc(null, context.read<GameRepository>()),
          child: Builder(builder: (context){
            return Column(children: [
              titleBanner(),
              SizedBox(height: 50.h,),
              codeField(),
              SizedBox(height: 20.h,),
              createButton(context)
            ],);
          })
      ),
    );
  }

  Widget codeField(){
    return Material(
        child: TextField(controller: _codeController,));
  }

  Widget titleBanner(){
    return BlocConsumer<JoinGameBloc,JoinGameBlocResponse?>(
        listener: (context,state){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            Resources.user!.type = UserType.player;
            return PlayersTicketScreen(game: state!.game!);
          }));
        },listenWhen: (prev,curr) => (curr!=null && curr.game!=null)
        ,builder: (context,state){
      return Container(height: 50.h,
        decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
        child: Center(
          child:Text("Enter Game Code",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 50.sp,
                color: Theme.of(context).dialogBackgroundColor
            ),),
        ),);
    });
  }

  Widget createButton(BuildContext subContext){
    return AppButton(size: Size(300.w,50.w),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        onPressed: () => joinGame(subContext),
        child: Text("Join"));
  }

  void joinGame(BuildContext subContext){
    if(_codeController.text.trim().isEmpty) return;
    BlocProvider.of<JoinGameBloc>(subContext).joinGame(_codeController.text);
  }
}
