import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/utils/input_decoration.dart';
import 'package:meatistic/widgets/authentication/form_error.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateProfileModalForm extends ConsumerStatefulWidget {
  const UpdateProfileModalForm({super.key});

  @override
  ConsumerState<UpdateProfileModalForm> createState() =>
      _UpdateProfileModalFormState();
}

class _UpdateProfileModalFormState
    extends ConsumerState<UpdateProfileModalForm> {
  String _username = "";
  String _email = "";
  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final Box<Store> box = Hive.box<Store>("store");

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = getUri("/api/user/auth/update-profile/");
      Map<String, String> jsonData = {"username": _username};
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      if (_email != "") {
        jsonData.addAll({"email": _email});
      }
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
          setState(() {
            if (data.containsKey("errors")) {
              _errorDict = data["errors"];
            } else {
              //Putting error under username field if something goes wrong outside form context
              _errorDict.addAll({
                "username": ["Something went wrong!"]
              });
            }
          });
        } else {
          store.username = _username;
          if (store.userEmail == "" && _email != "") {
            store.userEmail = _email;
          }
          box.put("storeObj", store);
          Navigator.of(context).pop();
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
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final bool showEmailField = store.userEmail == "" ? true : false;
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().length > 255) {
              return 'Please enter a valid username';
            }
            return null;
          },
          onSaved: (value) {
            _username = value!;
          },
          decoration: setInputDecoration(
              context: context,
              label: const Text("Username"),
              prefixIcon: const Icon(Icons.person_4_rounded),
              hasError: _errorDict.containsKey("username")),
        ),
        if (_errorDict.containsKey("username"))
          FormError(errors: _errorDict["username"]),
        Visibility(
          visible: showEmailField,
          child: const SizedBox(
            height: 15,
          ),
        ),
        if (showEmailField)
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
                label: const Text("Email"),
                prefixIcon: const Icon(Icons.email_rounded),
                hasError: _errorDict.containsKey("email")),
          ),
        if (_errorDict.containsKey("email"))
          FormError(errors: _errorDict["email"]),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Maybe Later")),
            ElevatedButton(
              onPressed: _submitForm,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(isLoading
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text("Update"),
            )
          ],
        )
      ]),
    );
  }
}
