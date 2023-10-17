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
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = Colors.green;

    //canvas.translate(size.width / 2, size.height); // Origin at floor-center
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) => true;
}
