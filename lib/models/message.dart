import 'dart:convert';

import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

class Message{
  final int id;
  final Events event;
  final User sender;
  final String payload;
  Message(this.id,this.event,this.sender,this.payload);

  factory Message.fromJson(String json){
    Map<String,dynamic> decodedMap = jsonDecode(json);
    return Message(decodedMap["id"],
        Events.values.byName(decodedMap["event"]),
        User.fromJson(jsonEncode(decodedMap["sender"])),
        decodedMap["payload"]);
  }

  String toJson(){
    return jsonEncode({
      "id" : id,
      "event":event.name.toString(),
      "sender" : sender.toMap(),
      "payload" : payload
    });
  }

  User decodePlayerPayload(){
    return User.fromMap(jsonDecode(payload)["user"]);
  }

  int decodeNumberPayload(){
    return jsonDecode(payload)["number"];
  }

  GameStatus decodeStatusPayload(){
    return GameStatus.values.byName(jsonDecode(payload)["status"]);
  }

  int decodeGameIdPayload(){
    return jsonDecode(payload)["game_id"];
  }
}


enum Events{
  user_joined,
  user_left,
  alert,
  number_called,
  game_status,
  game_id
}