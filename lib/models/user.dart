import 'dart:convert';

class User{
  late int id;
  late String name;
  late bool isHost;
  late String phone;
  late String token;

  User(){}


  factory User.fromJson(String json){
    Map<String,dynamic> decodedMap = jsonDecode(json);
    User user = User();
    if(decodedMap.containsKey("id")) user.id = decodedMap["id"];
    if(decodedMap.containsKey("name")) user.name = decodedMap["name"];
    if(decodedMap.containsKey("isHost")) user.isHost = decodedMap["isHost"];
    if(decodedMap.containsKey("phone")) user.phone = decodedMap["phone"];
    if(decodedMap.containsKey("token")) user.token = decodedMap["token"];
    return user;
  }

  factory User.fromMap(Map<String,dynamic> decodedMap){
    User user = User();
    if(decodedMap.containsKey("id")) user.id = decodedMap["id"];
    if(decodedMap.containsKey("name")) user.name = decodedMap["name"];
    if(decodedMap.containsKey("isHost")) user.isHost = decodedMap["isHost"];
    if(decodedMap.containsKey("phone")) user.phone = decodedMap["phone"];
    if(decodedMap.containsKey("token")) user.token = decodedMap["token"];
    return user;
  }

  Map toMap(){
    return {"id":id,"name":name,"phone":phone,"token":token};
  }
}
