import 'package:flutter/material.dart';

void showAlertDialog(String title, String message, context) {
  AlertDialog alertDialog =
      AlertDialog(title: Text(title), content: Text(message), actions: [
    TextButton(
      child: const Text("Close"),
      onPressed: () => Navigator.pop(context),
    ),
  ]);
  showDialog(context: context, builder: (_) => alertDialog);
}
