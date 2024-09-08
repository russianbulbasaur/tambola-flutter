import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/resources.dart';
import '../../models/board.dart';
import '../../models/game.dart';
import '../../models/message.dart';

class BoardBloc extends Bloc<BoardEvent,BoardState>{
  final Game game;
  BoardBloc(super.initialState,this.game){
    on<MakeBoardEvent>(makeBoard);
    on<CallNumberEvent>(callNumber);
    add(MakeBoardEvent());
  }


  void callNumber(CallNumberEvent event,emit){
    Message message = Message(Random().nextInt(1000000),
        Events.number_called, Resources.user!
        , {
          "number" : event.numberTile.number
        });
    game.socketSink.add(message.toJson());
    game.state.addNumber(event.numberTile.number);
    event.numberTile.isCalled = true;
    emit(BoardNumberCalled(event.numberTile));
  }

  void makeBoard(MakeBoardEvent event,emit){
    Board board = Board(Random().nextInt(10000));
    emit(BoardReadyState(board));
  }
}

abstract class BoardState {}

class InitialState extends BoardState {}

class BoardReadyState extends BoardState{
  final Board board;
  BoardReadyState(this.board);
}

class BoardNumberCalled extends BoardState{
  final BoardNumberTile numberTile;
  BoardNumberCalled(this.numberTile);
}


abstract class BoardEvent{}

class MakeBoardEvent extends BoardEvent{}

class CallNumberEvent extends BoardEvent{
  final BoardNumberTile numberTile;
  CallNumberEvent(this.numberTile);
}