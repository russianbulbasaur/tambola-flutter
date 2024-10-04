import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:tambola/common/resources.dart';

import '../../models/user.dart' as userModel;

class AuthRepository{

  //returns firebase token
  Future<String> sendOTP(String phone) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber("+91$phone");
    return confirmationResult.verificationId;
  }

  
  Future<userModel.User?> login(String phone,String otp,String firebaseToken) async{
    Response response = await post(Uri.parse("${Resources.httpIpPort}/login"),
        headers: {"Content-Type":"application/json"},
        body: {
          "phone":phone,
          "otp":otp,
          "firebase_token":firebaseToken
        });
    if(response.statusCode!=200) throw response.body;
    userModel.User user = userModel.User.fromJson(response.body);
    return user;
  }
  
  Future<userModel.User?> signup(String phone,String name,String signupToken) async{
    Response response = await post(Uri.parse("${Resources.httpIpPort}/login"),
        headers: {"Content-Type":"application/json"},
        body: {
          "phone":phone,
          "name":name,
          "signup_token":signupToken
        });
    if(response.statusCode!=200) throw response.body;
    userModel.User user = userModel.User.fromJson(response.body);
    return user;
  }
  
}