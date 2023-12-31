import 'package:flutter/material.dart';

import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/board_painter.dart';
import 'package:othello/alert.dart';

import 'dart:math' as math;
import 'dart:developer' as dev;

class Board extends StatefulWidget {
  final Situation situation;
  final bool drawLegalMoves;
  final Function coordClickedCallback;
  final Function flippingFinishedCallback;
  static bool logBoardBuildSituation = false;

  const Board(
      {super.key,
      required this.situation,
      required this.drawLegalMoves,
      required this.coordClickedCallback,
      required this.flippingFinishedCallback});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    Tween<double> rotationTween = Tween(begin: 0, end: math.pi);
    animation = rotationTween.animate(controller)
      // called every time that the status changes
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.situation.animationFinished = true;
          widget.flippingFinishedCallback();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Board.logBoardBuildSituation) {
      dev.log("situation = ${widget.situation}", name: "Board.build()");
    }

    // start the Animation
    if (widget.situation.coordsFlipped.isNotEmpty &&
        widget.situation.startAnimation) {
      controller.reset();
      controller.forward();
      widget.situation.startAnimation = false;
      widget.situation.animationFinished = false;
    }

    // let Board Expand up to as tall/wide as Column/Row allows,
    // then make Width & Height the same (square) using the smaller of Flexible's maxWidth & maxHeight
    return Flexible(
      child: LayoutBuilder(
        builder: (_, constraints) => SizedBox(
          width: math.min(constraints.maxWidth, constraints.maxHeight),
          height: math.min(constraints.maxWidth, constraints.maxHeight),
          // GestureDetector
          child: GestureDetector(
            onTapDown: (details) => _onTapDown(details, context),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, snapshot) {
                // CustomPaint using BoardPainter
                return CustomPaint(
                    painter: BoardPainter(widget.situation,
                        widget.drawLegalMoves, animation.value));
              },
            ),
          ),
        ),
      ),
    );
  }

  /// User clicked the Board
  /// figure out which Coord and call Game's makeMoveCallback()
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
    widget.coordClickedCallback(coord);
  }
}
