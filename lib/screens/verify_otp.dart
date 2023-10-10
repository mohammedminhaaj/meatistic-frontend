import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatistic/widgets/authentication/authentication_footer.dart';
import 'package:meatistic/widgets/authentication/verify_otp_form.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen(this.mobile, {super.key});

  final String mobile;

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
                  "assets/images/verify-otp.svg",
                  height: 250,
                  width: 250,
                ),
                const Text(
                  "Verify OTP",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 20),
                        children: <TextSpan>[
                          const TextSpan(
                              text: "A one-time password has been sent to "),
                          TextSpan(
                              text: mobile,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 21)),
                        ])),
                VerifyOtpForm(mobile: mobile),
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
