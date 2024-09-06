import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/blocs/bloc_response.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/repositories/game_respository/game_repository.dart';

class JoinGameBlocResponse extends BlocResponse{
  Game? game;
  JoinGameBlocResponse();
}

class JoinGameBloc extends Cubit<JoinGameBlocResponse?>{
  final GameRepository gameRepository;
  JoinGameBloc(super.initialState,this.gameRepository);

  void joinGame(String code) async{
    JoinGameBlocResponse response = JoinGameBlocResponse();
    try{
      Game game = await gameRepository.joinGame(code);
      response.game = game;
    } on WebSocketException catch(e) {
      if(kDebugMode) print(e.message);
      response.exception = e as Exception?;
    }finally{
      emit(response);
    }
  }
}