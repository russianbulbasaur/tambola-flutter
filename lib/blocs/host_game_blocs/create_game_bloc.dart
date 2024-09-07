import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/blocs/bloc_response.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/repositories/game_respository/game_repository.dart';

class CreateGameBlocResponse extends BlocResponse{
  Game? game;
  CreateGameBlocResponse();
}

class CreateGameBloc extends Cubit<CreateGameBlocResponse?>{
  final GameRepository gameRepository;
  CreateGameBloc(super.initialState,this.gameRepository);

  void createGame() async{
    CreateGameBlocResponse response = CreateGameBlocResponse();
    try{
      Game game = await gameRepository.createGame();
      response.game = game;
    } catch(e){
      if(kDebugMode) print(e.toString());
    }finally{
      emit(response);
    }
  }
}