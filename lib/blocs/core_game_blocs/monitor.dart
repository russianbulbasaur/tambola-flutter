import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/message.dart';
import 'dart:developer' as dev;

import 'package:tambola/models/user.dart';

import '../../models/game.dart';

class Monitor extends Bloc<GameEvent,GameBlocState>{
  final Game game;
  Monitor(super.initialState,this.game){
    on<NumberCalledEvent>(onNumberCalled);
    on<UserJoinedEvent>(onUserJoined);
    on<GameStatusChangedEvent>(gameStateChanged);
  }


  void onNumberCalled(NumberCalledEvent event,emit) => emit(NumberCalledState(event.number));

  void onUserJoined(UserJoinedEvent event,emit) => emit(UserJoinedState());

  void gameStateChanged(GameStatusChangedEvent event,emit) => emit(GameStatusChangedState());

  void parse(dynamic data){
    if(kDebugMode) dev.log(data);
    try {
      Message message = Message.fromJson(data);
      switch (message.event) {
        case Events.players_already_in_lobby:
          game.state.initState(message
              .decodePlayersInLobbyPayload()); //decodes list of players and gameid
          break;
        case Events.player_joined:
          game.state.addPlayer(message.decodePlayerPayload());
          add(UserJoinedEvent());
          break;
        case Events.player_left:
          break;
        case Events.alert:
          break;
        case Events.number_called:
          int number = message.decodeNumberPayload();
          game.state.addNumber(number);
          add(NumberCalledEvent(number));
          break;
        case Events.game_status:
          game.state.updateStatus(message.decodeStatusPayload());
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

class NumberCalledEvent extends GameEvent{
  final int number;
  NumberCalledEvent(this.number);
}

class UserJoinedEvent extends GameEvent{}

abstract class GameBlocState{}

class NumberCalledState extends GameBlocState{
  final int number;
  NumberCalledState(this.number);
}

class UserJoinedState extends GameBlocState{}

class GameStatusChangedState extends GameBlocState{}

class WaitingState extends GameBlocState{}