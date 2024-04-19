// import 'dart:html';

import 'package:flutter/material.dart';

void showsnackbarMsg(BuildContext context, String msg) =>
    ScaffoldMessenger
        .of(context)
        .showSnackBar(SnackBar(content: Text(msg)));

void showResult({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onPlayAgain,
  required VoidCallback onCancel,
  VoidCallback ?onNextLevel,
}) {
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [
      TextButton(
        onPressed: onCancel,
        child: const Text('Quit'),
      ),
      TextButton(
        onPressed: onPlayAgain,
        child: const Text('PLAY AGAIN'),
      ),
      TextButton(
        onPressed: onNextLevel,
        child: const Text('NEXT LEVEL'),
      ),
    ],
  ));
}