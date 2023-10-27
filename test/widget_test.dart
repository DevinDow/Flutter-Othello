// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:othello/main.dart';
//import 'package:othello/board.dart';

void main() {
  testWidgets("Black's Turn, Score = 2-2", (WidgetTester tester) async {
    // build our app and trigger a frame
    await tester.pumpWidget(const OthelloApp());

    // find expected text
    expect(find.text("Black's Turn"), findsOneWidget);
    expect(find.text('Black = 2, White = 2'), findsOneWidget);

    /*
    await tester.tap(find.byType(Board)); // taps Center of Board
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('2'), findsNWidgets(2));*/
  });
}
