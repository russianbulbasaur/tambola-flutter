import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

import '../blocs/core_game_blocs/monitor.dart';

class WaitingForPlayersPlayerSheet extends StatefulWidget {
  final Game game;
  final Monitor monitor;
  const WaitingForPlayersPlayerSheet({super.key,required this.game,required this.monitor});

  @override
  State<WaitingForPlayersPlayerSheet> createState() => _WaitingForPlayersPlayerSheetState();
}

class _WaitingForPlayersPlayerSheetState extends State<WaitingForPlayersPlayerSheet> {
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
              child: BlocConsumer<Monitor,GameBlocState>(bloc: widget.monitor,
                listener: (context,state) => Navigator.pop(context),
                listenWhen: (prev,curr) => curr is GameStatusChangedState && widget.game.state.status==GameStatus.playing,
                builder: (context,state){
                  return ListView.builder(itemBuilder: (context,index){
                    return playerTile(widget.game.state.players[index]);
                  },itemCount: widget.game.state.players.length,);
                },buildWhen: (prev,curr) => curr is UserJoinedState,
              ),
            ),
          ],
        )
    );
  }

  Widget playerTile(User player){
    return ListTile(title:
    Text(player.name));
  }
}
