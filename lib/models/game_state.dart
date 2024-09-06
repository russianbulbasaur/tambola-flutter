import 'package:tambola/models/user.dart';

import 'game.dart';

class GameState{
  GameStatus status;
  List<String> alerts;
  List<User> players;
  List<int> numbersCalled;
  Game? game;
  GameState(this.status,this.alerts,this.players,this.numbersCalled);


  void setGame(Game g){
    game = g;
  }

  void updateStatus(GameStatus newStatus){
    status = newStatus;
  }

  void addNumber(int number){
    numbersCalled.add(number);
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
}

enum GameStatus{
  waiting,playing,closed
}