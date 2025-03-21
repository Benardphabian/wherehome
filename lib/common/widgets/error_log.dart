import 'package:flutter/material.dart';

class ErrorLogText extends StatelessWidget {
  final bool hasProblems;
  final String message;

  const ErrorLogText(
      {super.key, required this.hasProblems, required this.message});

  @override
  Widget build(BuildContext context) {
    return hasProblems
        ? Text(
            message,
            style: const TextStyle(color: Colors.red),
          )
        : const SizedBox();
  }
}

class ErrorLog {
  String errorMessage;
  bool errorEmptyFields;
  bool errorPasswords;

  ErrorLog({
    required this.errorMessage,
    required this.errorEmptyFields,
    required this.errorPasswords,
  });
}
