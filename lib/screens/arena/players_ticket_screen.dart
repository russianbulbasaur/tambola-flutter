import 'package:flutter/material.dart';
import 'package:tambola/models/game.dart';

import '../../bottom_sheets/waiting_for_players_host_sheet.dart';

class PlayersTicketScreen extends StatefulWidget {
  final Game game;
  const PlayersTicketScreen({super.key,required this.game});

  @override
  State<PlayersTicketScreen> createState() => _PlayersTicketScreenState();
}

class _PlayersTicketScreenState extends State<PlayersTicketScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    Object? result = await showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersHostSheet(game: widget.game);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blueAccent,);
  }
}
