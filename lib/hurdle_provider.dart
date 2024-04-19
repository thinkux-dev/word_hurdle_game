import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:flutter/material.dart';
import 'package:word_hurdle_game/wordle.dart';

class HurdleProvider extends ChangeNotifier{
  final random = Random.secure();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = '';
  int count = 0;
  int index = 0;
  final lettersPerRow = 5;
  final totalAttempts = 6;
  final totalLevels = 5;
  int attempts = 0;
  int level = 1;
  bool wins = false;
  bool lose = false;

  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  bool get isButtonDisabled => rowInputs.length < lettersPerRow;
  
  //Create a method that runs once when the wordle page is loaded
  init() {
    totalWords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  //Create a generateBoard method and populate the hurdleBoard
  generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  generateRandomWord() {
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAValidWord => totalWords.contains(rowInputs.join('').toLowerCase());

  inputLetter(String letter){
    if(count < lettersPerRow){
      rowInputs.add(letter);
      count++;
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      print(rowInputs);
      notifyListeners();
    }
  }

  deleteLetter(){
    if(rowInputs.isNotEmpty){
      rowInputs.removeAt(rowInputs.length-1);
      // print(rowInputs);
    }
    if(count > 0){
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
    }
    notifyListeners();
  }

  void checkAnswer() {
    final input = rowInputs.join('').toUpperCase();
    if(targetWord == input){
      wins = true;
    } else {
      _markLetterOnBoard();
      //Check if user can go to next roll
      if(attempts < totalAttempts) {
        _goToNextRow();
      }
      // if(attempts == totalAttempts){
      //   lose = true;
      // }
    }
  }

  void _markLetterOnBoard() {
    for(int i = 0; i < hurdleBoard.length; i++){
      if(hurdleBoard[i].letter.isNotEmpty && targetWord.contains(hurdleBoard[i].letter)){
        hurdleBoard[i].existsInTarget = true;
      } else if(hurdleBoard[i].letter.isNotEmpty && !targetWord.contains(hurdleBoard[i].letter)){
        hurdleBoard[i].doesNotExistInTarget = true;
        // add the excluded hurdleBoard[i].letter to the excludedLetters list
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
    notifyListeners();
    print('rowInputs: $rowInputs');
  }

  reset(){
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}