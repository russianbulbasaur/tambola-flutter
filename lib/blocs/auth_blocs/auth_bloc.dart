import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:tambola/repositories/auth_repository/auth_repository.dart';

import '../../models/user.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final AuthRepository _repo;
  AuthBloc(super.initialState,this._repo){
    on<SendOTPEvent>(_sendOTP);
    on<LoginEvent>(_login);
    on<SignupEvent>(_signup);
  }

  void _sendOTP(SendOTPEvent event,emit) async{
    try{
      String firebaseToken = await _repo.sendOTP(event.phone);
      if(kDebugMode) print("Firebase token : $firebaseToken");
      emit(OTPSentState(firebaseToken));
    }on firebase.FirebaseException catch(e){
      if(kDebugMode) log("Firebase error${e.message}");
    }
    catch(e){
      if(kDebugMode) log(e.toString());
    }
  }

  void _login(LoginEvent event,emit) async{
    try{
      User? user = await _repo.login(event.phone, event.otp, event.firebaseToken);
      if(user==null) return;
      if(kDebugMode) print("User After login : ${user.toMap().toString()}");
      emit(LoggedInState(user));
    }on ClientException catch(e){
      if(kDebugMode) log(e.message);
    }
    catch(e){
      if(kDebugMode) log(e.toString());
    }
  }

  void _signup(SignupEvent event,emit) async{
    try{
      User? user = await _repo.signup(event.phone, event.name, event.signupToken);
      if(user==null) return;
      if(kDebugMode) print("User After Signup : ${user.toMap().toString()}");
      emit(SignedUpState(user));
    }catch(e){
      if(kDebugMode) log(e.toString());
    }
  }

}

//events
abstract class AuthEvent{}
class SendOTPEvent extends AuthEvent{
  final String phone;
  SendOTPEvent(this.phone);
}

class LoginEvent extends AuthEvent{
  final String phone;
  final String otp;
  final String firebaseToken;
  LoginEvent(this.phone,this.otp,this.firebaseToken);
}

class SignupEvent extends AuthEvent{
  final String phone;
  final String name;
  final String signupToken;
  SignupEvent(this.phone,this.name,this.signupToken);
}

abstract class AuthState{}
class OTPSentState extends AuthState{
  final String firebaseToken;
  OTPSentState(this.firebaseToken);
}

class LoggedInState extends AuthState{
  final User user;
  LoggedInState(this.user);
}

class SignedUpState extends AuthState{
  final User user;
  SignedUpState(this.user);
}

class DefaultState extends AuthState{}