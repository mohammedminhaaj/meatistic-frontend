import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({super.key, required this.headerText});

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
            )),
        Text(
          headerText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
