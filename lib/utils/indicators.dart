import 'package:flutter/material.dart';

class IndicatorList {
  final int length;
  final int objectIndex;
  final Color indicatorColor;
  final bool isVertical;
  final bool isHorizontal;

  IndicatorList(
      {required this.length,
      required this.objectIndex,
      required this.indicatorColor,
      this.isVertical = false,
      this.isHorizontal = false});

  List<Widget> generate() {
    return List.generate(length, (index) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        width: isHorizontal && objectIndex == index ? 28 : 8,
        height: isVertical && objectIndex == index ? 28 : 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: indicatorColor,
        ),
      );
    });
  }
}
