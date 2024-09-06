import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tambola/blocs/host_game_blocs/call_number_bloc.dart';
import 'package:tambola/bottom_sheets/waiting_for_players_host_sheet.dart';
import 'package:tambola/bottom_sheets/waiting_for_players_player_sheet.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/user.dart';

class HostBoardScreen extends StatefulWidget {
  final Game game;
  const HostBoardScreen({super.key,required this.game});

  @override
  State<HostBoardScreen> createState() => _HostBoardScreenState();
}

class _HostBoardScreenState extends State<HostBoardScreen> {
  late HashSet<int> bag;
  @override
  void initState() {
    bag = HashSet();
    bag.addAll(List.generate(90, (index) => index+1));
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    Object? result = await showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersHostSheet(game: widget.game);
    });
    callNumber();
  }

  void callNumber(){
    List<int> set = bag.toList();
    int index = Random().nextInt(set.length);
    int number = set[index];
    bag.remove(number);
    CallNumberBloc(false).call(number, widget.game);
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blueAccent,);
  }
}
