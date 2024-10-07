import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

import '../blocs/core_game_blocs/monitor.dart';

class WaitingForPlayersPlayerSheet extends StatefulWidget {
  final Monitor monitor;
  const WaitingForPlayersPlayerSheet({super.key,required this.monitor});

  @override
  State<WaitingForPlayersPlayerSheet> createState() => _WaitingForPlayersPlayerSheetState();
}

class _WaitingForPlayersPlayerSheetState extends State<WaitingForPlayersPlayerSheet> {
  late Monitor monitor;

  @override
  void initState() {
    monitor = widget.monitor;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:PopScope(canPop: false,
          child: body(),
        )
    );
  }

  Widget body(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        gameDetails(),
        SizedBox(height: 20.h,),
        playersList(),
        SizedBox(height: 20.h,)
      ],
    );
  }

  Widget gameDetails(){
    return Column(
      children: [
        Container(decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20.w,right: 20.w),
          child: Row(
            children: [
              SelectableText("Game Id : ${monitor.game.id}\nWaiting for players",textAlign: TextAlign.left),
              const Spacer(),
              Icon(Icons.settings,color: Theme.of(context).primaryColorDark,)
            ],
          ),
        ),
      ],
    );
  }

  Widget playersList(){
    return Expanded(
      child: BlocConsumer<Monitor,GameBlocState>(bloc: monitor,
        listener: (context,state) => Navigator.pop(context),
        listenWhen: (prev,curr) => curr is GameStatusChangedState && monitor.game.state.status==GameStatus.playing,
        builder: (context,state){
          return GridView.builder(gridDelegate: const
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder:(context,index){
                return playerTile(monitor.game.state.players[index]);
              },itemCount: monitor.game.state.players.length);
        },buildWhen: (prev,curr) => curr is UserJoinedState,
      ),
    );
  }

  Widget playerTile(User player){
    return SizedBox(height: 93.h,width: 68.w,
      child:Column(children: [
        CircleAvatar(radius: 34.r,
        child: Icon(Icons.person),),
        SizedBox(height: 10.h,),
        Text(player.name)
      ],),);
  }

}
