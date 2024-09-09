import 'dart:collection';

class Board{
  final int id;
  final List<List<BoardNumberTile>> tiles = List.empty(growable: true);
  HashSet<int> availableNumbers = HashSet();
  Map<int,BoardNumberTile> numberToTileMap = {};
  Board(this.id){
    _generateTiles();
  }

  void _generateTiles(){
    int number = 0;
    //9 rows 10 columns = 90 numbers
    for(int row=1;row<=9;row++){
      List<BoardNumberTile> newRow = [];
      for(int col=1;col<=10;col++){
        number = 10*(row-1) + col;
        BoardNumberTile tile = BoardNumberTile(number,false);
        newRow.add(tile);
        availableNumbers.add(number);
        numberToTileMap[number] = tile;
      }
      tiles.add(newRow);
    }
  }
}


class BoardNumberTile{
  final int number;
  bool isCalled;
  BoardNumberTile(this.number,this.isCalled);
}