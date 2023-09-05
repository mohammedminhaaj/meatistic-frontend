import 'package:flutter/material.dart';
import 'package:meatistic/utils/input_decoration.dart';

class MobileOrEmailField extends StatefulWidget {
  const MobileOrEmailField(
      {super.key, required this.setEmailNumber, required this.hasError});

  final void Function(String) setEmailNumber;
  final bool hasError;

  @override
  State<MobileOrEmailField> createState() => _MobileOrEmailFieldState();
}

class _MobileOrEmailFieldState extends State<MobileOrEmailField> {
  final ValueNotifier<IconData> currentIconNotifier =
      ValueNotifier(Icons.phone_android_rounded);
  late final String emailNumber;
  late final String password;

  @override
  void dispose() {
    currentIconNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        final newIcon = value.contains("@")
            ? Icons.email_rounded
            : Icons.phone_android_rounded;
        if (currentIconNotifier.value != newIcon) {
          currentIconNotifier.value = newIcon;
        }
      },
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length < 6 ||
            value.trim().length > 128) {
          return 'Please enter a valid value';
        }
        return null;
      },
      onSaved: (value) {
        widget.setEmailNumber(value!);
      },
      decoration: setInputDecoration(
          context: context,
          label: const Text("Mobile Number or Email"),
          prefixIcon: ValueListenableBuilder<IconData>(
            valueListenable: currentIconNotifier,
            builder: (context, icon, _) {
              return Icon(icon);
            },
          ),
          hasError: widget.hasError),
    );
  }
}
