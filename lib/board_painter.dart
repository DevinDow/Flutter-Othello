import 'package:flutter/material.dart';

import 'dart:developer' as dev;

class BoardPainter extends CustomPainter {
  BoardPainter();

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
    canvas.drawCircle(
        Offset(squareSize / 2, squareSize / 2), pieceRadius, blackPaint);
    canvas.drawCircle(
        Offset(squareSize + squareSize / 2, squareSize + squareSize / 2),
        pieceRadius,
        whitePaint);
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => true;
}
