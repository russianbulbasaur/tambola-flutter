import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/host_game_blocs/board_bloc.dart';
import 'package:tambola/bottom_sheets/waiting_for_players_host_sheet.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/common/resources.dart';
import 'package:tambola/models/game.dart';
import 'package:tambola/screens/components/board_component.dart';

import '../../blocs/core_game_blocs/monitor.dart';
import '../../models/board.dart';

class HostBoardScreen extends StatefulWidget {
  final Game game;
  const HostBoardScreen({super.key,required this.game});

  @override
  State<HostBoardScreen> createState() => _HostBoardScreenState();
}

class _HostBoardScreenState extends State<HostBoardScreen> {
  late Monitor _monitor;
  late Game _game;
  late Board board;

  @override
  void initState() {
    _game = widget.game;
    _monitor = Monitor(WaitingState(), _game);
    Future.delayed(const Duration(seconds: 1),waitForPlayers);
    super.initState();
  }

  void waitForPlayers() async{
    showModalBottomSheet(context: context, builder:(context){
      return WaitingForPlayersHostSheet(monitor: _monitor,);
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
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: body(),
        ),
      ),);
  }

  Widget body(){
    return BlocProvider(create: (context) => BoardBloc(InitialState(), _game),
        child: BlocBuilder<BoardBloc,BoardState>(builder: (context,state){
          switch(state.runtimeType){
            case InitialState:
              return Container();
            case BoardReadyState:
              board = (state as BoardReadyState).board;
              break;
          }
          return Column(children: [
            callouts(),
            SizedBox(height: 10.h,),
            Divider(thickness: 4.h,color: Colors.black,),
            SizedBox(height: 10.h,),
            BoardComponent(board: board,),
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
        child: const Text("Call Next",textAlign: TextAlign.center,),
        onPressed: () => callNumber(subContext));
  }

  Widget endButton(BuildContext subContext){
    return AppButton(size: Size(200.w,30.h),
        backgroundColor: const Color(0xffB52D2E),
        child: const Text("End Game",textAlign: TextAlign.center,),
        onPressed: (){});
  }

  void callNumber(BuildContext subContext){
    if(board.availableNumbers.isEmpty) return;
    List<int> set = board.availableNumbers.toList();
    int index = Random().nextInt(set.length);
    int number = set[index];
    board.availableNumbers.remove(number);
    subContext.read<BoardBloc>().add(CallNumberEvent(board.numberToTileMap[number]!));
  }

}
