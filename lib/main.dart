import 'package:flutter/material.dart';
import 'package:othello/board_painter.dart';

void main() {
  runApp(const OthelloApp());
}

class OthelloApp extends StatelessWidget {
  const OthelloApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Othello"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Black = , White = ',
                  style: Theme.of(context).textTheme.headlineMedium),

              // Canvas
              // - let it expand as tall as Column allows, then make Width the same so it's a square
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: LayoutBuilder(
                    builder: (_, constraints) => SizedBox(
                      width: constraints
                          .maxHeight, // make it a square based on Expanded's Height
                      child: CustomPaint(painter: BoardPainter()),
                    ),
                  ),
                ),
              ),

              Text("Black's Turn",
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }
}
