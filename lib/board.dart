import 'package:flutter/material.dart';

import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/board_painter.dart';
import 'package:othello/alert.dart';

import 'dart:developer' as dev;

class Board extends StatelessWidget {
  const Board(
      {super.key, required this.situation, required this.makeMoveCallback});

  final Situation situation;
  final Function makeMoveCallback;

  @override
  Widget build(BuildContext context) {
    dev.log("situation = $situation", name: "Board");

    return Expanded(
      // let it expand as tall as Column allows, then make Width the same so it's a square
      child: LayoutBuilder(
        builder: (_, constraints) => SizedBox(
          width: constraints
              .maxHeight, // make it a square based on Expanded's Height
          child: GestureDetector(
            onTapDown: (details) => _onTapDown(details, context),
            child: CustomPaint(painter: BoardPainter(situation: situation)),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details, BuildContext context) {
    if (situation.endOfGame) {
      Alert(context, "Game Over", "press New Game to play again");
      return;
    }

    Offset pos = details.localPosition;
    dev.log("Tapped at $pos", name: "Board");

    // calculate Coord
    int x = (pos.dx / BoardPainter.squareSize).floor();
    int y = (pos.dy / BoardPainter.squareSize).floor();
    Coord coord = Coord(x + 1, y + 1);
    dev.log("Tapped at coord $coord", name: "Board");

    // not a Legal Move
    if (!situation.isLegalMove(coord)) {
      dev.log("Not a Legal Move!", name: "Board");
      Alert(context, "Not a Legal Move!", "Try again");
      return;
    }

    // make Move
    makeMoveCallback(coord);
  }
}
