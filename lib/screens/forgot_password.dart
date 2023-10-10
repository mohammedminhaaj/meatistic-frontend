import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatistic/widgets/authentication/authentication_footer.dart';
import 'package:meatistic/widgets/authentication/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                SvgPicture.asset(
                  "assets/images/forgot-password.svg",
                  height: 250,
                  width: 250,
                ),
                const Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Please enter the below details to continue.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                const ForgotPasswordForm(),
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
