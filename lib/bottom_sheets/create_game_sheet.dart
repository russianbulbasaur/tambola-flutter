import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/host_game_blocs/create_game_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/repositories/game_respository/game_repository.dart';
import 'package:tambola/screens/arena/host_board_screen.dart';

import '../common/resources.dart';

class CreateGameSheet extends StatefulWidget {
  const CreateGameSheet({super.key});

  @override
  State<CreateGameSheet> createState() => _CreateGameSheetState();
}

class _CreateGameSheetState extends State<CreateGameSheet> {
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
          createButton(),
          SizedBox(height: 50.h,)
        ],
      ),
    );
  }


  Widget createButton(){
    return RepositoryProvider(
      create: (context) => GameRepository(),
      child: BlocProvider(
          create: (context) => CreateGameBloc(null, context.read<GameRepository>()),
          child: BlocConsumer<CreateGameBloc,CreateGameBlocResponse?>(
              listener: (context,state){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  Resources.user!.isHost = true;
                  return HostBoardScreen(game: state!.game!);
                }));
              },listenWhen: (prev,curr) => (curr!=null && curr.game!=null)
              ,builder: (context,state){
            return AppButton(size: Size(123.w,26.h),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                onPressed: () => createGame(context),
                child: Text("Create game"));
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
        child:Text("Create Game",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).dialogBackgroundColor
          ,),textAlign: TextAlign.center,),
      ),);
  }


  void createGame(BuildContext subContext){
    BlocProvider.of<CreateGameBloc>(subContext).createGame();
  }
}
