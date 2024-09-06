import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';
import 'package:tambola/repositories/user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameRepository{


  Future<Game> createGame() async{
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
        "ws://${Resources.ipPort}/game/create?user_id=${Resources.user!.id}&"
            "name=${Resources.user!.name}"));
    await channel.ready;
    GameState state = GameState(GameStatus.waiting,List.empty(growable: true),List.empty(growable: true),
        List.empty(growable: true));
    Game game = Game(0,state,
        channel.stream,channel.sink);
    state.game = game;
    return game;
  }

  void cancelGame(){}

  Future<Game> joinGame(String code) async {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse("ws://${Resources.ipPort}/game/join?user_id=${Resources.user!.id}&name=${Resources.user!.name}&"
          "code=$code")
    );
    await channel.ready;
    GameState state = GameState(GameStatus.waiting,List.empty(growable: true),List.empty(growable: true),
        List.empty(growable: true));
    Game game = Game(0,state,
        channel.stream,channel.sink);
    state.game = game;
    return game;
  }
}