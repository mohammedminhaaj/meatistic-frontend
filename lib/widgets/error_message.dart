import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: TextStyle(color: Colors.red[800], fontSize: 12),
    );
  }
}
