import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/message.dart';

import '../../models/game.dart';

class CallNumberBloc extends Cubit<bool>{
  CallNumberBloc(super.initialState,);


  void call(int number,Game game){
    Message message = Message(Random().nextInt(1000000),
        Events.number_called, Resources.user!
        , jsonEncode({
          "number" : number
        }));
    game.socketSink.add(message.toJson());
    emit(true);
  }
}