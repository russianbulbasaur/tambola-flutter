import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/blocs/host_game_blocs/begin_game_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

import '../blocs/core_game_blocs/monitor.dart';

class WaitingForPlayersHostSheet extends StatefulWidget {
  final Game game;
  const WaitingForPlayersHostSheet({super.key,required this.game});

  @override
  State<WaitingForPlayersHostSheet> createState() => _WaitingForPlayersHostSheetState();
}

class _WaitingForPlayersHostSheetState extends State<WaitingForPlayersHostSheet> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Game Id : ${widget.game.id}"),
          SizedBox(height: MediaQuery.of(context).size.height/3,
            child: ListView.builder(itemBuilder: (context,index){
              return playerTile(widget.game.state.players[index]);
            },itemCount: widget.game.state.players.length,),
          ),
          buttons()
        ],
      )
    );
  }

  Widget playerTile(User player){
    return ListTile(title:
    Text(player.name));
  }

  Widget buttons(){
    return Row(children: [
      AppButton(size: Size(200,50),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: Text("Begin Game"), onPressed: startGame)
    ],);
  }

  void startGame(){
    BeginGameBloc(false).start(widget.game);
  }
}
