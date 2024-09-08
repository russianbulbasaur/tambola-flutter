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
  late Game _game;

  @override
  void initState() {
    _game = widget.game;
    _monitor = Monitor(WaitingState(), _game.state);
    bag = HashSet();
    bag.addAll(List.generate(90, (index) => index+1));
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersHostSheet(game:_game,monitor: _monitor,);
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
    return Scaffold(body:
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: body(),
        ),
      ),);
  }

  Widget body(){
    return BlocProvider(create: (context) => CallNumberBloc(0),
        child: BlocBuilder<CallNumberBloc,int>(builder: (context,state){
          return Column(children: [
            callouts(),
            SizedBox(height: 10.h,),
            Divider(thickness: 4.h,color: Colors.black,),
            SizedBox(height: 10.h,),
            board(),
            SizedBox(height: 10.h,),
            Divider(thickness: 4.h,color: Colors.black,),
            SizedBox(height: 10.h,),
            callButton(context),
            SizedBox(height: 10.h,),
            endButton(context),
          ],);
        })
    );
  }

  Widget board(){
    int checkpoint = 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [1,2,3,4,5,6,7,8,9].map((e){
        checkpoint += 10;
        return makeRow(checkpoint-10);
      }).toList(),);
  }


  Widget makeRow(int checkpoint){
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [1,2,3,4,5,6,7,8,9,10].map((e) => numberTile(e+checkpoint)).toList(),);
  }

  Widget numberTile(int number){
    return Container(height: 70.w,width: 70.w,
      padding: const EdgeInsets.all(4),
      child: CircleAvatar(backgroundColor:
      (bag.contains(number)?Colors.white:Theme.of(context).dividerColor),child:
      Text(number.toString(),style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 30.sp,
          color: (bag.contains(number)?Colors.black:Colors.white)
      ),),),
    );
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

  Widget callButton(BuildContext subContext){
    return AppButton(size: Size(200.w,30.h),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        child: const Text("Call Next"),
        onPressed: () => callNumber(subContext));
  }

  Widget endButton(BuildContext subContext){
    return AppButton(size: Size(200.w,30.h),
        backgroundColor: const Color(0xffB52D2E),
        child: const Text("End Game"),
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
