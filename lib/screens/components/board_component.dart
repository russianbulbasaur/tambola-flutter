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
    padding: EdgeInsets.only(left: 20.w,right: 20.w)
    ,child: boardWidget());
  }

  Widget boardWidget(){
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: board.tiles.map((rowList){
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowList.map((tile) => numberTile(tile)).toList(),);
      }).toList(),);
  }


  Widget numberTile(BoardNumberTile tile){
    return Container(padding: EdgeInsets.all(5.w),
    margin: EdgeInsets.all(5.w),
    decoration: BoxDecoration(shape: BoxShape.circle,
    color:  (tile.isCalled?Theme.of(subContext).dividerColor:Colors.white)),
    child:
    Text(tile.number.toString(),style: Theme.of(subContext).textTheme.bodySmall!.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: (tile.isCalled?Colors.white:Colors.black)
    ),),);
  }
}


