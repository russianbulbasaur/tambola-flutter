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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: Theme.of(context).dividerColor),
      color: Theme.of(context).secondaryHeaderColor.withOpacity(0.3)),
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
            header(),
            SizedBox(height: 10.h,),
            Divider(thickness: 2.h,color: Colors.black,),
            SizedBox(height: 20.h,),
            ticketNumbers(context),
            SizedBox(height: 30.h,),
          ],);
      })
    );
  }
  
  Widget header(){
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Text("Ticket ${ticket.id}",
      textAlign: TextAlign.start,),
    );
  }
  
  Widget ticketNumbers(BuildContext subContext){
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ticket.tiles.map((rowTile){
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowTile.map((tile){
          if(tile.hasNumber) {
            return numberTile(tile,subContext);
          } else {
            return noNumberTile();
          }
      }).toList(),);
    }).toList(),);
  }


  Widget noNumberTile(){
    return Container(height: 50.w,width: 50.w,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
      padding: const EdgeInsets.all(4)
    );
  }

  Widget numberTile(TicketNumberTile tile,BuildContext subContext){
    return GestureDetector(onTap: (){
      if(tile.isTicked) {
        BlocProvider.of<TicketBloc>(subContext).add(UnTickNumberEvent(tile));
      } else {
        BlocProvider.of<TicketBloc>(subContext).add(TickNumberEvent(tile));
      }
    },
      child: Container(height: 50.w,width: 50.w,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
        padding: const EdgeInsets.all(4),
        child: Text(tile.number.toString(),style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 30.sp,
          decoration: (tile.isTicked)?TextDecoration.lineThrough:null,
        ),textAlign: TextAlign.center),
      ),
    );
  }
}

