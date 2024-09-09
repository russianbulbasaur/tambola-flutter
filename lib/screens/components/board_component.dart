import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/blocs/core_game_blocs/monitor.dart';
import 'package:tambola/models/board.dart';

class BoardComponent extends StatelessWidget {
  final Board board;
  late BuildContext subContext;
  BoardComponent({super.key,required this.board});

  @override
  Widget build(BuildContext context) {
    subContext = context;
    return boardWidget();
  }

  Widget boardWidget(){
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: board.tiles.map((rowList){
        return Row(mainAxisAlignment: MainAxisAlignment.center,
        children: rowList.map((tile) => numberTile(tile)).toList(),);
      }).toList(),);
  }


  Widget numberTile(BoardNumberTile tile){
    return Container(height: 70.w,width: 70.w,
      padding: const EdgeInsets.all(4),
      child: CircleAvatar(backgroundColor:
      (tile.isCalled?Theme.of(subContext).dividerColor:Colors.white),child:
      Text(tile.number.toString(),style: Theme.of(subContext).textTheme.bodySmall!.copyWith(
          fontSize: 30.sp,
          color: (tile.isCalled?Colors.white:Colors.black)
      ),),),
    );
  }
}


