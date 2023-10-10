import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatistic/screens/otp_login.dart';
import 'package:meatistic/widgets/authentication/authentication_footer.dart';
import 'package:meatistic/widgets/authentication/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/login.svg",
                  width: 250,
                  height: 250,
                ),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                ),
                const Text(
                  "Please login using your credentials.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                const LoginForm(),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton.icon(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(400, 60))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const OtpLoginScreen()));
                    },
                    icon: const Icon(Icons.sms_rounded),
                    label: const Text('Login using OTP')),
                const SizedBox(
                  height: 20,
                ),
                const AuthenticationScreenFooter(),
              ],
            ),
          ),
        ),
      ))
          .animate()
          .fadeIn(duration: 700.ms)
          .moveY(duration: 700.ms, begin: -20, end: 0),
    );
  }
}
