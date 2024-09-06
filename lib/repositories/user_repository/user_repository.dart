import 'dart:math';

import 'package:tambola/models/user.dart';

class UserRepository{

  User createUser(){
    return User(Random().nextInt(1000000),"");
  }
}