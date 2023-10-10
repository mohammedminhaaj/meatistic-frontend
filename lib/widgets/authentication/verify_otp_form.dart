import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/screens/landing_page.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/authentication/form_error.dart';
import 'package:meatistic/widgets/authentication/resend_otp_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtpForm extends StatefulWidget {
  const VerifyOtpForm({super.key, required this.mobile});

  final String mobile;

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final Map<int, String> _otp =
      Map.fromIterable(List.generate(6, (index) => index), value: (_) => "");

  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  final Box<Store> box = Hive.box<Store>("store");

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = getUri("/api/user/auth/login/otp/verify/");
      http
          .post(url,
              headers: requestHeader,
              body: json.encode({
                "mobile_number": widget.mobile,
                "otp": _otp.values.join(),
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
        if (response.statusCode >= 400) {
          if (data.containsKey("errors")) {
            setState(() {
              _errorDict = data["errors"];
            });
          }
        } else {
          final Store store = box.get("storeObj", defaultValue: Store())!;
          store.authToken = data["auth_token"];
          store.username = data["username"];
          store.savedAddresses = data["saved_addresses"];
          store.userEmail = data["email"] ?? "";
          store.mobileNumber = data["mobile"];
          if (store.userEmail == "" || store.username == store.mobileNumber) {
            store.showUpdateProfilePopup = true;
          }
          box.put("storeObj", store);
          Navigator.of(context, rootNavigator: true)
            ..pop()
            ..pop()
            ..pushReplacement(
                MaterialPageRoute(builder: (ctx) => const LandingPage()));
        }
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong!")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    height: 54,
                    width: 50,
                    child: TextFormField(
                      autofocus: true,
                      onSaved: (value) {
                        _otp[index] = value!;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index != 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
              ),
              if (_errorDict.containsKey("otp"))
                FormError(errors: _errorDict["otp"]),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Note: By clicking on 'continue', you are agreeing to our terms & conditions and privacy policy.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          isLoading
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(400, 60))),
                  onPressed: isLoading ? null : _submitForm,
                  icon: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.chevron_right_rounded),
                  label: const Text('Continue')),
              const SizedBox(
                height: 20,
              ),
              ResendOtpButton(
                mobile: widget.mobile,
                isDisabledFromParent: isLoading,
              )
            ],
          )),
    );
  }
}
