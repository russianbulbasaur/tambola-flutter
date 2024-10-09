import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/blocs/auth_blocs/auth_bloc.dart';
import 'package:tambola/common/app_button.dart';
import 'package:tambola/repositories/auth_repository/auth_repository.dart';

import '../models/user.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final List<TextEditingController> otpControllers = List.generate(6,(index) => TextEditingController());
  final  TextEditingController phoneController = TextEditingController();
  final List<FocusNode> otpFieldFocusNodes = List.generate(6, (index) => FocusNode());
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent,
      body: PopScope(canPop: false,
        child: Center(child: loginView()),
      ),
    );
  }

  Widget loginView(){
    return Container(
      padding: EdgeInsets.only(left: 20.w,right: 20.w),
      margin: EdgeInsets.only(left: 30.w,right:30.w),
      decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(10.r)
      ),
      child: RepositoryProvider(
          create: (context) => AuthRepository(),
          child: BlocProvider(create: (context) => AuthBloc(DefaultState(),
              RepositoryProvider.of<AuthRepository>(context)),
              child: BlocConsumer<AuthBloc,AuthState>(builder: (context,state){
                if(state is DefaultState || state is OTPSentState) return phoneAndOtpView(state,context);
                if(state is LoggedInState) return enterNameView(state,context);
                return Container(height: 0,width: 0,);
              }, listener: (context,state) {
                if(state is OTPSentState) otpFieldFocusNodes[0].requestFocus();
                if(state is LoggedInState && state.user.id!=0) Navigator.pop(context,state.user);
                if(state is SignedUpState) Navigator.pop(context,state.user);
              },)))
    );
  }


  Widget phoneAndOtpView(AuthState state,BuildContext subContext){
    if(state is OTPSentState) phoneController.text = state.phone;
    return Padding(padding: EdgeInsets.only(top: 50.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Login to Tambola",style: Theme.of(context).textTheme.bodySmall!.
          copyWith(fontWeight: FontWeight.w600,fontSize: 14.sp),
        textAlign: TextAlign.center,),
        SizedBox(height: 30.h,),
        TextField(controller: phoneController,
        keyboardType: TextInputType.phone, textAlign: TextAlign.center,
        enabled: (state is DefaultState),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: Colors.black,width: 1.w)
          ),
          hintText: "Phone"
        ),),
        SizedBox(height: 20.h,),
        Visibility(visible: state is OTPSentState,
            child: otpView("We have sent an otp to ${(state is OTPSentState)?state.phone:""}")),
        SizedBox(height: 20.h,),
        AppButton(size: Size(118.w, 33.h),
            backgroundColor: const Color(0xff2C382E),
            child: Text((state is DefaultState)?"Login":"Verify OTP"),
            onPressed: () => (state is DefaultState)?sendOtp(phoneController.text,subContext):
            verifyOtp(state as OTPSentState,subContext)),
          SizedBox(height:30.h),
      ],),
    );
  }

  Widget otpView(String titleText){
    return Column(
      children: [
        Text(titleText,style: Theme.of(context).textTheme.bodySmall!.
        copyWith(fontWeight: FontWeight.w600,fontSize: 14.sp),
          textAlign: TextAlign.center,),
        SizedBox(height: 20.h,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [0,1,2,3,4,5].map((index) =>
        otpField(index)).toList(),),
      ],
    );
  }

  Widget otpField(int index){
    return SizedBox(width:50.h,
        child: TextField(controller: otpControllers[index],
        maxLength: 1,
        onChanged: (text) => onOtpFieldChanged(index,text),
        focusNode: otpFieldFocusNodes[index],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.black,width: 1.w))
        ),));
  }

  Widget enterNameView(LoggedInState state,BuildContext subContext){
    if(state.user.id!=0) return Container();
    TextEditingController nameController = TextEditingController();
    return Padding(padding: EdgeInsets.only(top: 50.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Just need your name",style: Theme.of(context).textTheme.bodySmall!.
          copyWith(fontWeight: FontWeight.w600,fontSize: 14.sp),
            textAlign: TextAlign.center,),
          SizedBox(height: 30.h,),
          TextField(controller: nameController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: Colors.black,width: 1.w)
                ),
                hintText: "Name"
            ),),
          SizedBox(height: 20.h,),
          AppButton(size: Size(118.w, 33.h),
              backgroundColor: const Color(0xff2C382E),
              child: const Text("Let's Go"),
              onPressed: () => signup(state,nameController.text,subContext)),
          SizedBox(height:30.h),
        ],),
    );
  }

  void verifyOtp(OTPSentState state,BuildContext subContext){
    String otp = otpControllers.map((controller) => controller.text.trim()).toList().join();
    BlocProvider.of<AuthBloc>(subContext).add(LoginEvent(state.phone, otp, state.firebaseToken));
  }

  void sendOtp(String phone,BuildContext subContext){
    if(phone.trim().isEmpty) return;
    BlocProvider.of<AuthBloc>(subContext).add(SendOTPEvent("+91$phone"));
  }

  void signup(LoggedInState state,String name,BuildContext subContext){
    if(name.trim().isEmpty) return;
    BlocProvider.of<AuthBloc>(subContext).add(SignupEvent(state.user.phone, name, state.user.token));
  }

  void onOtpFieldChanged(int index,String text){
    if(text.trim().isEmpty && index>0){
      otpFieldFocusNodes[index-1].requestFocus();
    }else if(index<5){
      otpFieldFocusNodes[index+1].requestFocus();
    }
  }
}
