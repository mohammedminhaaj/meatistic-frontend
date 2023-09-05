import 'package:flutter/material.dart';

class QuantityCount extends StatelessWidget {
  const QuantityCount(
      {super.key,
      required this.value,
      this.fontSize,
      this.spacing = 5,
      required this.onIncrement,
      required this.onDecrement,
      this.size,
      this.iconSize,
      this.maxValue = 10,
      this.minValue = 1});

  final int value;
  final Function() onIncrement;
  final Function() onDecrement;
  final double spacing;
  final int minValue;
  final int maxValue;
  final double? fontSize;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: size,
          width: size,
          child: IconButton.filled(
              style: IconButton.styleFrom(
                  shape: const ContinuousRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(25)))),
              onPressed: value <= minValue ? null : onDecrement,
              icon: Icon(
                Icons.remove_rounded,
                size: iconSize,
              )),
        ),
        SizedBox(
          width: spacing * 4,
          child: Text(
            value.toString(),
            style: fontSize != null ? TextStyle(fontSize: fontSize) : null,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: size,
          width: size,
          child: IconButton.filled(
              style: IconButton.styleFrom(
                  shape: const ContinuousRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(25)))),
              onPressed: value >= maxValue ? null : onIncrement,
              icon: Icon(
                Icons.add_rounded,
                size: iconSize,
              )),
        ),
      ],
    );
  }
}
