import 'package:flutter/material.dart';

import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/board_painter.dart';

import 'dart:developer' as dev;

class Board extends StatefulWidget {
  const Board({super.key, required this.situation, required this.updateGame});

  final Situation situation;
  final Function updateGame;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    dev.log("situation = ${widget.situation}", name: "Board");

    return Expanded(
      // let it expand as tall as Column allows, then make Width the same so it's a square
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: LayoutBuilder(
          builder: (_, constraints) => SizedBox(
            width: constraints
                .maxHeight, // make it a square based on Expanded's Height
            child: GestureDetector(
              onTapDown: (details) => _onTapDown(details),
              child: CustomPaint(
                  painter: BoardPainter(situation: widget.situation)),
            ),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    Offset pos = details.localPosition;
    dev.log("Tapped at $pos", name: "Board");
    int x = (pos.dx / BoardPainter.squareSize).floor();
    int y = (pos.dy / BoardPainter.squareSize).floor();
    Coord coord = Coord(x + 1, y + 1);
    dev.log("Tapped at coord $coord", name: "Board");
    setState(() {
      widget.situation.placePieceAndFlipPiecesAndChangeTurns(coord);

      // callback to update Game's Situation
      widget.updateGame(widget.situation);
    });
  }
}
