import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final bool hasUndos;
  final Function undoCallback;
  final Function showLegalMovesCallback;
  final Function newGameCallback;

  const Buttons({
    super.key,
    required this.hasUndos,
    required this.undoCallback,
    required this.showLegalMovesCallback,
    required this.newGameCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed:  ? null : undo,
            child: const Column(children: [
              Icon(Icons.undo),
              Text("Undo"),
            ])),
        ElevatedButton(
            onPressed: showLegalMoves,
            child: const Column(children: [
              Icon(Icons.location_on),
              Text("Moves"),
            ])),
        ElevatedButton(
            onPressed: newGame,
            child: const Column(children: [
              Icon(Icons.restart_alt),
              Text("New"),
            ])),
      ],
    );
  }
}
