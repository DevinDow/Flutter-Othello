// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'dart:developer' as dev;

class BoardPainter extends CustomPainter {
  // Fields

  // Constants

  // Constructor
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
    double sqaureSize = size.width / 8;
    final gridPaint = Paint()
      ..strokeWidth = 0.0
      ..color = Colors.black;
    for (int i = 1; i <= 7; i++) {
      double offset = sqaureSize * i;
      canvas.drawLine(Offset(0, offset), Offset(boardSize, offset), gridPaint);
      canvas.drawLine(Offset(offset, 0), Offset(offset, boardSize), gridPaint);
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => true;
}
