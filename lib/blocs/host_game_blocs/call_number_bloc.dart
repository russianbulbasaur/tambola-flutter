import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/message.dart';

import '../../models/game.dart';

class CallNumberBloc extends Cubit<int>{
  CallNumberBloc(super.initialState,);


  void call(int number,Game game){
    Message message = Message(Random().nextInt(1000000),
        Events.number_called, Resources.user!
        , {
          "number" : number
        });
    game.socketSink.add(message.toJson());
    game.state.addNumber(number);
    emit(number);
  }
}