class Ticket{
  final int id;
  late List<TicketNumberTile> tiles;
  Ticket(this.id){
    _generateTiles();
  }

  void _generateTiles(){
    tiles = List.generate(27, (index) => TicketNumberTile(index, false, true));
  }
}


class TicketNumberTile{
  final int number;
  final bool hasNumber;
  bool isTicked;
  TicketNumberTile(this.number,this.isTicked,this.hasNumber);
}