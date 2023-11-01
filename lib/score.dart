import 'package:flutter/material.dart';

import 'package:othello/situation.dart';

class Score extends StatelessWidget {
  final Situation situation;

  const Score({super.key, required this.situation});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 3, 3),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Text(
            'Black = ${situation.blackCount}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(3, 0, 0, 3),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Text(
            'White = ${situation.whiteCount}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}