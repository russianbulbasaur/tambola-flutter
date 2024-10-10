import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/models/board.dart';

class BoardComponent extends StatelessWidget {
  final Board board;
  late BuildContext subContext;
  BoardComponent({super.key,required this.board});

  @override
  Widget build(BuildContext context) {
    subContext = context;
    return Container(
    padding: EdgeInsets.only(left: 10.w,right: 10.w)
    ,child: boardWidget());
  }

  Widget boardWidget(){
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: board.tiles.map((rowList){
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowList.map((tile){
            return numberTile(tile);
          }).toList(),);
      }).toList(),);
  }


  Widget numberTile(BoardNumberTile tile){
    return Flexible(flex: 1,
      fit: FlexFit.tight,
      child: Container(
        margin: EdgeInsets.only(top: 10.h,right: 5.w,left: 5.w,bottom: 10.h),
      decoration: BoxDecoration(shape: BoxShape.circle,
      color:  (tile.isCalled?Theme.of(subContext).dividerColor:Colors.white)),
      child:
      Text(tile.number.toString(),style: Theme.of(subContext).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: (tile.isCalled?Colors.white:Colors.black),
      ),textAlign: TextAlign.center,),),
    );
  }
}


