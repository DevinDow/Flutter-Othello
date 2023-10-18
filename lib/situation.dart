import 'package:flutter/material.dart';

import 'dart:developer' as dev;

enum SquareState { empty, black, white }

class Situation {
  // squares is a 2D Array of SquareState
  var squares = List<List>.generate(
      8,
      (i) => List<SquareState>.generate(8, (index) => SquareState.empty,
          growable: false),
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
