import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/screens/landing_page.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/utils/input_decoration.dart';
import 'package:meatistic/widgets/authentication/form_error.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _mobile = "";
  String _email = "";
  String _password = "";
  String _passwordToMatch = "";
  String _confirmPassword = "";
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
      final url = getUri("/api/user/auth/sign-up/");
      http
          .post(url,
              headers: requestHeader,
              body: json.encode({
                "mobile_number": _mobile,
                "email": _email,
                "password": _password,
                "confirm_password": _confirmPassword,
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
          if (store.username == store.mobileNumber) {
            store.showUpdateProfilePopup = true;
          }
          box.put("storeObj", store);
          Navigator.of(context, rootNavigator: true)
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
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: setInputDecoration(
                    context: context,
                    label: const Text("Email Address"),
                    prefixIcon: const Icon(Icons.email_rounded),
                    hasError: _errorDict.containsKey("email")),
              ),
              if (_errorDict.containsKey("email"))
                FormError(errors: _errorDict["email"]),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 6 ||
                      value.trim().length > 128) {
                    return 'Please enter a valid 6 character password';
                  }
                  _passwordToMatch = value;
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: setInputDecoration(
                    context: context,
                    label: const Text("Password"),
                    prefixIcon: const Icon(Icons.lock_rounded),
                    hasError: _errorDict.containsKey("password")),
              ),
              if (_errorDict.containsKey("password"))
                FormError(errors: _errorDict["password"]),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 6 ||
                      value.trim().length > 128) {
                    return 'Please enter a valid 6 characters password';
                  }
                  if (_passwordToMatch != value) {
                    return "Passwords don't match";
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value!;
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: setInputDecoration(
                    context: context,
                    label: const Text("Confirm Password"),
                    prefixIcon: const Icon(Icons.lock_rounded),
                    hasError: _errorDict.containsKey("confirm_password")),
              ),
              if (_errorDict.containsKey("confirm_password"))
                FormError(errors: _errorDict["confirm_password"]),
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
            ],
          )),
    );
  }
}
