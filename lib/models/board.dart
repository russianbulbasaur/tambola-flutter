import 'dart:collection';

class Board{
  final int count = 90;
  final int id;
  late List<BoardNumberTile> tiles;
  HashSet<int> availableNumbers = HashSet();
  Map<int,BoardNumberTile> numberToTileMap = {};
  Board(this.id){
    _generateTiles();
  }

  void _generateTiles(){
    tiles = List.generate(count, (index){
      availableNumbers.add(index+1);
      return numberToTileMap[index+1] = BoardNumberTile(index+1, false);
    });
  }
}


class BoardNumberTile{
  final int number;
  bool isCalled;
  BoardNumberTile(this.number,this.isCalled);
}