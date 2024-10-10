import 'dart:developer';
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


  factory JoinGameBloc.autoJoin(JoinGameBlocResponse? state,GameRepository repo,String code){
    JoinGameBloc object = JoinGameBloc(state, repo);
    object.joinGame(code);
    return object;
  }

  void joinGame(String code) async{
    JoinGameBlocResponse response = JoinGameBlocResponse();
    try{
      Game game = await gameRepository.joinGame(code);
      response.game = game;
    } on WebSocketException catch(e) {
      if(kDebugMode) print(e.message);
      response.exception = e as Exception?;
    }catch(e) {
      if(kDebugMode) log(e.toString());
    }finally{
      emit(response);
    }
  }
}