import 'package:flutter/material.dart';
import 'package:meatistic/screens/verify_otp.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/utils/input_decoration.dart';
import 'package:meatistic/widgets/authentication/form_error.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpLoginForm extends StatefulWidget {
  const OtpLoginForm({super.key});

  @override
  State<OtpLoginForm> createState() => _OtpLoginFormState();
}

class _OtpLoginFormState extends State<OtpLoginForm> {
  String _mobile = "";

  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = Uri.https(baseUrl, "/api/user/auth/login/otp/");
      http
          .post(url,
              headers: requestHeader,
              body: json.encode({
                "mobile_number": _mobile,
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
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("OTP sent successfully")));
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => VerifyOtpScreen(_mobile)));
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 10 ||
                      value.trim().length > 10) {
                    return "Please enter a valid mobile number";
                  }
                  return null;
                },
                onSaved: (value) {
                  _mobile = value!;
                },
                keyboardType: TextInputType.phone,
                decoration: setInputDecoration(
                    context: context,
                    label: const Text("Mobile Number"),
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    hasError: _errorDict.containsKey("mobile_number")),
              ),
              if (_errorDict.containsKey("mobile_number"))
                FormError(errors: _errorDict["mobile_number"]),
              const SizedBox(
                height: 20,
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
                      : const Icon(Icons.send_rounded),
                  label: const Text('Send OTP')),
            ],
          )),
    );
  }
}
