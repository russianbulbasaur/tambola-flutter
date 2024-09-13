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
    //making the ticket as a whole
    //3 rows and 9 cols = 27 numbers
    for(int col=0;col<9;col++){
      tiles.add(threeColumnTiles(col)); // adding 3 column tiles 9 times = 27 tiles
    }
    //Filtering out selective positions for numbers in each row
    for(int row=0;row<3;row++){
      List<int> selectedColumns = randomFiveColumns();
      for(int col in selectedColumns){
        tiles.elementAt(col).elementAt(row).hasNumber = true;
      }
    }

    //final validity check
    if(!validateTicket()) _generateTiles();
  }

  List<TicketNumberTile> threeColumnTiles(int column){
    HashSet<int> choices = HashSet();
    List<int> startPoints = [1,10,20,30,40,50,60,70,80]; // Min values for columns
    int startPoint = startPoints[column];
    for(int i=0;i<9;i++){
      choices.add(startPoint+i); //eg col 0 will start from 1 and end at 1+8 = 9;
    }
    //3 choices
    List<TicketNumberTile> columnTiles = [];
    for(int i=0;i<3;i++){
      List<int> choicesList = choices.toList();
      int choice = choicesList[Random().nextInt(100000)%choicesList.length];
      columnTiles.add(TicketNumberTile(choice, false, false));
      choices.remove(choice);
    }
    columnTiles.sort((a, b) => (a.number.compareTo(b.number)),);
    return columnTiles;
  }

  generatorFunction(index,start){ return index+start; }

  List<int> randomFiveColumns(){
    HashSet<int> availableColumns = HashSet();
    availableColumns.addAll([0,1,2,3,4,5,6,7,8]);
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
    int chosen = Random().nextInt(10000)%columnList.length;
    availableColumns.remove(chosen);
    return columnList[chosen];
  }


  bool validateTicket(){
    //check if one element in each column has the same
    for(List<TicketNumberTile> colList in tiles){
      bool hasNumberedTile = false;
      for(TicketNumberTile tile in colList){
        hasNumberedTile |= tile.hasNumber;
      }
      if(!hasNumberedTile) return false;
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