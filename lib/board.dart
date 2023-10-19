import 'package:flutter/material.dart';

import 'package:othello/situation.dart';
import 'package:othello/board_painter.dart';

import 'dart:developer' as dev;

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Situation situation = Situation();

  @override
  Widget build(BuildContext context) {
    dev.log("situation = $situation", name: "Board");
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

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
              child: CustomPaint(painter: BoardPainter(situation: situation)),
            ),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    Offset pos = details.localPosition;
    dev.log("Tapped at $pos", name: "Board");
  }
}
