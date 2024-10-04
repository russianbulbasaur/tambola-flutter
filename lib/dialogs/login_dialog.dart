import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tambola/blocs/auth_blocs/auth_bloc.dart';
import 'package:tambola/repositories/auth_repository/auth_repository.dart';

import '../models/user.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: RepositoryProvider(
        create: (context) => AuthRepository(),
          child: BlocProvider(create: (context) => AuthBloc(DefaultState(),
              RepositoryProvider.of<AuthRepository>(context)),
          child: BlocConsumer<AuthBloc,AuthState>(builder: (context,state){
            return TextButton(onPressed: (){
              BlocProvider.of<AuthBloc>(context).add(SendOTPEvent("+917018118095"));
            }, child: Text("Pressed me baby"));
          }, listener: (context,state){
            switch(state.runtimeType){
              case OTPSentState:
                String firebaseToken = (state as OTPSentState).firebaseToken;
                BlocProvider.of<AuthBloc>(context).add(LoginEvent("+917018118095", "111111", firebaseToken));
                break;
              case LoggedInState:
                User user = (state as LoggedInState).user;
                if(user.id==0) {
                  BlocProvider.of<AuthBloc>(context).add(SignupEvent("+917018118095", "ankit", user.token));
                  return;
                }
                Navigator.pop(context);
                break;
              case SignedUpState:
                break;
            }
          }))),
    );
  }
}
