import 'package:flutter/material.dart';

import 'package:othello/board.dart';
import 'package:othello/situation.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Situation situation;
  late List<Situation> previousSituations;

  _GameState() {
    initGame();
  }

  void initGame() {
    situation = Situation();
    previousSituations = List.empty(growable: true);
    previousSituations.add(situation.clone());
  }

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
              // Score
              Text(
                  'Black = ${situation.blackCount}, White = ${situation.whiteCount}',
                  style: Theme.of(context).textTheme.headlineMedium),

              // Board
              Board(situation: situation, updateGame: updateSituation),

              // Turn
              Text(situation.whitesTurn ? "White's turn" : "Black's Turn",
                  style: Theme.of(context).textTheme.headlineMedium),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: undo,
                      child: const Column(children: [
                        Icon(Icons.undo),
                        Text("Undo"),
                      ])),
                  ElevatedButton(
                      onPressed: showLegalMoves,
                      child: const Column(children: [
                        Icon(Icons.location_on),
                        Text("Legal Moves"),
                      ])),
                  ElevatedButton(
                      onPressed: computer,
                      child: const Column(children: [
                        Icon(Icons.computer),
                        Text("Computer"),
                      ])),
                  ElevatedButton(
                      onPressed: newGame,
                      child: const Column(children: [
                        Icon(Icons.restart_alt),
                        Text("New Game"),
                      ])),
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
      previousSituations.add(situation.clone());
    });
  }

  void undo() {
    setState(() {
      if (previousSituations.isNotEmpty) {
        situation = previousSituations.removeLast();
      }
    });
  }

  void showLegalMoves() {
    setState(() {
      situation.findLegalMoves();
    });
  }

  void computer() {}

  void newGame() {
    setState(() {
      initGame();
    });
  }
}
