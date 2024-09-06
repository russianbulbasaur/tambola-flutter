import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'game_state.dart';

class Game{
  int id;
  final GameState state;
  final Stream socketStream;
  final WebSocketSink socketSink;
  Game(this.id,this.state,this.socketStream,this.socketSink);
}