import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/repositories/game_respository/game_repository.dart';

class WaitingForPlayersScreen extends StatefulWidget {
  final Game game;
  const WaitingForPlayersScreen({super.key,required this.game});

  @override
  State<WaitingForPlayersScreen> createState() => _WaitingForPlayersScreenState();
}

class _WaitingForPlayersScreenState extends State<WaitingForPlayersScreen> {

  @override
  void initState() {
    what();
    super.initState();
  }

  void what() async{
    GameRepository repo = GameRepository();
    Game game = await repo.createGame();
    game.socketStream!.listen((data){
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
