import 'dart:math';

import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:developer' as dev;

abstract class ComputerPlayer {
  static const int maxScore = 1000000;
  bool amIWhite;
  late String levelName;
  static bool logDecisions = false;

  ComputerPlayer(this.amIWhite);

  /// returns ComputerPlayer's choice for next move
  Coord? chooseNextMove(Situation situation) {
    // log initial BoardState & Score
    if (logDecisions) {
      int initialScore = scoreBoard(situation);
      dev.log(
          "$levelName ${amIWhite ? 'W' : 'B'}\ninitial BoardState:$situation\ninitial Score=$initialScore",
          name: "ComputerPlayer.chooseNextMove()");
    }

    // call derived class' findBestChoices()
    DateTime start = DateTime.now();
    List<Coord> choices = findBestChoices(situation);
    Duration duration = DateTime.now().difference(start);
    String seconds = (0.001 * duration.inMilliseconds).toStringAsPrecision(3);
    dev.log("$levelName took $seconds seconds to select $choices",
        name: "ComputerPlayer.chooseNextMove()");

    // no legal Moves
    if (choices.isEmpty) {
      return null;
    }

    // only 1 best Move
    if (choices.length == 1) {
      return choices[0];
    }

    // multiple equally best Moves
    // randomly pick one of the choices
    int randomIndex = Random().nextInt(choices.length);
    Coord randomChoice = choices[randomIndex];
    if (logDecisions) {
      dev.log("$levelName randomly selected $randomChoice",
          name: "ComputerPlayer.chooseNextMove()");
    }
    return randomChoice;
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

    return score; // * (100 + Random().nextInt(10)) / 100; // increase by 1-10% to add a little randomness to prevent repeat games in ComputerPlayer vs ComputerPlayer Tests
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
