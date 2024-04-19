class Wordle {
  String letter;
  bool existsInTarget;
  bool doesNotExistInTarget;

  Wordle({
    required this.letter,
    this.existsInTarget = false,
    this.doesNotExistInTarget = false,
  });
}