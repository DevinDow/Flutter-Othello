import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:othello/situation.dart';
import 'package:othello/coord.dart';
import 'package:othello/board.dart';
import 'package:othello/custom_orientation_builder.dart';
import 'package:othello/score.dart';
import 'package:othello/turn.dart';
import 'package:othello/buttons.dart';
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
    situation.findLegalMoves();
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
      body: SafeArea(
        // Stack of UI with conditional Busy Indicator on top
        child: Stack(children: [
          // grey padded Container for UI
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            // Portrait vs Landscape
            child: CustomOrientationBuilder(
                uiWidth: 200,
                uiHeight: 50,
                builder: (context, orientation) {
                  // Portrait mode
                  if (orientation == Orientation.portrait) {
                    // Column of Board + UI
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Score
                        Score(situation: situation),

                        // Turn
                        Turn(situation: situation),

                        // Board
                        Board(
                            situation: situation,
                            makeMoveCallback: makeUserMove),

                        // Buttons
                        Buttons(
                            hasUndos: previousSituations.isNotEmpty,
                            undoCallback: undo,
                            showLegalMovesCallback: showLegalMoves,
                            newGameCallback: newGame),
                      ],
                    );
                  } else

                  // Landscape mode
                  {
                    // Row of Board + UI
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Board
                        Board(
                            situation: situation,
                            makeMoveCallback: makeUserMove),

                        // UI Column
                        Container(
                          margin: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Score
                              Score(situation: situation),

                              // Turn
                              Turn(situation: situation),

                              const Spacer(),

                              // Buttons
                              Buttons(
                                  hasUndos: previousSituations.isNotEmpty,
                                  undoCallback: undo,
                                  showLegalMovesCallback: showLegalMoves,
                                  newGameCallback: newGame),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
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
    } else {
      setState(() {
        situation.findLegalMoves();
      });
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

  void newGame() {
    setState(() {
      initGame();
    });
  }

  bool _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      switch (key) {
        case "Backspace":
        case "U":
          undo();
          return true;
        case "N":
          newGame();
          return true;
      }
    }

    return false;
  }
}
