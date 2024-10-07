import 'dart:async';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameRepository{


  Future<Game> createGame() async{
    if(Resources.user==null) throw "User is null";
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
        "ws://${Resources.ipPort}/game/create?token=${Resources.user!.token}"));
    await channel.ready;
    GameState state = GameState(GameStatus.waiting,List.empty(growable: true),List.empty(growable: true),
        List.empty(growable: true));
    Game game = Game("",state,
        channel.stream,channel.sink);
    state.game = game;
    return game;
  }

  void cancelGame(){}

  Future<Game> joinGame(String code) async {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse("ws://${Resources.ipPort}/game/join?code=$code&token=${Resources.user!.token}")
    );
    await channel.ready;
    GameState state = GameState(GameStatus.waiting,List.empty(growable: true),List.empty(growable: true),
        List.empty(growable: true));
    Game game = Game("",state,
        channel.stream,channel.sink);
    state.game = game;
    return game;
  }
}