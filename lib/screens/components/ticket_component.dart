import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/player_game_blocs/ticket_bloc.dart';
import 'package:tambola/models/ticket.dart';

class TicketComponent extends StatefulWidget {
  const TicketComponent({super.key});

  @override
  State<TicketComponent> createState() => _TicketComponentState();
}

class _TicketComponentState extends State<TicketComponent> {

  late Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return body();
  }
  
  Widget body(){
    return Container(
      margin: EdgeInsets.only(left: 20.w,right: 20.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r),
      boxShadow: const [BoxShadow(color: Colors.black)],
      color: const Color(0xffF9F9F9)),
        child: ticketBody());
  }
  
  Widget ticketBody(){
    return BlocProvider(create: (context) => TicketBloc(InitialState()),
      child:BlocBuilder<TicketBloc,TicketState>(builder: (context,state){
        switch(state.runtimeType){
          case InitialState:
            return Container();
          case TicketReadyState:
            ticket = (state as TicketReadyState).ticket;
            break;
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ticketNumbers(context),
            SizedBox(height: 5.h,),
            footer(),
          ],);
      })
    );
  }
  
  Widget footer(){
    return Container(
      padding: EdgeInsets.only(top:10.h,left: 10.w),
      child: Text("Ticket ${ticket.id}",
      textAlign: TextAlign.start,),
    );
  }
  
  Widget ticketNumbers(BuildContext subContext){
    return GridView.builder(gridDelegate: const
    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9,
    childAspectRatio: 1),
        itemBuilder: (context,index){
           int col = index%9;
           int row = index~/9;
           return numberTile(ticket.tiles[col][row], subContext);
        },itemCount: 27,
    shrinkWrap: true,);
  }

  Widget numberTile(TicketNumberTile tile,BuildContext subContext){
    String number = "";
    if(tile.hasNumber) number = (tile.number<10)?" ${tile.number}":tile.number.toString();
    return InkWell(onTap: (){
      if(!tile.hasNumber) return;
      if(tile.isTicked) {
        BlocProvider.of<TicketBloc>(subContext).add(UnTickNumberEvent(tile));
        return;
      }
      BlocProvider.of<TicketBloc>(subContext).add(TickNumberEvent(tile));
    },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(color:
        (tile.isTicked)?const Color(0xff000000).withOpacity(0.2):
        const Color(0xffF8F7D2)),
        padding: const EdgeInsets.all(4),
        child: FittedBox(fit: BoxFit.cover,
          child: Text(number,style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w400,
            decoration: (tile.isTicked)?TextDecoration.lineThrough:null,
          ),textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

