import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tambola/models/game.dart';

import '../../common/resources.dart';

class CalloutComponent extends StatelessWidget {
  final Game game;
  const CalloutComponent({super.key,required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text((game.state.called==0)?"B e g i n":(game.state.called.toString()),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).dividerColor,
              fontSize: 40.sp,
              fontWeight: FontWeight.w600
          ),),
        SizedBox(height: 20.h,),
        //Grey box
        Container(decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
        ),
          padding: EdgeInsets.all(10.w),
          height: 60.h,
          width: MediaQuery.of(context).size.width/2,
          child: Center(child: Text(Resources.callouts[game.state.called],
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),textAlign: TextAlign.center,),),),
      ],
    );
  }
}
