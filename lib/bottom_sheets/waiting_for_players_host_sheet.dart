import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/host_game_blocs/begin_game_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

import '../blocs/core_game_blocs/monitor.dart';

class WaitingForPlayersHostSheet extends StatefulWidget {
  final Monitor monitor;
  const WaitingForPlayersHostSheet({super.key,required this.monitor});

  @override
  State<WaitingForPlayersHostSheet> createState() => _WaitingForPlayersHostSheetState();
}

class _WaitingForPlayersHostSheetState extends State<WaitingForPlayersHostSheet> {
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
        child: Padding(padding: EdgeInsets.only(
          left: 50.w,
          right: 50.w,
        ),
        child: body(),),
      )
    );
  }

  Widget body(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SelectableText("Game Id : ${monitor.game.id}\nWaiting for players",textAlign: TextAlign.center,),
        CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor,),
        Expanded(
          child: BlocConsumer<Monitor,GameBlocState>(bloc: monitor,
            listener: (context,state) => Navigator.pop(context),
            listenWhen: (prev,curr) => curr is GameStatusChangedState && monitor.game.state.status==GameStatus.playing,
            builder: (context,state){
              return ListView.builder(itemBuilder: (context,index){
                return playerTile(monitor.game.state.players[index]);
              },itemCount: monitor.game.state.players.length,);
            },buildWhen: (prev,curr) => curr is UserJoinedState,
          ),
        ),
        buttons()
      ],
    );
  }

  Widget playerTile(User player){
    return ListTile(title:
    Text(player.name),
    leading: const Icon(Icons.person),);
  }

  Widget buttons(){
    return Row(mainAxisAlignment: MainAxisAlignment.center,children: [
      AppButton(size: Size(200,50),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: Text("Begin Game"), onPressed: startGame)
    ],);
  }

  void startGame(){
    BeginGameBloc(false).start(monitor.game);
  }
}
