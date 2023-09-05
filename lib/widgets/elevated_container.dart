import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer(
      {super.key, required this.child, this.radius, this.padding});

  final Widget child;
  final double? radius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
      child: Container(
        padding: padding ?? const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 25))),
        child: child,
      ),
    );
  }
}
