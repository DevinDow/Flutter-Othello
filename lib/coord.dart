/// Coord of Squares ( 1..8 , 1..8 )
class Coord {
  int x, y;

  Coord(this.x, this.y);

  @override
  bool operator ==(Object other) {
    assert(other is Coord);
    Coord otherCoord = other as Coord;
    return x == otherCoord.x && y == otherCoord.y;
  }

  @override
  String toString() {
    return "($x, $y)";
  }
}
