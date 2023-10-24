import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:developer' as dev;

abstract class ComputerPlayer {
  static const int maxScore = 1000000;
  bool amIWhite;
  late String levelName;
  static bool logDecisions = true;

  ComputerPlayer(this.amIWhite);

  /// returns ComputerPlayer's choice for next move
  Coord? chooseNextMove(Situation situation) {
    if (logDecisions) {
      int initialScore = scoreBoard(situation);
      dev.log(
          "$levelName ${amIWhite ? 'W' : 'B'}\ninitial BoardState:$situation\ninitial Score=$initialScore");
    }

    List<Coord> choices = findBestChoices(situation);

    // no legal Moves
    if (choices.isEmpty) {
      return null;
    }

    // only 1 best Move
    if (true) {
      //choices.length == 1) {
      Coord choice = choices[0];
      if (logDecisions) {
        dev.log(
            "$levelName chose ${situation.whitesTurn ? 'W' : 'B'}->$choice");
      }
      return choice;
    }

/*
    // multiple equally best Moves
    StringBuilder sb = new StringBuilder();
    sb.AppendFormat("Equal Choices: {0}->", situation.WhitesTurn ? 'W' : 'B');
    foreach (Coord choice in choices)
      sb.Append(choice + " ");
          if (logDecisions)
              Debug.Print(sb.ToString());

    // randomly pick one of the choices
          int randomIndex = random.Next(choices.Count);
    Coord randomChoice = choices[randomIndex];
          if (logDecisions)
              Debug.Print("{0} chose {1}->{2}", levelName, situation.WhitesTurn ? 'W' : 'B', randomChoice);
          return randomChoice;
*/
  }

  List<Coord> findBestChoices(Situation situation);

  /// calculates a Score for a BoardState
  /// uses WeightedCoordValue()
  /// uses difference between Computer's Score for his Piecec & Opponent's Score for his Pieces
  int scoreBoard(Situation situation) {
    int emptyCount = situation
        .emptyCount; // calculate this Property once instead of repeatedly recalculating

    int score = 0;
    for (int y = 1; y <= 8; y++) {
      // loop rows
      for (int x = 1; x <= 8; x++) {
        // loop columns
        SquareState state = situation.squares[x - 1][y - 1];
        if (state == SquareState.empty) {
          continue;
        }
        Coord coord = Coord(x, y);
        int coordValue = weightedCoordValue(coord, emptyCount);

        // if AmIWhite then add for White Pieces & subtract for Black Pieces
        score = score +
            ((amIWhite ^ (state == SquareState.black))
                ? coordValue
                : -coordValue);
      }
    }

    return score; // * (100 + random.Next(10)) / 100; // increase by 1-10% to add a little randomness to prevent repeat games
  }

  /// returns a weighted value for a Coord
  /// Beginner values all Coords equally, while higher Levels weight Coord values by location as more valuable or dangerous
  /// Intermediate/Advanced use negatives to make better decisions
  /// Recursive Levels avoid negatives
  /*virtual*/ int weightedCoordValue(Coord coord, int emptyCount) {
    // Intermediate/Advanced perform better with Negatives helping make better decisions.
    // 50 -5 20 20
    // -5 -9 -2 -2
    // 20 -2  4  2
    // 20 -2  2  1
    switch (coord.x) {
      // Edge COLs
      case 1:
      case 8:
        switch (coord.y) {
          case 1:
          case 8:
            return 50; // Corner
          case 2:
          case 7:
            return -5; // leads to Corner
          default:
            return 20; // Edge
        }
      // COL before Edge
      case 2:
      case 7:
        switch (coord.y) {
          case 1:
          case 8:
            return -5; // leads to Corner
          case 2:
          case 7:
            return -9; // leads to Corner
          default:
            return -2; // leads to Edge
        }
      // COL before COL before Edge
      case 3:
      case 6:
        switch (coord.y) {
          case 1:
          case 8:
            return 20; // Edge
          case 2:
          case 7:
            return -2; // leads to Edge
          case 3:
          case 6:
            return 4; // leads to Opponent getting devalued Coord near Corner
          default:
            return 2; // leads to Opponent getting devalued Coord near Edge
        }
      // middle COLs
      default:
        switch (coord.y) {
          case 1:
          case 8:
            return 10; // Edge
          case 2:
          case 7:
            return -2; // leads to Edge
          case 3:
          case 6:
            return 2; // leads to Opponent getting devalued Coord near Edge
          default:
            return 1; // Middles
        }
    }
  }

  @override
  toString() {
    return "$levelName = ${amIWhite ? 'White' : 'Black'}";
  }
}
