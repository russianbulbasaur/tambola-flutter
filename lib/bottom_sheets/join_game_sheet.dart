import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/screens/arena/players_ticket_screen.dart';
import '../blocs/player_game_blocs/join_game_bloc.dart';
import '../common/app_button.dart';
import '../common/resources.dart';
import '../repositories/game_respository/game_repository.dart';

class JoinGameSheet extends StatefulWidget {
  const JoinGameSheet({super.key});

  @override
  State<JoinGameSheet> createState() => _JoinGameSheetState();
}

class _JoinGameSheetState extends State<JoinGameSheet> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(27.r),
          topRight: Radius.circular(27.r)),
    ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleBanner(),
          SizedBox(height: 50.h,),
          codeField(),
          SizedBox(height: 50.h,),
          joinButton(),
          SizedBox(height: 50.h,),
        ],
      ),
    );
  }


  Widget joinButton(){
    return RepositoryProvider(
      create: (context) => GameRepository(),
      child: BlocProvider(
          create: (context) => JoinGameBloc(null, context.read<GameRepository>()),
          child: BlocConsumer<JoinGameBloc,JoinGameBlocResponse?>(
              listener: (context,state){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  Resources.user!.isHost = false;
                  return PlayersTicketScreen(game: state!.game!);
                }));
              },listenWhen: (prev,curr) => (curr!=null && curr.game!=null)
              ,builder: (context,state){
            return AppButton(size: Size(123.w,26.h),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                onPressed: () => joinGame(context),
                child: Text("Join game"));
          })
      ),
    );
  }


  Widget titleBanner(){
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(27.r),
    topRight: Radius.circular(27.r))),
      child: Center(
        child:Text("Enter Game Code",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).dialogBackgroundColor
            ,),textAlign: TextAlign.center,),
      ),);
  }


  Widget codeField(){
    return Material(color: Colors.transparent,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.only(left: 40.w,right: 40.w),
        color: Colors.transparent,
        child: TextField(controller: _codeController,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white
          ),
          decoration: InputDecoration(border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(11.r),
              borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor)),
              fillColor: Theme.of(context).dialogBackgroundColor,
              filled: true),),
      ),
    );
  }

  void joinGame(BuildContext subContext){
    if(_codeController.text.trim().isEmpty) return;
    BlocProvider.of<JoinGameBloc>(subContext).joinGame(_codeController.text);
  }
}
