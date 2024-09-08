import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/ticket.dart';

class TicketBloc extends Bloc<TicketEvent,TicketState>{
  TicketBloc(super.initialState){
    on<MakeTicketEvent>(makeTicket);
    on<TickNumberEvent>(tickNumber);
    on<UnTickNumberEvent>(unTickNumber);
    add(MakeTicketEvent());
  }
  
  
  void tickNumber(TickNumberEvent event,emit){
    event.numberTile.isTicked = true;
    emit(TicketNumberTicked(event.numberTile));
  }
  
  void unTickNumber(UnTickNumberEvent event,emit){
    event.numberTile.isTicked = false;
    emit(TicketNumberUnTicked(event.numberTile));
  }
  
  void makeTicket(MakeTicketEvent event,emit){
    Ticket ticket = Ticket(Random().nextInt(10000));
    emit(TicketReadyState(ticket));
  }
}

abstract class TicketState {}

class InitialState extends TicketState {}

class TicketReadyState extends TicketState{
  final Ticket ticket;
  TicketReadyState(this.ticket);
}

class TicketNumberTicked extends TicketState{
  final TicketNumberTile numberTile;
  TicketNumberTicked(this.numberTile);
}

class TicketNumberUnTicked extends TicketState{
  final TicketNumberTile numberTile;
  TicketNumberUnTicked(this.numberTile);
}


abstract class TicketEvent{}

class MakeTicketEvent extends TicketEvent{}

class TickNumberEvent extends TicketEvent{
  final TicketNumberTile numberTile;
  TickNumberEvent(this.numberTile);
}

class UnTickNumberEvent extends TicketEvent{
  final TicketNumberTile numberTile;
  UnTickNumberEvent(this.numberTile);
}