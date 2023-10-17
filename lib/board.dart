import 'package:flutter/material.dart';
import 'package:othello/board_painter.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Expanded(
      // let it expand as tall as Column allows, then make Width the same so it's a square
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: LayoutBuilder(
          builder: (_, constraints) => SizedBox(
            width: constraints
                .maxHeight, // make it a square based on Expanded's Height
            child: CustomPaint(painter: BoardPainter()),
          ),
        ),
      ),
    );
  }
}
