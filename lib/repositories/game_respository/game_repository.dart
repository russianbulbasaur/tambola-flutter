import 'dart:async';
import 'package:tambola/models/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameRepository{


  Future<Game> createGame() async{
    return Game();
  }

  void cancelGame(){}

  Game joinGame(){
    return Game();
  }

  void monitorGame(StreamController test) async{
    WebSocketChannel channel = WebSocketChannel.connect(Uri.parse("wss://echo.websocket.org"));
    await channel.ready;
    channel.stream.listen((data){
      test.add(data);
    });
  }
}