import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/message.dart';

import '../bloc_response.dart';

class Monitor extends Cubit<int>{
  final GameState gameState;
  Monitor(super.initialState,this.gameState);


  void parse(dynamic data){
    print(data);
    Message message = Message.fromJson(data);
    switch(message.event){
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
      case Events.game_id:
        gameState.game!.id = message.decodeGameIdPayload();
        break;
    }
    emit(Random().nextInt(1000000));
  }
}