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
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent,
      body: PopScope(canPop: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Stack(children: [
            Positioned.fill(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset("assets/images/login_dialog_background.svg",
                  )),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 200.w,
                    child: RepositoryProvider(
                        create: (context) => AuthRepository(),
                        child: BlocProvider(create: (context) => AuthBloc(DefaultState(),
                            RepositoryProvider.of<AuthRepository>(context)),
                            child: BlocConsumer<AuthBloc,AuthState>(builder: (context,state){
                              if(state is DefaultState || state is OTPSentState) return phoneAndOtpView(state,context);
                              if(state is LoggedInState) return enterNameView(state,context);
                              return Container();
                            }, listener: (context,state) {
                              if(state is LoggedInState && state.user.id!=0) Navigator.pop(context,state.user);
                              if(state is SignedUpState) Navigator.pop(context,state.user);
                            },
                            listenWhen: (prev,curr) => (curr is LoggedInState || curr is SignedUpState),))),
                  )),
            )
          ],),
        ),
      ),
    );
  }

  Widget phoneAndOtpView(AuthState state,BuildContext subContext){
    if(state is OTPSentState) phoneController.text = state.phone;
    return Padding(padding: EdgeInsets.only(top: 50.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Login to Tambola"),
        SizedBox(height: 20.h,),
        TextField(controller: phoneController,
        keyboardType: TextInputType.phone,
        enabled: (state is DefaultState),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: Colors.black)
          ),
          hintText: "Phone"
        ),),
        SizedBox(height: 20.h,),
        Visibility(visible: state is OTPSentState,
            child: otpView()),
        SizedBox(height: 20.h,),
        AppButton(size: Size(300.w, 20.h),
            backgroundColor: const Color(0xff2C382E),
            child: Text((state is DefaultState)?"Login":"Verify OTP"),
            onPressed: () => (state is DefaultState)?sendOtp(phoneController.text,subContext):
            verifyOtp(state as OTPSentState,subContext))
      ],),
    );
  }

  Widget otpView(){
    return Row(children: otpControllers.map((controller) =>
    otpField(controller)).toList(),);
  }

  Widget otpField(TextEditingController controller){
    return SizedBox(height:30.h,width:30.h,
        child: TextField(controller: controller,));
  }

  Widget enterNameView(LoggedInState state,BuildContext subContext){
    if(state.user.id!=0) return Container();
    TextEditingController phoneController = TextEditingController();
    return Padding(padding: EdgeInsets.only(top: 50.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Just need your name"),
          SizedBox(height: 20.h,),
          TextField(controller: phoneController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: const BorderSide(color: Colors.black)
                ),
                hintText: "Name"
            ),),
          SizedBox(height: 20.h,),
          AppButton(size: Size(300.w, 20.h),
              backgroundColor: const Color(0xff2C382E),
              child: Text("Let's Go"),
              onPressed: () => signup(state,phoneController.text,subContext))
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
}
