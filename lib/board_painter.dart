import 'package:flutter/material.dart';

import 'package:othello/situation.dart';

import 'dart:developer' as dev;

class BoardPainter extends CustomPainter {
  late final Situation situation;

  BoardPainter({required this.situation});

  @override
  void paint(Canvas canvas, Size size) {
    // draw Board
    double boardSize = size.width;
    final boardPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.green;
    canvas.drawRect(Rect.fromLTRB(0, 0, boardSize, boardSize), boardPaint);

    // draw Grid
    double squareSize = size.width / 8;
    final gridPaint = Paint()
      ..strokeWidth = 0.0
      ..color = Colors.black;
    for (int i = 1; i <= 7; i++) {
      double offset = squareSize * i;
      canvas.drawLine(Offset(0, offset), Offset(boardSize, offset), gridPaint);
      canvas.drawLine(Offset(offset, 0), Offset(offset, boardSize), gridPaint);
    }

    // draw Pieces
    double pieceRadius = 0.4 * squareSize;
    final blackPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.black;
    final whitePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.white;

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        SquareState squareState = situation.squares[x][y];
        if (squareState == SquareState.empty) {
          continue;
        }

        double xOffset = x * squareSize + squareSize / 2;
        double yOffset = y * squareSize + squareSize / 2;
        Paint paint =
            squareState == SquareState.black ? blackPaint : whitePaint;
        canvas.drawCircle(Offset(xOffset, yOffset), pieceRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => true;
}
