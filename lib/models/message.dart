import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:tambola/models/game_state.dart';
import 'package:tambola/models/user.dart';

class Message{
  final int id;
  final Events event;
  final User sender;
  final Map<String,dynamic> payload;
  int? timestamp;
  Message(this.id,this.event,this.sender,this.payload);

  factory Message.fromJson(String json){
    Map decodedMap = jsonDecode(json);
    Events event = Events.values.byName(decodedMap["event"]);
    Message message = Message(decodedMap["id"],
        event,
        User.fromJson(jsonEncode(decodedMap["sender"])),
        decodedMap["payload"]);
    // message.timestamp = decodedMap["timestamp"];
    // if(kDebugMode){
    //   int now = (DateTime.now().millisecondsSinceEpoch/1000) as int;
    //   int diff = now - message.timestamp!;
    //   log("Ping : ${diff*1000} ms");
    // }
    return message;
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
    return User.fromMap(payload["player"]);
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
  player_joined,
  player_left,
  alert,
  number_called,
  game_status,
  players_already_in_lobby
}
