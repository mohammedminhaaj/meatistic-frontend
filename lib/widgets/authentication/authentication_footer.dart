import 'package:flutter/material.dart';
import 'package:meatistic/widgets/contact_us.dart';
import 'package:meatistic/screens/privacy_policy.dart';
import 'package:meatistic/screens/terms_and_conditions.dart';

class AuthenticationScreenFooter extends StatelessWidget {
  const AuthenticationScreenFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const ContactUs(),
              );
            },
            child: const Text("Trouble signing in?")),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    forceMaterialTransparency: true,
                    title: const Text("Terms and Conditions"),
                  ),
                  body: const TermsAndConditions(),
                ),
              ));
            },
            child: const Text("Terms & Conditions")),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    forceMaterialTransparency: true,
                    title: const Text("Privacy Policy"),
                  ),
                  body: const PrivacyPolicy(),
                ),
              ));
            },
            child: const Text("Privacy Policy")),
      ],
    );
  }
}
