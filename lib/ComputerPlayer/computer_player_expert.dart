import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/ComputerPlayer/computer_player_recursive.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:developer' as dev;

class ComputerPlayerExpert extends ComputerPlayerRecursive {
  int expertTurnsDepth = 11;

  static bool logEachExpertTurn = false;
  static bool logEachExpertTurnBoardState = false;
  static bool logEachExpertLegalMoveResponse = false;

  ComputerPlayerExpert(bool amIWhite, {int depth = 11}) : super(amIWhite) {
    levelName = "Expert";
    expertTurnsDepth = depth;
  }

  @override
  int findMinMaxScoreAfterSeveralTurns(Situation situation, int turn) {
    return findMinMaxScoreForHighestScoringMove(situation, turn);
  }

  /// Recusively find optimal choice by finding highest/lowest Score possible on each Turn
  /// on My/Computer's Turn: maximize my Score
  /// on Opponent's Turn: assume Opponent will choose lowest Score for Me/Computer
  /// return the minMaxScore after several Turns/recusions
  int findMinMaxScoreForHighestScoringMove(Situation situation, int turn) {
    bool myTurn = situation.whitesTurn ^ !amIWhite;
    int minMaxScore =
        myTurn ? -ComputerPlayer.maxScore : ComputerPlayer.maxScore;
    Coord? minMaxResponse;
    Situation? minMaxResponseSituation;

    situation.findLegalMoves();
    if (situation.legalMoves.isEmpty) // game over
    {
      return scoreEndOfGame(situation);
    }

    // find best/worst Score for every leagalMove response
    for (Coord response in situation.legalMoves) {
      Situation responseSituation = situation.clone();
      responseSituation.placePieceAndFlipPiecesAndChangeTurns(response);

      int responseScore;
      if (responseSituation.endOfGame) {
        responseScore = scoreEndOfGame(responseSituation);
      } else {
        responseScore = scoreBoard(responseSituation);
      }
      // Log each legalMove response
      if (logEachExpertTurn && logEachExpertLegalMoveResponse) {
        dev.log(
            "       - Expert LegalMove Response: #$turn=${logChoice(situation.whitesTurn, response, responseScore, logEachExpertTurnBoardState ? responseSituation : null)}",
            name: "logEachExpertLegalMoveResponse");
      }

      if (myTurn) {
        if (responseScore >
            minMaxScore) // my Turn goes for highest Score for me
        {
          minMaxScore = responseScore;
          minMaxResponse = response;
          minMaxResponseSituation = responseSituation;
        }
      } else {
        if (responseScore <
            minMaxScore) // opponent's Turn chooses lowest Score for me
        {
          minMaxScore = responseScore;
          minMaxResponse = response;
          minMaxResponseSituation = responseSituation;
        }
      }
    }

    // Log the chosen minMaxResponse
    if (logEachExpertTurn) {
      dev.log(
          "- Expert response #$turn=${logChoice(situation.whitesTurn, minMaxResponse!, minMaxScore, logEachExpertTurnBoardState ? minMaxResponseSituation : null)}",
          name: "logEachExpertTurn");
    }

    if (turn >= expertTurnsDepth) return minMaxScore;

    int nextTurn = turn + 1;
    if (minMaxResponseSituation?.whitesTurn ==
        situation.whitesTurn) // turn skipped due to no legal moves
    {
      if (logEachExpertTurn) {
        dev.log("- SKIPPED Turn #$nextTurn=${situation.whitesTurn ? 'W' : 'B'}",
            name: "logEachExpertTurn");
      }
      nextTurn++; // depth should go down to same Player to compare equally
    }

    // recurse to return resulting minMaxScore after levelsLeft more Turns
    return findMinMaxScoreForHighestScoringMove(
        minMaxResponseSituation!, nextTurn);
  }

  @override
  String toString() {
    return "${super.toString()} DepthForBestMove=$expertTurnsDepth";
  }
}
