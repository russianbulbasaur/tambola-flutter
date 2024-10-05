import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'game_state.dart';

class Game{
  String id;
  final GameState state;
  final Stream socketStream;
  final WebSocketSink socketSink;
  Function(dynamic)? listener;
  Game(this.id,this.state,this.socketStream,this.socketSink);


  void listen(){
    socketStream.listen((data){
      if(listener==null) return;
      listener!(data);
    });
  }

  void setListener(Function(dynamic) function){
    listener = function;
  }
}