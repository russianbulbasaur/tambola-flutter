import 'dart:convert';

import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

class Message{
  final int id;
  final Events event;
  final User sender;
  final Map payload;
  Message(this.id,this.event,this.sender,this.payload);

  factory Message.fromJson(String json){
    Map decodedMap = jsonDecode(json);
    Events event = Events.values.byName(decodedMap["event"]);
    return Message(decodedMap["id"],
        event,
        User.fromJson(jsonEncode(decodedMap["sender"])),
        decodedMap[event.payloadName()]);
  }


  String toJson(){
    return jsonEncode({
      "id" : id,
      "event":event.name.toString(),
      "sender" : sender.toMap(),
      event.payloadName() : payload
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

extension EventFunctions on Events{
  String payloadName(){
    switch(this){
      case Events.user_joined:
        return "user_joined_payload";
      case Events.user_left:
        return "user_left_payload";
      case Events.players_already_in_lobby:
        return "players_already_in_lobby_payload";
      case Events.number_called:
        return "number_called_payload";
      case Events.game_status:
        return "game_status_payload";
      case Events.alert:
        return "alert_payload";
    }
  }
}