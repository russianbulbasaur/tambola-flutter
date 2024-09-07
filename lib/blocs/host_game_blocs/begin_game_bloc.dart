import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/message.dart';

class BeginGameBloc extends Cubit<bool>{
  BeginGameBloc(super.initialState);

  void start(Game game){
    Message message = Message(Random().nextInt(100000),
        Events.game_status, Resources.user!,
          {"status":GameStatus.playing.name}
        );
    game.socketSink.add(message.toJson());
  }
}