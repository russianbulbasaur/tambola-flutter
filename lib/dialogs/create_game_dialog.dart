import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/host_game_blocs/create_game_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/repositories/game_respository/game_repository.dart';
import 'package:tambola/screens/waiting_for_players_screen.dart';

class CreateGameDialog extends StatefulWidget {
  const CreateGameDialog({super.key});

  @override
  State<CreateGameDialog> createState() => _CreateGameDialogState();
}

class _CreateGameDialogState extends State<CreateGameDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
      height: MediaQuery.of(context).size.height/3,
      child: dialogContent(),
    );
  }

  Widget dialogContent(){
    return RepositoryProvider(
      create: (context) => GameRepository(),
      child: BlocProvider(
        create: (context) => CreateGameBloc(null, context.read<GameRepository>()),
        child: Builder(builder: (context){
          return Column(children: [
            titleBanner(),
            SizedBox(height: 50.h,),
            createButton(context)
          ],);
        })
      ),
    );
  }

  Widget titleBanner(){
    return BlocConsumer<CreateGameBloc,CreateGameBlocResponse?>(
    listener: (context,state){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return WaitingForPlayersScreen(game: state!.game!,);
      }));
    },listenWhen: (prev,curr) => (curr!=null && curr.game!=null)
    ,builder: (context,state){
      return Container(height: 50.h,
        decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
        child: Center(
          child:Text("Create Game",
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
        onPressed: () => createGame(subContext),
        child: Text("Create game"));
  }

  void createGame(BuildContext subContext){
    BlocProvider.of<CreateGameBloc>(subContext).createGame();
  }
}
