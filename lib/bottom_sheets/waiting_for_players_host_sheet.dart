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
  late Monitor monitor;
  @override
  void initState() {
    monitor = Monitor(0,widget.game.state);
    socketListener();
    super.initState();
  }

  void socketListener(){
    widget.game.attachListener((data){
      monitor.parse(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(create: (context) => monitor,
        child: BlocConsumer<Monitor,int>(
          listener: (context,state){
            if(widget.game.state.status==GameStatus.playing){
              if(context.mounted) {
                monitor.close();
                widget.game.removeListener();
                Navigator.pop(context);
              }
            }
          },
          builder: (context,state){
            return Column(
              children: [
                Text(widget.game.id.toString()),
                SizedBox(height: MediaQuery.of(context).size.height/3,
                  child: ListView.builder(itemBuilder: (context,index){
                    return playerTile(widget.game.state.players[index]);
                  },itemCount: widget.game.state.players.length,),
                ),
                buttons()
              ],
            );
          },
        ),
      ),
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

  @override
  void dispose() {
    widget.game.removeListener();
    monitor.close();
    super.dispose();
  }
}
