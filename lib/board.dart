import 'package:flutter/material.dart';

import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/board_painter.dart';
import 'package:othello/alert.dart';

import 'dart:developer' as dev;

class Board extends StatefulWidget {
  final Situation situation;
  final Function makeMoveCallback;
  static bool logBoardBuildSituation = false;

  const Board(
      {super.key, required this.situation, required this.makeMoveCallback});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    if (Board.logBoardBuildSituation) {
      dev.log("situation = ${widget.situation}", name: "Board.build()");
    }

    return Expanded(
      // let it expand as tall as Column allows, then make Width the same so it's a square
      child: LayoutBuilder(
        builder: (_, constraints) => SizedBox(
          width: constraints
              .maxHeight, // make it a square based on Expanded's Height
          child: GestureDetector(
            onTapDown: (details) => _onTapDown(details, context),
            child:
                CustomPaint(painter: BoardPainter(situation: widget.situation)),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details, BuildContext context) {
    if (widget.situation.endOfGame) {
      Alert(context, "Game Over", "press New Game to play again");
      return;
    }

    if (widget.situation.whitesTurn) {
      Alert(context, "Computer's Turn", "Computer algorithm is thinking");
      return;
    }

    Offset pos = details.localPosition;
    dev.log("Tapped at $pos", name: "Board");

    // calculate Coord
    int x = (pos.dx / BoardPainter.squareSize).floor();
    int y = (pos.dy / BoardPainter.squareSize).floor();
    Coord coord = Coord(x + 1, y + 1);
    dev.log("Tapped at coord $coord", name: "Board");

    // make Move
    widget.makeMoveCallback(coord);
  }
}
