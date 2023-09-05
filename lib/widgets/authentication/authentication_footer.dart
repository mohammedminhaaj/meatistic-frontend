import 'package:flutter/material.dart';

class AuthenticationScreenFooter extends StatelessWidget {
  const AuthenticationScreenFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: () {}, child: const Text("Trouble signing in?")),
        TextButton(onPressed: () {}, child: const Text("Terms & Conditions")),
        TextButton(onPressed: () {}, child: const Text("Privacy Policy")),
      ],
    );
  }
}
