import 'dart:collection';
import 'dart:math';

class Ticket{
  final int id;
  final List<List<TicketNumberTile>> tiles = List.empty(growable: true);
  Ticket(this.id){
    _generateTiles();
  }

  void _generateTiles(){
    tiles.clear();
    //3 rows and 9 cols = 27 numbers
    for(int row=1;row<=3;row++){
      List<TicketNumberTile> rowList = [];
      for(int col=1;col<=9;col++){
        rowList.add(TicketNumberTile(selectTicketNumber(col), false, false));
      }
      tiles.add(rowList);
    }

    List<int> colSum = [];
    List<int> selectedColumns = [];
    for(List<TicketNumberTile> rowList in tiles) {
      selectedColumns = randomFiveColumns();
      for (int column in selectedColumns) {
        rowList[column-1].hasNumber = true; //-1 for index adjustment, col 1 is at 0 index
      }
    }

    if(!validateTicket(colSum)) _generateTiles();
  }

  int selectTicketNumber(int column){
    int random = Random().nextInt(10); //0 to 9
    switch(column){
      case 1:
        return random + 1;  //min 1 max 10
      case 2:
        return random + 11; // min 11 max 20
      case 3:
        return random + 21; // min 21 max 30
      case 4:
        return random + 31; //min 31 max 40
      case 5:
        return random + 41; //min 41 max 50
      case 6:
        return random + 51; // min 51 max 60
      case 7:
        return random + 61; // min 61 max 70
      case 8:
        return random + 71; // min 71 max 80
      case 9:
        return random + 81; // min 81 max 90
    }
    return 0;
  }

  List<int> randomFiveColumns(){
    HashSet<int> availableColumns = HashSet();
    availableColumns.addAll([1,2,3,4,5,6,7,8,9]);
    return [
      randomColumn(availableColumns),
      randomColumn(availableColumns),
      randomColumn(availableColumns),
      randomColumn(availableColumns),
      randomColumn(availableColumns)
    ];
  }

  int randomColumn(HashSet<int> availableColumns){
    List<int> columnList = availableColumns.toList();
    return columnList[Random().nextInt(10000)%columnList.length];
  }


  bool validateTicket(List<int> colSum){
    for(int sum in colSum){
      if(sum<=0 || sum>3) return false;
    }
    return true;
  }
}


class TicketNumberTile{
  final int number;
  bool hasNumber;
  bool isTicked;
  TicketNumberTile(this.number,this.isTicked,this.hasNumber);
}