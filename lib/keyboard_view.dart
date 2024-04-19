import 'package:flutter/material.dart';

const keysList = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',],
  ['Z', 'X', 'C', 'V', 'B', 'N', 'M',],
];

class KeyboardView extends StatelessWidget {
  final List<String> excludedLetters;
  final Function(String) onPressed;

  const KeyboardView({
    super.key,
    required this.excludedLetters,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:  const EdgeInsets.all(4.0),
        child: Column(
          children: [
            for(int i = 0; i < keysList.length; i++)
              Row(
                children: keysList[i].map((e) => VirtualKey(
                    letter: e,
                    excluded: excludedLetters.contains(e),
                    onPress: (letter) {
                      onPressed(letter);
                    },
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class VirtualKey extends StatelessWidget {
  final String letter;
  final bool excluded;
  final Function(String) onPress;

  const VirtualKey({
    super.key,
    required this.letter,
    required this.excluded,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          onPress(letter);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: excluded ? Colors.red : Colors.black,
          foregroundColor: Colors.white,
          // Remove default text padding to fix text to center of key
          padding: EdgeInsets.zero,
        ),
        child: Text(letter),
      ),
    );
  }
}
