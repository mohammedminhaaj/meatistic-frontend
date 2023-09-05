import 'package:flutter/material.dart';

InputDecoration setInputDecoration(
    {required BuildContext context,
    required Text label,
    required Widget prefixIcon,
    required bool hasError}) {
  return InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          borderSide: hasError
              ? BorderSide(color: Colors.red[800]!, width: 2.0)
              : const BorderSide(width: 2.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          borderSide: hasError
              ? BorderSide(color: Colors.red[800]!)
              : const BorderSide()),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      label: label,
      labelStyle:
          TextStyle(fontSize: 15, color: hasError ? Colors.red[800] : null),
      floatingLabelStyle:
          TextStyle(fontSize: 20, color: hasError ? Colors.red[800] : null),
      prefixIcon: prefixIcon,
      prefixIconColor: Theme.of(context).colorScheme.primary);
}
