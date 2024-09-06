import 'dart:async';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameRepository{


  Future<Game> createGame() async{
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
        "ws://${Resources.ipPort}/game/create?user_id=${const Uuid()}&name=Ankit"));
    await channel.ready;
    Game game = Game();
    game.socketStream = channel.stream;
    return game;
  }

  void cancelGame(){}

  Game joinGame(){
    return Game();
  }
}