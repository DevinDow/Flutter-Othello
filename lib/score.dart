import 'package:flutter/material.dart';

import 'package:othello/situation.dart';

class Score extends StatelessWidget {
  final Situation situation;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleGrey =
      const TextStyle(fontSize: 20, color: Colors.grey);

  const Score({super.key, required this.situation});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Score:
        Text("Score: ", style: _textStyle),

        // Black Score
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 3, 3),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Text(
            '${situation.blackCount}',
            style: _textStyleGrey,
          ),
        ),

        // -
        Text(" - ", style: _textStyle),

        // White Score
        Container(
          margin: const EdgeInsets.fromLTRB(3, 0, 0, 3),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          child: Text('${situation.whiteCount}', style: _textStyleGrey),
        ),
      ],
    );
  }
}
