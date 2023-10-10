import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/utils/input_decoration.dart';
import 'package:meatistic/widgets/authentication/form_error.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Box<Store> box = Hive.box<Store>("store");
  late final String _currentUsername;
  late final String _currentMobile;
  late final String _currentEmail;
  String _username = "";
  String _email = "";
  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  @override
  void initState() {
    final Store store = box.get("storeObj", defaultValue: Store())!;
    _currentEmail = store.userEmail;
    _currentMobile = store.mobileNumber;
    _currentUsername = store.username;
    super.initState();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_username == _currentUsername && _email == _currentEmail) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text("Nothing to update")));
        return;
      }
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = getUri("/api/user/auth/update-profile/");
      final Map<String, String> jsonData = {};
      if (_currentUsername != _username) {
        jsonData.addAll({"username": _username});
      }
      if (_currentEmail != _email) {
        jsonData.addAll({"email": _email});
      }
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      http
          .post(url,
              headers: getAuthorizationHeaders(authToken),
              body: json.encode(jsonData))
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
          if (_currentUsername != _username) {
            store.username = _username;
          }
          if (_currentEmail != _email) {
            store.userEmail = _email;
          }
          box.put("storeObj", store);
          Navigator.of(context).pop();
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(
              content: Text("Something went wrong while updating profile")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _currentMobile,
                  enabled: false,
                  keyboardType: TextInputType.phone,
                  decoration: setInputDecoration(
                      context: context,
                      label: const Text("Mobile Number"),
                      prefixIcon: const Icon(
                        Icons.phone_android_rounded,
                        color: Colors.grey,
                      ),
                      hasError: _errorDict.containsKey("mobile_number")),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Mobile number cannot be modified",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _currentUsername,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 250) {
                      return "Please enter a valid username";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                  decoration: setInputDecoration(
                      context: context,
                      label: const Text("Username"),
                      prefixIcon: const Icon(Icons.person_rounded),
                      hasError: _errorDict.containsKey("email")),
                ),
                if (_errorDict.containsKey("username"))
                  FormError(errors: _errorDict["username"]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _currentEmail,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
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
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                      "Important: Username or Email address cannot be modified after certain limit"),
                ),
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
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(400, 60))),
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
                    label: const Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
