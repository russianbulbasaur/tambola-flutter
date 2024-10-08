import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/host_game_blocs/begin_game_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/common/resources.dart';
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
    return PopScope(canPop: false,
      child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(27.r),
              topRight: Radius.circular(27.r))
      ),
      child: body()),
    );
  }

  Widget body(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        gameDetails(),
        SizedBox(height: 20.h,),
        playersList(),
        SizedBox(height: 10.h,),
        buttons(),
        SizedBox(height: 20.h,),
      ],
    );
  }
  
  Widget gameDetails(){
    return Container(decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(27.r),
            topRight: Radius.circular(27.r))),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.w,right: 20.w,
      top: 10.h,bottom: 10.h),
      child: Row(
        children: [
          SelectableText("Game Id : ${monitor.game.id}\nWaiting for players",textAlign: TextAlign.left,),
          const Spacer(),
          GestureDetector(
          onTap: (){
            ClipboardData data = ClipboardData(text: "${Resources.httpIpPort}/game/join?code=${monitor.game.id}");
            Clipboard.setData(data);
          },child: Icon(Icons.share,color: Theme.of(context).primaryColorDark,))
        //  Icon(Icons.settings,color: Theme.of(context).primaryColorDark,)
        ],
      ),
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

  Widget buttons(){
    return AppButton(size: Size(123.w,26.h),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        child: Text("Begin Game"), onPressed: startGame);
  }

  void startGame(){
    BeginGameBloc(false).start(monitor.game);
  }
}
