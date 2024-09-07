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
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (context,index){
        return playerTile(widget.game.state.players[index]);
      },itemCount: widget.game.state.players.length,)
    );
  }

  Widget playerTile(User player){
    return ListTile(title:
    Text(player.name));
  }
}
