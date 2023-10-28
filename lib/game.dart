import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:othello/board.dart';
import 'package:othello/coord.dart';
import 'package:othello/situation.dart';
import 'package:othello/ComputerPlayer/computer_player.dart';
import 'package:othello/ComputerPlayer/computer_player_ultimate.dart';
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

  ComputerPlayer computer = ComputerPlayerUltimate(true,
      depthForEveryMove: 6, depthForOnlyBestMove: 11);

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
        // Stack of UI with Progress on top
        child: Stack(children: [
          Center(
            child: Column(
              children: <Widget>[
                // Score
                Text(
                    'Black = ${situation.blackCount}, White = ${situation.whiteCount}',
                    style: Theme.of(context).textTheme.headlineMedium),

                // Board
                Board(situation: situation, makeMoveCallback: makeUserMove),

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

          // a Busy Indicator conditionally Stacked on top of UI during Computer's Turn
          (!situation.endOfGame && (computer.amIWhite ^ !situation.whitesTurn))
              ? Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }

  /// adds to previousSituations before calling makeMove()
  void makeUserMove(Coord coord) {
    // not a Legal Move
    if (!situation.isLegalMove(coord)) {
      dev.log("Not a Legal Move!", name: "Board");
      Alert(context, "Not a Legal Move!", "Try again");
      showLegalMoves();
      return;
    }

    previousSituations.add(situation);
    situation = situation.clone();
    makeMove(coord);
  }

  /// compute the next Move for ComputerPlayer then execute it
  void makeComputerMove() {
    Coord? choice = computer.chooseNextMove(situation);
    if (choice != null) {
      makeMove(choice);
    }
  }

  /// executes a Move, Alerts for Skipped Turn or End of Game, triggers ComputerPlayer to chooseNextMove()
  void makeMove(Coord coord) {
    setState(() {
      situation.placePieceAndFlipPiecesAndChangeTurns(coord);
      dev.log(situation.toString(), name: "Game.makeMove()");

      // Game Over
      if (situation.endOfGame) {
        dev.log("End of Game", name: "Game.makeMove()");
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
        dev.log("Skipped Turn", name: "Game.makeMove()");
        Alert(context, "Skipped Turn", "There were no Legal Moves available.");
      }
    });

    // if it is now Computer's Turn
    if (computer.amIWhite ^ !situation.whitesTurn) {
      // let this thread complete while triggering the ComputerPlayer algorithm to choose its next Move
      Future.delayed(const Duration(seconds: 1), makeComputerMove);
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
