import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meatistic/widgets/authentication/authentication_footer.dart';

class PasswordSent extends StatelessWidget {
  const PasswordSent({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/password-sent.png",
                  colorBlendMode: BlendMode.multiply,
                ),
                Text(
                  "A temporary password has been sent to $email. Please use the password for logging in to your account.",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const AuthenticationScreenFooter(),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 700.ms)
              .moveY(duration: 700.ms, begin: -20, end: 0),
        ),
      ),
    );
  }
}
