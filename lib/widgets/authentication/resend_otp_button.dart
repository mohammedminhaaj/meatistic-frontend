import 'package:flutter/material.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/timer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResendOtpButton extends StatefulWidget {
  const ResendOtpButton({
    super.key,
    required this.mobile,
    this.isDisabledFromParent = false,
  });

  final String mobile;
  final bool isDisabledFromParent;

  @override
  State<ResendOtpButton> createState() => _ResendOtpButtonState();
}

class _ResendOtpButtonState extends State<ResendOtpButton> {
  bool _enableButton = false;
  bool isLoading = false;

  void onTimerEnd() {
    setState(() {
      _enableButton = true;
    });
  }

  void _resendOtp() {
    setState(() {
      _enableButton = false;
      isLoading = true;
    });
    final url = Uri.https(baseUrl, "/api/user/auth/login/otp/");
    http
        .post(url,
            headers: requestHeader,
            body: json.encode({
              "mobile_number": widget.mobile,
            }))
        .then((response) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey("details")) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data["details"])));
      }
    }).onError((error, stackTrace) {
      setState(() {
        _enableButton = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something went wrong!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(const Size(400, 60))),
        onPressed:
            _enableButton && !widget.isDisabledFromParent ? _resendOtp : null,
        icon: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            : const Icon(Icons.refresh_rounded),
        label: _enableButton
            ? const Text("Resend")
            : TimerWidget(
                seconds: 180,
                onTimerEnd: onTimerEnd,
                prefixText: "Resend in",
              ));
    // label: const Text('Resend in 180s'));
  }
}
