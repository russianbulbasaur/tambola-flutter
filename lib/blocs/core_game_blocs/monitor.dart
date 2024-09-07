import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/message.dart';
import 'dart:developer' as dev;

import 'package:tambola/models/user.dart';

class Monitor extends Bloc<GameEvent,GameBlocState>{
  final GameState gameState;
  Monitor(super.initialState,this.gameState){
    on<NumberCalledEvent>(onNumberCalled);
    on<UserJoinedEvent>(onUserJoined);
    on<GameStatusChangedEvent>(gameStateChanged);
  }


  void onNumberCalled(NumberCalledEvent event,emit) => emit(NumberCalledState());

  void onUserJoined(UserJoinedEvent event,emit) => emit(UserJoinedState());

  void gameStateChanged(GameStatusChangedEvent event,emit) => emit(GameStatusChangedState());

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
          add(UserJoinedEvent());
          break;
        case Events.user_left:
          break;
        case Events.alert:
          break;
        case Events.number_called:
          gameState.addNumber(message.decodeNumberPayload());
          add(NumberCalledEvent());
          break;
        case Events.game_status:
          gameState.updateStatus(message.decodeStatusPayload());
          add(GameStatusChangedEvent());
          break;
      }
    }catch(e){
      if(kDebugMode) dev.log(e.toString());
    }
  }
}

abstract class GameEvent{}

class GameStatusChangedEvent extends GameEvent{}

class NumberCalledEvent extends GameEvent{}

class UserJoinedEvent extends GameEvent{}

abstract class GameBlocState{}

class NumberCalledState extends GameBlocState{}

class UserJoinedState extends GameBlocState{}

class GameStatusChangedState extends GameBlocState{}

class WaitingState extends GameBlocState{}