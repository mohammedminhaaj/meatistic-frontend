import 'package:flutter/material.dart';

class ProfileOptionContainer extends StatelessWidget {
  const ProfileOptionContainer(
      {super.key, required this.header, required this.children});

  final String header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          header,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        for (final child in children) child
      ]),
    );
  }
}
