import 'package:flutter/material.dart';

import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:math' as math;

class BoardPainter extends CustomPainter {
  static double boardSize = 0;
  static double get squareSize => boardSize / 8;
  static double get pieceRadius => 0.4 * squareSize;
  static double get legalMoveRadius => 0.2 * squareSize;

  // Fields
  late final Situation situation;
  late final double flipAngle;

  // Constructor
  BoardPainter(this.situation, this.flipAngle);

  // Overrides
  @override
  void paint(Canvas canvas, Size size) {
    // draw Board
    boardSize = size.width;
    final boardPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.green;
    canvas.drawRect(Rect.fromLTRB(0, 0, boardSize, boardSize), boardPaint);

    // draw Border & Grid
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0
      ..color = Colors.black;
    canvas.drawRect(Rect.fromLTRB(0, 0, boardSize, boardSize), gridPaint);
    for (int i = 1; i <= 7; i++) {
      double offset = squareSize * i;
      canvas.drawLine(Offset(0, offset), Offset(boardSize, offset), gridPaint);
      canvas.drawLine(Offset(offset, 0), Offset(offset, boardSize), gridPaint);
    }

    // draw Pieces
    final blackPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.black;
    final whitePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.white;
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0
      ..color = Colors.red;

    // flippingWidth of oval determined by flipAngle
    double flippingWidth = pieceRadius * math.cos(flipAngle);
    bool useOldColor =
        flipAngle < math.pi / 2; // until it's flipped half way to new Color

    // loop all Squares
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        SquareState squareState = situation.squares[x][y];
        if (squareState == SquareState.empty) {
          continue;
        }

        double xOffset = x * squareSize + squareSize / 2;
        double yOffset = y * squareSize + squareSize / 2;

        Coord coord = Coord(x + 1, y + 1);
        if (situation.coordsFlipped.contains(coord)) {
          Paint paint = (squareState == SquareState.black) ^ useOldColor
              ? blackPaint
              : whitePaint;
          canvas.drawOval(
              Rect.fromLTRB(xOffset - flippingWidth, yOffset - pieceRadius,
                  xOffset + flippingWidth, yOffset + pieceRadius),
              paint);
        } else {
          Paint paint =
              squareState == SquareState.black ? blackPaint : whitePaint;
          canvas.drawCircle(Offset(xOffset, yOffset), pieceRadius, paint);
          if (coord == situation.placedPiece) {
            canvas.drawCircle(
                Offset(xOffset, yOffset), pieceRadius, highlightPaint);
          }
        }
      }
    }

    // draw Legal Moves
    final legalMovePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.red;
    for (Coord coord in situation.legalMoves) {
      double xOffset = (coord.x - 1) * squareSize + squareSize / 2;
      double yOffset = (coord.y - 1) * squareSize + squareSize / 2;
      canvas.drawCircle(
          Offset(xOffset, yOffset), legalMoveRadius, legalMovePaint);
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => true;
}
