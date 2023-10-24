import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:developer' as dev;

abstract class ComputerPlayerBasic extends ComputerPlayer {
  static bool logBasicOptions = false;

  ComputerPlayerBasic(bool amIWhite) : super(amIWhite);

  /// <summary>
  /// finds Moves that maximize weighted Score and picks one at random
  /// </summary>
  /// <returns>a Choice that maximizes weighted Score</returns>
  @override
  List<Coord> findBestChoices(Situation situation) {
    int maxScore = -ComputerPlayer.maxScore;
    List<Coord> bestComputerChoices = List<Coord>.empty(growable: true);

    // loop through all of Computer's Legal Moves
    situation.findLegalMoves();
    for (Coord computerChoice in situation.legalMoves) {
      Situation computerSituation = situation.clone();
      computerSituation.placePieceAndFlipPiecesAndChangeTurns(computerChoice);
      int computerChoiceScore = scoreBoard(computerSituation);
      if (logBasicOptions) {
        dev.log(
            "$levelName choice: ${situation.whitesTurn ? 'W' : 'B'}->$computerChoice resulting Score=$computerChoiceScore\nresulting Situation=$situation");
      }

      if (computerChoiceScore >
          maxScore) // remember maxScore and start a new List of Moves that attain it
      {
        maxScore = computerChoiceScore;
        bestComputerChoices = List<Coord>.empty(growable: true);
      }

      if (computerChoiceScore >= maxScore) // add choice to maxScoringChoices
      {
        bestComputerChoices.add(computerChoice);
      }
    }

    return bestComputerChoices;
  }
}
