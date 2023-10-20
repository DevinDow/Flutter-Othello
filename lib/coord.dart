/// Coord of Squares ( 1..8 , 1..8 )
class Coord {
  int x, y;

  Coord(this.x, this.y);

  @override
  String toString() {
    return "($x, $y)";
  }
}
