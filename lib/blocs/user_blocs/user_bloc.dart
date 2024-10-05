import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class UserBloc extends Cubit<User?>{
  UserBloc(super.initialState);

  void reloadUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("user")) emit(User.fromJson(prefs.getString("user")!));
    else emit(null);
  }
}