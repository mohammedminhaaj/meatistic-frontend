import 'package:flutter/material.dart';
import 'package:meatistic/utils/indicators.dart';

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator(this.carouselIndex, this.carouselLength, {super.key});

  final int carouselIndex;
  final int carouselLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: IndicatorList(
                length: carouselLength,
                objectIndex: carouselIndex,
                indicatorColor: Theme.of(context).colorScheme.primary,
                isHorizontal: true)
            .generate(),
      ),
    );
  }
}
