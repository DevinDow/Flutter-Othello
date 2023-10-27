import 'package:flutter_test/flutter_test.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/ComputerPlayer/computer_player_ultimate.dart';

void main() {
  group("ComputerPlayer tests", () {
    test("Test 1st Move", () {
      Situation situation = Situation();

      expect(situation.blackCount, 2, reason: "start has two of each Color");
      expect(situation.whiteCount, 2, reason: "start has two of each Color");

      ComputerPlayer computerPlayer = ComputerPlayerUltimate(false);
      List<Coord> choices = computerPlayer.findBestChoices(situation);
      expect(choices.length, 4);

      Coord? choice = computerPlayer.chooseNextMove(situation);
      assert(choice != null);
      situation.placePieceAndFlipPiecesAndChangeTurns(choice!);

      expect(situation.blackCount, 4,
          reason: "placed one Black and flipped one White");
      expect(situation.whiteCount, 1, reason: "one White flipped");

      List<Coord> acceptableChoices = List.from({
        Coord(5, 3),
        Coord(6, 4),
        Coord(3, 5),
        Coord(4, 6),
      });
      expect(acceptableChoices.contains(choice), true,
          reason:
              "computerPlayer should choose one of these acceptableChoices");
    });
  });
}
