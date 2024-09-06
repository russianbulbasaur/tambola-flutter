import 'dart:convert';

class User{
  int id;
  String name;
  UserType? type;
  User(this.id,this.name);

  factory User.fromJson(String json){
    Map<String,dynamic> decodedMap = jsonDecode(json);
    return User(decodedMap["id"],decodedMap["name"]);
  }

  factory User.fromMap(Map<String,dynamic> decodedMap){
    return User(decodedMap["id"],decodedMap["name"]);
  }

  Map toMap(){
    return {"id":id,"name":name};
  }
}


enum UserType {
  host,player
}