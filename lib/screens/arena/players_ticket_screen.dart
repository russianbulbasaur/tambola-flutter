import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/core_game_blocs/monitor.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/models/game.dart';
import '../../bottom_sheets/waiting_for_players_player_sheet.dart';

class PlayersTicketScreen extends StatefulWidget {
  final Game game;
  const PlayersTicketScreen({super.key,required this.game});

  @override
  State<PlayersTicketScreen> createState() => _PlayersTicketScreenState();
}

class _PlayersTicketScreenState extends State<PlayersTicketScreen> {
  late Monitor _monitor;
  @override
  void initState() {
    _monitor = Monitor(WaitingState(), widget.game.state);
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersPlayerSheet(game: widget.game,monitor: _monitor,);
    });
    monitorGame();
  }

  void monitorGame() async{
    widget.game.setListener((data){
      _monitor.parse(data);
    });
    widget.game.listen();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Monitor,GameBlocState>(bloc: _monitor,
      listener: (context,state){},
      builder: (context,state){
      if(widget.game.state.numbersCalled.length==0) return Container();
        return Center(
          child: Text(widget.game.state.numbersCalled[widget.game.state.numbersCalled.length-1].toString(),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 60.sp
          ),),
        );
      },buildWhen: (prev,curr) => curr is NumberCalledState,
    );
  }
}
