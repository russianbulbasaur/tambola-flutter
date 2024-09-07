import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

import '../blocs/core_game_blocs/monitor.dart';

class WaitingForPlayersPlayerSheet extends StatefulWidget {
  final Game game;
  const WaitingForPlayersPlayerSheet({super.key,required this.game});

  @override
  State<WaitingForPlayersPlayerSheet> createState() => _WaitingForPlayersPlayerSheetState();
}

class _WaitingForPlayersPlayerSheetState extends State<WaitingForPlayersPlayerSheet> {
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
            if(widget.game.state.status==GameStatus.playing) {
              if (context.mounted) {
                widget.game.removeListener();
                monitor.close();
                Navigator.pop(context);
              }
            }
          },
          builder: (context,state){
            return ListView.builder(itemBuilder: (context,index){
              return playerTile(widget.game.state.players[index]);
            },itemCount: widget.game.state.players.length,);
          },
        ),
      ),
    );
  }

  Widget playerTile(User player){
    return ListTile(title:
    Text(player.name));
  }
}
