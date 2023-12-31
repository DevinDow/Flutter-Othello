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

  bool get isComputersTurn => computer.amIWhite ^ !situation.whitesTurn;
  bool get isHumansTurn => !isComputersTurn;

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
    // build each Widget
    Board boardWidget = Board(
      situation: situation,
      drawLegalMoves: isHumansTurn,
      coordClickedCallback: coordClicked,
      flippingFinishedCallback: flippingFinished,
    );
    Turn turnWidget = Turn(situation: situation);
    Score scoreWidget = Score(situation: situation);
    Buttons buttonsWidget = Buttons(
        hasUndos: previousSituations.isNotEmpty,
        undoCallback: undo,
        newGameCallback: newGame);

    // layout the Widgets in Portrait or Lanscape layout
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
            // Portrait vs Landscape for UI Above/Below or on the Side
            child: CustomOrientationBuilder(
                uiWidth: 200,
                uiHeight: 100,
                builder: (context, orientation) {
                  // Portrait mode
                  if (orientation == Orientation.portrait) {
                    // Column of UI & Board
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        turnWidget,
                        scoreWidget,
                        boardWidget,
                        buttonsWidget,
                      ],
                    );
                  } else

                  // Landscape mode
                  {
                    // Row of Board / UI Column
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        boardWidget,

                        // UI Column
                        Container(
                          margin: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              turnWidget,
                              scoreWidget,
                              const Spacer(),
                              buttonsWidget,
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),

          // a Busy Indicator conditionally Stacked on top of UI during Computer's Turn
          (!situation.endOfGame && isComputersTurn)
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

  /// - checks isLegalMove
  /// - adds to previousSituations
  /// - calls makeMove()
  void coordClicked(Coord coord) {
    // not a Legal Move
    if (!situation.isLegalMove(coord)) {
      dev.log("Not a Legal Move!", name: "Game");
      Alert(context, "Not a Legal Move!", "Try again");
      return;
    }

    previousSituations.add(situation);
    situation = situation.clone();
    makeMove(coord);
  }

  void computeMove() {
    Coord? computerChoice = computer.chooseNextMove(situation);
    makeMove(computerChoice!);
  }

  /// - executes a Move
  /// - Alerts for End of Game or Skipped Turn
  /// - triggers ComputerPlayer to chooseNextMove()
  void makeMove(Coord coord) {
    setState(() {
      situation.placePieceAndFlipPiecesAndChangeTurns(coord);
    });
    dev.log(situation.toString(), name: "Game.makeMove()");

    // if Game Over
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
      return;
    }

    // if Skipped Turn
    if (situation.skippedTurn) {
      dev.log("Skipped Turn", name: "Game.makeMove()");
      Alert(context, "Skipped Turn", "There were no Legal Moves available.");
    }

    // if it is now Computer's Turn
    if (isComputersTurn) {
      // let this thread complete while triggering the ComputerPlayer algorithm to choose its next Move
      // start computing after flipping animation duration, because compute otherwise messes up the animation that only lasts 1 sec
      Future.delayed(const Duration(milliseconds: 1200), computeMove);
    }
  }

  /// show Human's Legal Moves after flipping finishes
  void flippingFinished() {
    if (isHumansTurn) {
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
