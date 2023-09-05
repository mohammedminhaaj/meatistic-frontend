import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/screens/login.dart';
import 'package:meatistic/utils/indicators.dart';

class HeroContent extends StatelessWidget {
  const HeroContent(
      this.screenIndex, this.headerNormal, this.headerBold, this.description,
      {super.key});

  final int screenIndex;
  final String headerNormal;
  final String headerBold;
  final String description;

  @override
  Widget build(BuildContext context) {
    void onContinue() {
      final Box<Store> box = Hive.box<Store>("store");
      final Store store = box.get("storeObj", defaultValue: Store())!;
      store.onboardingCompleted = true;
      box.put("storeObj", store);
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const LoginScreen()));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Animate(
          effects: [FadeEffect(duration: 800.ms), MoveEffect(duration: 800.ms)],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: screenIndex == 1
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            headerNormal,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 25),
                          ),
                          Text(
                            headerBold,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 35,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Text(description),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: screenIndex == 1
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: IndicatorList(
                              length: 3,
                              objectIndex: screenIndex,
                              indicatorColor:
                                  Theme.of(context).colorScheme.primary,
                              isVertical: true)
                          .generate(),
                    )
                  ],
                ),
              ),
              screenIndex != 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Swipe Down',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800),
                        ),
                        Icon(
                          Icons.keyboard_double_arrow_down_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                          weight: 80,
                        )
                      ],
                    )
                      .animate(
                        delay: 3000.ms,
                        onPlay: (controller) => controller.loop(reverse: true),
                      )
                      .fadeIn(delay: 1000.ms)
                      .moveY(
                          begin: 10,
                          end: 0,
                          duration: 1000.ms,
                          curve: Curves.easeInOutCubic)
                  : ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(400, 60))),
                      onPressed: onContinue,
                      child: const Text('Get Started'))
            ],
          ),
        ),
      ),
    );
  }
}
