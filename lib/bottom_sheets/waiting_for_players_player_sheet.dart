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
        SelectableText("Game Id : ${monitor.game.id}\n Waiting for players",textAlign: TextAlign.center,),
        CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor,),
        SizedBox(height: MediaQuery.of(context).size.height/3,
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
      ],
    );
  }

  Widget playerTile(User player){
    return ListTile(title:
    Text(player.name),
      leading: const Icon(Icons.person),);
  }
}
