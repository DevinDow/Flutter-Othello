import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/ComputerPlayer/computer_player_expert.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:developer' as dev;

class ComputerPlayerUltimate extends ComputerPlayerExpert {
  //private const int ultimateTurnsDepth = 11;
  int ultimateTurnsDepthToStartUsingExpert =
      6; // Ultimate recurses for every Legal Move, but that is excessively slow and less critical at deeper Depths

  static bool logEachUltimateTurn = false;
  static bool logEachUltimateTurnBoardState = false;
  static bool logEachUltimateLegalMoveResponse = false;
  static bool logEachUltimateOption = false;

  ComputerPlayerUltimate(bool amIWhite,
      {int depthForEveryMove = 6, int depthForOnlyBestMove = 11})
      : super(amIWhite /*, {depth=depthForOnlyBestMove}*/) {
    levelName = "Ultimate";
    ultimateTurnsDepthToStartUsingExpert = depthForEveryMove;
    expertTurnsDepth = depthForOnlyBestMove;
  }

  @override
  int findMinMaxScoreAfterSeveralTurns(Situation situation, int turn) {
    return findMinMaxScoreForAllMyLegalMoves(situation, turn);
  }

  /// Recusively find optimal choice by trying every LegalMove for Computer Turn and worst Score possible for each Opponent Turn
  /// on My/Computer's Turn: recurse for every LegalMove
  /// on Opponent's Turn: assume Opponent will choose lowest Score for Me/Computer
  /// return the minMaxScore after several Turns/recusions
  /// reverts to using FindMinMaxScoreForHighestScoringMove() after ultimateTurnsDepth_TO_START_USING_EXPERT Turns
  int findMinMaxScoreForAllMyLegalMoves(Situation situation, int turn) {
    bool myTurn = situation.whitesTurn ^ !amIWhite;
    int nextTurn = turn + 1;
    situation.findLegalMoves();
    if (situation.legalMoves.isEmpty) {
      return scoreEndOfGame(situation);
    }

    if (myTurn) // find recursive Score for each legalMove
    {
      int maxRecursiveScore = -ComputerPlayer.maxScore;
      //Coord? maxRecursiveResponse;
      //Situation maxRecursiveResponseSituation;
      for (Coord legalMove in situation.legalMoves) {
        Situation legalMoveSituation = situation.clone();
        legalMoveSituation.placePieceAndFlipPiecesAndChangeTurns(legalMove);

        int recusiveScore;
        if (legalMoveSituation.endOfGame) {
          // return ScoreEndOfGame()
          recusiveScore = scoreEndOfGame(legalMoveSituation);
          /*} else if (turn >= ultimateTurnsDepth) { // return ScoreBoard()
                        recusiveScore = ScoreBoard(legalMoveBoardState);*/
        } else {
          // recurse
          if (logEachUltimateTurn && logEachUltimateOption) {
            dev.log(
                "       - Ultimate LegalMove: #$turn=${logChoice(situation.whitesTurn, legalMove, scoreBoard(legalMoveSituation), logEachUltimateTurnBoardState ? legalMoveSituation : null)}");
          }

          if (legalMoveSituation.whitesTurn ==
              situation.whitesTurn) // turn skipped due to no legal moves
          {
            if (logEachUltimateTurn) {
              dev.log(
                  "- SKIPPED Turn #$nextTurn=${situation.whitesTurn ? 'W' : 'B'}");
            }
            nextTurn++; // depth should go down to same Player to compare equally
          }

          /*if (nextTurn > ultimateTurnsDepth)
                            recusiveScore = ScoreBoard(legalMoveBoardState);
                        else // recurse to return resulting minMaxScore after nextTurn*/
          {
            if (nextTurn < ultimateTurnsDepthToStartUsingExpert) {
              recusiveScore = findMinMaxScoreForAllMyLegalMoves(
                  legalMoveSituation, nextTurn); // Ultimate
            } else {
              recusiveScore = findMinMaxScoreForHighestScoringMove(
                  legalMoveSituation, nextTurn); // Expert
            }
          }
        }

        // Log each legalMove's recursiveScore
        if (logEachUltimateTurn) {
          dev.log(
              "- Ultimate LegalMove: #$turn=${logChoice(situation.whitesTurn, legalMove, scoreBoard(legalMoveSituation), null)} recusiveScore=$recusiveScore");
        }

        if (recusiveScore >
            maxRecursiveScore) // is this ultimately the best resulting recusiveScore to bubble-up?
        {
          maxRecursiveScore = recusiveScore;
          //maxRecursiveResponse = legalMove;
          //maxRecursiveResponseSituation = legalMoveSituation;
        }
      }
      return maxRecursiveScore; // ultimately bubble-up the maxRecursiveScore until we figure out which first Move results in the best eventual Board Score
    } else {
      // Opponent's Turn
      // find best Opponent Response using min Board Score
      int minRecursiveScore = ComputerPlayer.maxScore;
      Coord? minRecursiveResponse;
      Situation? minRecursiveResponseSituation;
      for (Coord legalMove in situation.legalMoves) {
        Situation legalMoveSituation = situation.clone();
        legalMoveSituation.placePieceAndFlipPiecesAndChangeTurns(legalMove);

        int responseScore;
        if (legalMoveSituation.endOfGame) {
          responseScore = scoreEndOfGame(legalMoveSituation);
        } else {
          responseScore = scoreBoard(legalMoveSituation);
        }

        // Log each legalMove response
        if (logEachUltimateTurn && logEachUltimateLegalMoveResponse) {
          dev.log(
              "       - Ultimate Opponent LegalMove: #$turn=${logChoice(situation.whitesTurn, legalMove, responseScore, logEachUltimateTurnBoardState ? legalMoveSituation : null)}");
        }

        if (responseScore <
            minRecursiveScore) // opponent's Turn chooses lowest Score for me
        {
          minRecursiveScore = responseScore;
          minRecursiveResponse = legalMove;
          minRecursiveResponseSituation = legalMoveSituation;
        }
      }

      // Log the chosen minMaxResponse
      if (logEachUltimateTurn) {
        dev.log(
            "- Ultimate Opponent's best Response #$turn=${logChoice(situation.whitesTurn, minRecursiveResponse!, minRecursiveScore, logEachUltimateTurnBoardState ? minRecursiveResponseSituation : null)}");
      }

      if (minRecursiveResponseSituation!.endOfGame) {
        return minRecursiveScore;
      }

      /*if (turn >= ultimateTurnsDepth)
                    return minScore;*/

      if (minRecursiveResponseSituation.whitesTurn ==
          situation.whitesTurn) // turn skipped due to no legal moves
      {
        if (logEachUltimateTurn) {
          dev.log(
              "- SKIPPED Turn #$nextTurn=${situation.whitesTurn ? 'W' : 'B'}");
        }
        nextTurn++; // depth should go down to same Player to compare equally
      }

      // recurse to return resulting minMaxScore after nextTurn
      if (nextTurn < ultimateTurnsDepthToStartUsingExpert) {
        return findMinMaxScoreForAllMyLegalMoves(
            minRecursiveResponseSituation, nextTurn);
      } else {
        return findMinMaxScoreForHighestScoringMove(
            minRecursiveResponseSituation, nextTurn);
      }
    }
  }

  @override
  String toString() {
    return "${super.toString()}, depthForEveryMove=$ultimateTurnsDepthToStartUsingExpert";
  }
}
