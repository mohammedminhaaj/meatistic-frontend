import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/providers/home_screen_builder_provider.dart';
import 'package:meatistic/screens/landing_page.dart';

class OrderPlaced extends ConsumerWidget {
  const OrderPlaced({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(3000.ms, () {
      ref.read(homeScreenBuilderProvider.notifier).setPendingOrders(true);
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const LandingPage(
                  redirectTo: "Orders",
                )), // Replace NextPage with the desired destination page
      );
    });

    return Scaffold(
      backgroundColor: Colors.green[400],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 100,
            color: Colors.white,
          ).animate().scaleXY(curve: Curves.bounceOut, duration: 1.seconds),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Order Placed",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          )
              .animate()
              .fadeIn(duration: 700.ms)
              .moveY(begin: 30, end: 0, duration: 700.ms)
        ],
      )),
    );
  }
}
