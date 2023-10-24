import 'dart:core';

import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/situation.dart';
import 'package:othello/coord.dart';

import 'dart:developer' as dev;

abstract class ComputerPlayerRecursive extends ComputerPlayer {
  static bool logEachRecursiveTurn = false;
  static bool logRecursiveChoiceOptions = false;

  ComputerPlayerRecursive(bool amIWhite) : super(amIWhite);

  /// <summary>
  /// does all the recusion of several Turns to return a Score for this BoardState's outlook
  /// </summary>
  /// <param name="boardState">the BoardState to find a Score for</param>
  /// <param name="turn">which recursive Turn Depth</param>
  /// <returns>Score after recursing several Turns</returns>
  int findMinMaxScoreAfterSeveralTurns(Situation situation, int turn);

  /// <summary>
  /// loop through all of Computer's Legal Moves
  /// collect the ones that maximize Score after several Turns
  /// if multiple Choices tie after several Turns then choose the ones with the highest first-move Score
  /// </summary>
  /// <returns>list of equal Computer Choices</returns>
  @override
  List<Coord> findBestChoices(Situation situation) {
    int maxComputerScoreAfterSeveralTurns = -1000000;
    List<Coord> bestChoices = List<Coord>.empty(growable: true);

    // try every Legal Move
    situation.findLegalMoves();
    for (Coord computerChoice in situation.legalMoves) {
      if (logEachRecursiveTurn) {
        // re-Log initial BoardState before each legal Move
        dev.log("initial BoardState:$situation", name: "logEachRecursiveTurn");
      }

      // Turn Depth = 1
      Situation computerSituation = situation.clone();
      computerSituation.placePieceAndFlipPiecesAndChangeTurns(computerChoice);
      int computerChoiceScore = scoreBoard(computerSituation);
      if (logEachRecursiveTurn) {
        // Log computerChoice with its computerChoiceScore & computerBoardState
        dev.log(
            " - $levelName choice: #1=${logChoice(situation.whitesTurn, computerChoice, computerChoiceScore, computerSituation)}",
            name: "logEachRecursiveTurn");
      }

      // next Turn Depth = 2 (unless Turn Skipped due to no leagl Moves)
      int nextTurn = 2;
      if (computerSituation.whitesTurn ==
          situation.whitesTurn) // Turn Skipped due to no legal moves
      {
        if (logEachRecursiveTurn) {
          dev.log("- SKIPPED Turn #2=${situation.whitesTurn ? 'W' : 'B'}",
              name: "logEachRecursiveTurn");
        }
        nextTurn++; // depth should go down to same Player to compare equally
      }

      // find minMaxScoreAfterSeveralTurns by starting recursion
      int minMaxScoreAfterSeveralTurns =
          findMinMaxScoreAfterSeveralTurns(computerSituation, nextTurn);
      if (logEachRecursiveTurn) {
        // Log computerChoice's minMaxScoreAfterSeveralTurns
        dev.log(
            " - $levelName choice: #1=${logChoice(situation.whitesTurn, computerChoice, computerChoiceScore, null)} minMaxScoreAfterSeveralTurns=$minMaxScoreAfterSeveralTurns\n\n",
            name: "logEachRecursiveTurn");
      }

      // remember the list of bestComputerChoices that attain maxComputerScoreAfterSeveralTurns
      if (minMaxScoreAfterSeveralTurns >
          maxComputerScoreAfterSeveralTurns) // remember maxComputerScoreAfterSeveralTurns and start a new List of Moves that attain it
      {
        maxComputerScoreAfterSeveralTurns = minMaxScoreAfterSeveralTurns;
        bestChoices = List<Coord>.empty(growable: true);
      }

      if (minMaxScoreAfterSeveralTurns >=
          maxComputerScoreAfterSeveralTurns) // add choice to bestComputerChoices
      {
        if (!bestChoices.contains(computerChoice)) {
          bestChoices.add(computerChoice);
        }
      }
    }

    if (logRecursiveChoiceOptions) {
      dev.log(
          "** $levelName bestChoices count=${bestChoices.length}, maxComputerScoreAfterSeveralTurns=$maxComputerScoreAfterSeveralTurns.  Choose the highest scoring Move.",
          name: "logRecursiveChoiceOptions");
    }

    // find finalComputerChoices from equal bestComputerChoices based on the one with best computerChoiceScore
    int maxComputerScore = -ComputerPlayer.maxScore;
    List<Coord> finalComputerChoices = List<Coord>.empty(growable: true);
    for (Coord computerChoice in bestChoices) {
      Situation computerSituation = situation.clone();
      computerSituation.placePieceAndFlipPiecesAndChangeTurns(computerChoice);
      int computerChoiceScore = scoreBoard(computerSituation);
      if (logRecursiveChoiceOptions) {
        dev.log(
            "$levelName Top Computer choice: ${logChoice(computerSituation.whitesTurn, computerChoice, computerChoiceScore, null)}",
            name: "logRecursiveChoiceOptions");
      }
      if (computerChoiceScore > maxComputerScore) {
        maxComputerScore = computerChoiceScore;
        finalComputerChoices = List<Coord>.empty(growable: true);
      }
      if (computerChoiceScore >= maxComputerScore) {
        finalComputerChoices.add(computerChoice);
      }
    }

    if (logRecursiveChoiceOptions) {
      dev.log(
          "finalComputerChoices count=${finalComputerChoices.length}, maxComputerScore=$maxComputerScore maxComputerScoreAfterSeveralTurns=$maxComputerScoreAfterSeveralTurns",
          name: "logRecursiveChoiceOptions");
    }

    return finalComputerChoices;
  }

  /// End-of-Game Score should just be a comparison of Counts
  /// multiplier helps it fit in with & out-weigh other Scores
  int scoreEndOfGame(Situation situation) {
    int endOfGameScore;
    const int multiplier = 10000;
    if (amIWhite) {
      endOfGameScore =
          multiplier * (situation.whiteCount - situation.blackCount);
    } else {
      endOfGameScore =
          multiplier * (situation.blackCount - situation.whiteCount);
    }

    return endOfGameScore; /* *
        (100 + random.Next(10)) /
        100; // increase by 1-10% to add a little randomness to prevent repeat games;*/
  }

  /// W->(1,1) resulting Score=+100
  /// resulting BoardState:Turn=B
  ///  W.......
  ///  WWB.....
  String logChoice(
      bool whitesTurn, Coord coord, int score, Situation? situation) {
    // W->(1,1) resulting Score=+100
    String s = "${whitesTurn ? 'W' : 'B'}->$coord Score=$score";

    // resulting BoardState: Turn=B
    //  W.......
    //  WWB.....
    if (situation != null) {
      s += "\nresulting BoardState:$situation";
    }

    return s;
  }

  /// returns a weighted value for a Coord
  /// Beginner values all Coords equally
  /// higher Levels weight Coord values by location as more valuable or dangerous
  @override
  int weightedCoordValue(Coord coord, int emptyCount) {
    const int numEmptyToConsiderBoardMostlyFilled = 5;
    bool boardMostlyFilled = emptyCount <= numEmptyToConsiderBoardMostlyFilled;
    if (boardMostlyFilled) {
      return 100; // after board is mostly full, Expert/Ultimate should just try to win the game
    }

    // Higher Levels value Coords differently
    // Corners are highest, then Ends.
    // Coords before Corners & Ends are devalued since they lead to Opponent getting Corners & Ends.
    // And Coords before those are valuable since they lead to Opponent getting those devalued Coords.

    // My Recursive Algorithms perform worse when Negatives throw a wrench in comparing BoardStates, esp near the end of the Game.
    // 2000   2 200 200
    //    2   1   3   3
    //  200   3  50  30
    //  200   3  30  10
    switch (coord.x) {
      // Edge COLs
      case 1:
      case 8:
        switch (coord.y) {
          case 1:
          case 8:
            return 2000; // Corner
          case 2:
          case 7:
            return 2; // leads to Corner
          default:
            return 200; // Edge
        }
      // COL before Edge
      case 2:
      case 7:
        switch (coord.y) {
          case 1:
          case 8:
            return 2; // leads to Corner
          case 2:
          case 7:
            return 1; // leads to Corner
          default:
            return 3; // leads to Edge
        }
      // COL before COL before Edge
      case 3:
      case 6:
        switch (coord.y) {
          case 1:
          case 8:
            return 200; // Edge
          case 2:
          case 7:
            return 3; // leads to Edge
          case 3:
          case 6:
            return 50; // leads to Opponent getting devalued Coord near Corner
          default:
            return 30; // leads to Opponent getting devalued Coord near Edge
        }
      // middle COLs
      default:
        switch (coord.y) {
          case 1:
          case 8:
            return 200; // Edge
          case 2:
          case 7:
            return 3; // leads to Edge
          case 3:
          case 6:
            return 30; // leads to Opponent getting devalued Coord near Edge
          default:
            return 10; // Middles
        }
    }
  }
}
