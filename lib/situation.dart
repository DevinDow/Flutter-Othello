import 'dart:developer' as dev;

enum SquareState { empty, black, white }

class Situation {
  // squares is a 2D Array ( x=[0-7] , y=[0-7] ) of SquareState
  // squares is a List of columns (x), which are Lists of SquareStates by row index (y)
  // List<List>.generate(8, List<SquareState>.filled(8, empty))
  var squares = List<List>.generate(
      // generate 8 column Lists of Lists
      8,
      // fill each column List with a List of 8 SquareState.empty
      (x) => List<SquareState>.filled(8, SquareState.empty),
      growable: false);

  bool whitesTurn = false;
  bool skippedTurn = false;
  bool endOfGame = false;

  Situation() {
    squares[3][3] = SquareState.black;
    squares[4][3] = SquareState.white;
    squares[3][4] = SquareState.white;
    squares[4][4] = SquareState.black;
  }

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
    return s;
  }
}
