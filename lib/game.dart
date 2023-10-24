import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:othello/board.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/ComputerPlayer/computer_player_expert.dart';
import 'package:othello/alert.dart';

import 'dart:developer' as dev;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Situation situation;
  late List<Situation> previousSituations;

  ComputerPlayer computer = ComputerPlayerExpert(true);

  _GameState() {
    initGame();
  }

  /// reset to starting Game State
  void initGame() {
    situation = Situation();
    previousSituations = List.empty(growable: true);
  }

  /// for handling Keyboard
  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKeyEvent);
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
                  /*const ElevatedButton(
                      onPressed: null, //computer,
                      child: Column(children: [
                        Icon(Icons.computer),
                        Text("Computer"),
                      ])),*/
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

      // Game Over
      if (situation.endOfGame) {
        dev.log("End of Game", name: "Game");
        int blackCount = situation.blackCount;
        int whiteCount = situation.whiteCount;
        String message;
        if (blackCount > whiteCount) {
          message = "Black won $blackCount - $whiteCount";
        } else if (whiteCount > blackCount) {
          message = "White won $whiteCount - $blackCount";
        } else {
          message = "Tie $blackCount - $whiteCount";
        }
        Alert(context, "Game Over", message);
      }

      // Skipped Turn
      else if (situation.skippedTurn) {
        dev.log("Skipped Turn", name: "Game");
        Alert(context, "Skipped Turn", "There were no Legal Moves available.");
      }
    });

    if (computer.amIWhite ^ !situation.whitesTurn) {
      Coord? computerChoice = computer.chooseNextMove(situation);
      if (computerChoice != null) {
        makeMove(computerChoice);
      }
    }
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

  void opponent() {}

  void newGame() {
    setState(() {
      initGame();
    });
  }

  bool _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      switch (key) {
        case "F1":
        case "L":
          showLegalMoves();
          return true;
        case "Backspace":
        case "U":
          undo();
          return true;
      }
    }

    return false;
  }
}
