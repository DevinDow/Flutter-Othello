import 'package:othello/coord.dart';

enum SquareState { empty, black, white }

/// Situation is the grid of Pieces and who's Turn
class Situation {
  // Private Fields

  // squares is a 2D Grid ( x=[0-7] , y=[0-7] ) of SquareState
  // squares is a List of Columns (x), which are Lists of SquareStates by Row index (y)
  // List<List>.generate(8, List<SquareState>.filled(8, empty))
  List<List> squares = List<List>.generate(
      // generate 8 Column (x) Lists of Lists
      8,
      // fill each Column (x) List with a List of 8 SquareState.empty for each Row (y)
      (x) => List<SquareState>.filled(8, SquareState.empty),
      growable: false);

  bool whitesTurn = false;
  bool skippedTurn = false;
  bool endOfGame = false;

  // Constructor
  Situation({this.whitesTurn = false, setInitialPieces = true}) {
    if (setInitialPieces) {
      setCoord(Coord(4, 4), SquareState.black);
      setCoord(Coord(5, 4), SquareState.white);
      setCoord(Coord(4, 5), SquareState.white);
      setCoord(Coord(5, 5), SquareState.black);
    }
  }

  // Public Properties
  int get blackCount {
    return getCountOfState(SquareState.black);
  }

  int get whiteCount {
    return getCountOfState(SquareState.white);
  }

  int get emptyCount {
    return getCountOfState(SquareState.empty);
  }

  // Methods
  SquareState getCoord(Coord coord) {
    return squares[coord.x - 1][coord.y - 1];
  }

  void setCoord(Coord coord, SquareState state) {
    squares[coord.x - 1][coord.y - 1] = state;
  }

  int getCountOfState(SquareState state) {
    int n = 0;
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (squares[x][y] == state) {
          n++;
        }
      }
    }
    return n;
  }

  void placePieceAndFlipPiecesAndChangeTurns(Coord coord) {
    // place Piece at coord
    setCoord(coord, whitesTurn ? SquareState.white : SquareState.black);

    // flip all affected Pieces
    //coordsFlipped = new List<Coord>();
    flipInDirection(coord, 0, -1);
    flipInDirection(coord, -1, -1);
    flipInDirection(coord, -1, 0);
    flipInDirection(coord, -1, 1);
    flipInDirection(coord, 0, 1);
    flipInDirection(coord, 1, 1);
    flipInDirection(coord, 1, 0);
    flipInDirection(coord, 1, -1);

    // change Turns
    skippedTurn = false;
    whitesTurn = !whitesTurn;
    /*if (!IsLegalMoveAvailable())
    {
        skippedTurn = true;
        WhitesTurn = !WhitesTurn;
        if (!IsLegalMoveAvailable())
            endOfGame = true;
    }*/
  }

  void flipInDirection(Coord choice, int dx, int dy) {
    int x = choice.x + dx;
    int y = choice.y + dy;

    // find partner piece
    while (x >= 1 && x <= 8 && y >= 1 && y <= 8) {
      SquareState partnerState = getCoord(Coord(x, y));
      if (partnerState == SquareState.empty) return;

      // if not a partner piece
      if (whitesTurn && partnerState == SquareState.black ||
          !whitesTurn && partnerState == SquareState.white) {
        x += dx;
        y += dy;
        continue; // keep looking for partner piece
      }

      // partner piece found
      x -= dx;
      y -= dy;

      // work back to placed piece flipping
      while (!(x == choice.x && y == choice.y)) {
        Coord coordToFlip = Coord(x, y);
        //coordsFlipped.Add(coordToFlip);
        setCoord(
            coordToFlip, whitesTurn ? SquareState.white : SquareState.black);

        x -= dx;
        y -= dy;
      }

      return;
    }
  }

  // Overrides
  @override
  String toString() {
    String s = '\n';
    if (endOfGame) {
      s += " *** END OF GAME *** \n";
    } else {
      s += "Turn=${whitesTurn ? "W" : "B"}\n";
    }

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        SquareState squareState = squares[x][y];
        switch (squareState) {
          case SquareState.empty:
            s += ' .';
            break;
          case SquareState.black:
            s += ' B';
            break;
          case SquareState.white:
            s += ' W';
            break;
        }
      }
      s += '\n';
    }
    s += 'Black=$blackCount, White=$whiteCount';
    return s;
  }
}
