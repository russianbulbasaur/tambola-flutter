import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/core_game_blocs/monitor.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/screens/components/ticket_component.dart';
import '../../bottom_sheets/waiting_for_players_player_sheet.dart';
import '../../common/resources.dart';

class PlayersTicketScreen extends StatefulWidget {
  final Game game;
  const PlayersTicketScreen({super.key,required this.game});

  @override
  State<PlayersTicketScreen> createState() => _PlayersTicketScreenState();
}

class _PlayersTicketScreenState extends State<PlayersTicketScreen> {
  late Monitor _monitor;
  late Game _game;
  @override
  void initState() {
    _game = widget.game;
    _monitor = Monitor(WaitingState(), _game);
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersPlayerSheet(monitor: _monitor,);
    },isDismissible: false,enableDrag: false);
    monitorGame();
  }

  void monitorGame() async{
    _game.setListener((data){
      _monitor.parse(data);
    });
    _game.listen();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: body(),
    ),);
  }

  Widget body(){
    return BlocConsumer<Monitor,GameBlocState>(bloc: _monitor,
      listener: (context,state){},
      builder: (context,state){
      return Column(children: [
          callouts(),
          SizedBox(height: 10.h,),
          Divider(thickness: 4.h,color: Colors.black,),
          SizedBox(height: 10.h,),
          ticketsArea(),
          SizedBox(height: 10.h,),
          Divider(thickness: 4.h,color: Colors.black,),
          SizedBox(height: 10.h,),
        ],);
      },buildWhen: (prev,curr) => curr is NumberCalledState,
    );
  }


  Widget ticketsArea(){
    return Expanded(child:
    ListView.builder(itemBuilder: (context,index){
      return const TicketComponent();
    },itemCount: 1,));
  }


  Widget callouts(){
    return Column(
      children: [
        Text((_game.state.called==0)?"B e g i n":(_game.state.called.toString()),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).dividerColor,
            fontSize: 30.sp,
          ),),
        SizedBox(height: 20.h,),
        //Grey box
        Container(decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
        ),
          height: 80.h,
          width: MediaQuery.of(context).size.width/2,
          child: Center(child: Text(Resources.callouts[_game.state.called],
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 25.sp,
                color: Colors.white
            ),textAlign: TextAlign.center,),),),
      ],
    );
  }

}


