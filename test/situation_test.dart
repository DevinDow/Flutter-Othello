import 'package:flutter_test/flutter_test.dart';
import 'package:othello/situation.dart';

void main() {
  group("Situation tests", () {
    test("Test Situation", () {
      Situation situation = Situation();

      expect(situation.blackCount, 2);
      expect(situation.whiteCount, 2);
    });
  });
}
