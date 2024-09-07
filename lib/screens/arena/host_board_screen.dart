import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/host_game_blocs/call_number_bloc.dart';
import 'package:tambola/bottom_sheets/waiting_for_players_host_sheet.dart';
import 'package:tambola/bottom_sheets/waiting_for_players_player_sheet.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/models/user.dart';

import '../../blocs/core_game_blocs/monitor.dart';

class HostBoardScreen extends StatefulWidget {
  final Game game;
  const HostBoardScreen({super.key,required this.game});

  @override
  State<HostBoardScreen> createState() => _HostBoardScreenState();
}

class _HostBoardScreenState extends State<HostBoardScreen> {
  late Monitor _monitor;
  late HashSet<int> bag;


  @override
  void initState() {
    _monitor = Monitor(0, widget.game.state);
    bag = HashSet();
    bag.addAll(List.generate(90, (index) => index+1));
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersHostSheet(game: widget.game);
    });
    monitorGame();
  }

  void monitorGame() async{
    widget.game.setListener((data){
      _monitor.parse(data);
    });
    widget.game.listen();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CallNumberBloc(0),
      child: BlocBuilder<CallNumberBloc,int>(builder: (context,state){
        return Column(children: [
          board(),
          SizedBox(height: 20.h,),
          Text("Called number : $state",style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 30.sp,
          ),),
          SizedBox(height: 30.h,),
          callButton(context)
        ],);
      })
    );
  }

  Widget board(){
    return Expanded(child:
    SizedBox(child:
      GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6,
      childAspectRatio: 2),
          itemBuilder: (context,index){
            return numberTile(index+1);
          },itemCount: 90,),));
  }

  Widget numberTile(int number){
    return CircleAvatar(backgroundColor: (bag.contains(number)?Colors.white:Colors.black),child: Text(number.toString(),style: Theme.of(context).textTheme.bodySmall!.copyWith(
      fontSize: 30.sp,
      color: (bag.contains(number)?Colors.black:Colors.grey)
    ),),);
  }

  Widget callButton(BuildContext subContext){
    return AppButton(size: Size(300,50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        child: Text("Call next"),
        onPressed: () => callNumber(subContext));
  }

  void callNumber(BuildContext subContext){
    if(bag.isEmpty) return;
    List<int> set = bag.toList();
    int index = Random().nextInt(set.length);
    int number = set[index];
    bag.remove(number);
    subContext.read<CallNumberBloc>().call(number, widget.game);
  }

}
