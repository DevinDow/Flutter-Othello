import 'package:flutter/material.dart';

import 'package:othello/situation.dart';

class Turn extends StatelessWidget {
  final Situation situation;

  const Turn({super.key, required this.situation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
        color: situation.whitesTurn ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Text(
        situation.whitesTurn ? "White's turn" : "Black's Turn",
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
    );
  }
}
