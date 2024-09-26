import 'dart:convert';

import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

class Message{
  final int id;
  final Events event;
  final User sender;
  final Map<String,dynamic> payload;
  Message(this.id,this.event,this.sender,this.payload);

  factory Message.fromJson(String json){
    Map decodedMap = jsonDecode(json);
    Events event = Events.values.byName(decodedMap["event"]);
    return Message(decodedMap["id"],
        event,
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
    return User.fromMap(payload["user"]);
  }

  int decodeNumberPayload(){
    return payload["number"];
  }

  GameStatus decodeStatusPayload(){
    return GameStatus.values.byName(payload["status"]);
  }

  int decodeGameIdPayload(){
    return payload["game_id"];
  }

  List<dynamic> decodePlayersInLobbyPayload() {
    return [payload["game_id"],payload["players"]];
  }
}


enum Events{
  user_joined,
  user_left,
  alert,
  number_called,
  game_status,
  players_already_in_lobby
}
