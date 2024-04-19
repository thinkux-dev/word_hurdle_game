import 'package:provider/provider.dart';
import 'package:word_hurdle_game/helper_functions.dart';
import 'package:word_hurdle_game/hurdle_provider.dart';
import 'package:word_hurdle_game/keyboard_view.dart';
import 'package:word_hurdle_game/wordle_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';


class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  final player = AudioPlayer();
  final keypad = AudioPlayer();
  final delete = AudioPlayer();

  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Word Hurdle',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                        final wordle = provider.hurdleBoard[index];
                        return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
              builder: (context, provider, child) => KeyboardView(
                excludedLetters: provider.excludedLetters,
                onPressed: (letter) {
                  provider.inputLetter(letter);
                  keypad.play(AssetSource('coins.wav'), volume: 0.5, );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          provider.deleteLetter();
                          delete.play(AssetSource('delete-4.wav'), volume: 0.5);
                        },
                        child: const Text('DELETE'),
                    ),
                    ElevatedButton(
                      onPressed: provider.isButtonDisabled ? null : () {
                        _handleInput(provider);
                      },
                      child: const Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleInput(HurdleProvider provider) {
    if (!provider.isAValidWord) {
      showsnackbarMsg(context, 'Not a word in my dictionary');
      return;
    }
    if (provider.shouldCheckForAnswer) {
      provider.checkAnswer();
    }
    if (provider.wins) {
      showResult(
        context: context,
        title: 'You Win!!!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
          player.stop();
        },
        onNextLevel: () {},
        onCancel: () {
          Navigator.pop(context);
          player.stop();
        },
      );
      player.play(AssetSource('newCheering.wav'), volume: 1, );

    } else if (provider.noAttemptsLeft) {
      showResult(
        context: context,
        title: 'You Lost!!!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          provider.reset();
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    }
  }
}
