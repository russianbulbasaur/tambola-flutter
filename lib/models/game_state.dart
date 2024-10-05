import 'package:tambola/models/user.dart';

import 'game.dart';

class GameState{
  GameStatus status;
  List<String> alerts;
  List<User> players;
  List<int> numbersCalled;
  Game? game;
  int called = 0;
  int previousCalled = 0;
  GameState(this.status,this.alerts,this.players,this.numbersCalled);


  void setGame(Game g){
    game = g;
  }

  void updateStatus(GameStatus newStatus){
    status = newStatus;
  }

  void addNumber(int number){
    numbersCalled.add(number);
    previousCalled = called;
    called = number;
  }

  void deleteNumber(int number){
    numbersCalled.remove(number);
  }

  void addPlayer(User player){
    players.add(player);
  }

  void addAlert(String alert){
    alerts.add(alert);
  }

  void initState(List decodePlayersInLobbyPayload) {
    players = (decodePlayersInLobbyPayload[1] as List).map((e) => User.fromMap(e)).toList();
    game!.id = decodePlayersInLobbyPayload[0] as String;
  }
}

enum GameStatus{
  waiting,playing,closed
}