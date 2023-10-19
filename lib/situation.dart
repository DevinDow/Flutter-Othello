import 'dart:developer' as dev;

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
      squares[3][3] = SquareState.black;
      squares[4][3] = SquareState.white;
      squares[3][4] = SquareState.white;
      squares[4][4] = SquareState.black;
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
