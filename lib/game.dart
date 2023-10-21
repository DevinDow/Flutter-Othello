import 'package:flutter/material.dart';

import 'package:othello/board.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';

import 'dart:developer' as dev;

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
              Board(situation: situation, makeMoveCallback: makeMove),

              // Turn
              Text(situation.whitesTurn ? "White's turn" : "Black's Turn",
                  style: Theme.of(context).textTheme.headlineMedium),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: previousSituations.isEmpty ? null : undo,
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
                  const ElevatedButton(
                      onPressed: null, //computer,
                      child: Column(children: [
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

  void makeMove(Coord coord) {
    setState(() {
      previousSituations.add(situation.clone());
      situation.placePieceAndFlipPiecesAndChangeTurns(coord);
      dev.log(situation.toString(), name: "new situation");
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
      if (situation.legalMoves.isEmpty) {
        situation.findLegalMoves();
      } else {
        situation.legalMoves = List.empty();
      }
    });
  }

  void computer() {}

  void newGame() {
    setState(() {
      initGame();
    });
  }
}
