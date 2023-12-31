import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final bool hasUndos;
  final VoidCallback? undoCallback;
  final VoidCallback? newGameCallback;

  const Buttons({
    super.key,
    required this.hasUndos,
    required this.undoCallback,
    required this.newGameCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: hasUndos ? undoCallback : null,
              child: const Column(children: [
                Icon(Icons.undo),
                Text("Undo"),
              ])),
          ElevatedButton(
              onPressed: newGameCallback,
              child: const Column(children: [
                Icon(Icons.restart_alt),
                Text("New"),
              ])),
        ],
      ),
    );
  }
}
