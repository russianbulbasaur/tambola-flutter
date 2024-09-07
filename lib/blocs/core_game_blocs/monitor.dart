import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/message.dart';
import 'dart:developer' as dev;

class Monitor extends Cubit<int>{
  final GameState gameState;
  Monitor(super.initialState,this.gameState);


  void parse(dynamic data){
    if(kDebugMode) dev.log(data);
    try {
      Message message = Message.fromJson(data);
      switch (message.event) {
        case Events.players_already_in_lobby:
          gameState.initState(message
              .decodePlayersInLobbyPayload()); //decodes list of players and gameid
          break;
        case Events.user_joined:
          gameState.addPlayer(message.decodePlayerPayload());
          break;
        case Events.user_left:
          break;
        case Events.alert:
          break;
        case Events.number_called:
          gameState.addNumber(message.decodeNumberPayload());
          break;
        case Events.game_status:
          gameState.updateStatus(message.decodeStatusPayload());
          break;
      }
    }catch(e){
      if(kDebugMode) dev.log(e.toString());
    }
    emit(Random().nextInt(1000000));
  }
}