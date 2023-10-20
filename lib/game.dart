import 'package:flutter/material.dart';

import 'package:othello/board.dart';
import 'package:othello/situation.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Situation situation = Situation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Othello"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                  'Black = ${situation.blackCount}, White = ${situation.whiteCount}',
                  style: Theme.of(context).textTheme.headlineMedium),
              Board(situation: situation, updateGame: updateSituation),
              Text(situation.whitesTurn ? "White's turn" : "Black's Turn",
                  style: Theme.of(context).textTheme.headlineMedium),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: undo,
                    child: const Icon(Icons.undo),
                  ),
                  ElevatedButton(
                    onPressed: showLegalMoves,
                    child: const Icon(Icons.location_on),
                  ),
                  ElevatedButton(
                    onPressed: computer,
                    child: const Icon(Icons.computer),
                  ),
                  ElevatedButton(
                    onPressed: newGame,
                    child: const Icon(Icons.restart_alt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// this callback is passed to Board for updating situation
  void updateSituation(Situation situation) {
    setState(() {
      this.situation = situation;
    });
  }

  void undo() {
    setState(() {
      situation = Situation();
    });
  }

  void showLegalMoves() {
    setState(() {});
  }

  void computer() {}

  void newGame() {
    setState(() {
      situation = Situation();
    });
  }
}
