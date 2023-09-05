import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/widgets/bottom_nav_bar/bottom_nav_bar_item.dart';

class CustomeBottomNavigationBar extends StatelessWidget {
  const CustomeBottomNavigationBar(
      {super.key,
      required this.onMenuSelected,
      required this.currentScreenName});

  final Function(String) onMenuSelected;
  final String currentScreenName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomBottomNavigationBarItem(
                icon: Icons.home_rounded,
                label: "Home",
                isSelected: currentScreenName == "Home",
                onTap: () {
                  onMenuSelected("Home");
                }),
            Consumer(builder: (context, ref, child) {
              final cartLength = ref.watch(cartProvider).length;
              return CustomBottomNavigationBarItem(
                icon: Icons.shopping_cart_rounded,
                label: "Cart",
                isSelected: currentScreenName == "Cart",
                onTap: () {
                  onMenuSelected("Cart");
                },
                useStack: true,
                layer: cartLength == 0
                    ? null
                    : Positioned(
                        right: -6,
                        bottom: -2,
                        child: Container(
                          width: 27,
                          height: 27,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.primary),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            "$cartLength",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              );
            }),
            CustomBottomNavigationBarItem(
              icon: Icons.list_alt_rounded,
              label: "Orders",
              isSelected: currentScreenName == "Orders",
              onTap: () {
                onMenuSelected("Orders");
              },
              useStack: true,
              // layer: Positioned(
              //   right: 0,
              //   bottom: 0,
              //   child: Container(
              //     width: 16,
              //     height: 16,
              //     decoration: BoxDecoration(
              //         color: currentScreenName == "Orders"
              //             ? Colors.white
              //             : Theme.of(context).colorScheme.primary,
              //         borderRadius:
              //             const BorderRadius.all(Radius.circular(50))),
              //   )
              //       .animate(
              //         onPlay: (controller) => controller.loop(period: 3000.ms),
              //       )
              //       .fadeOut(duration: 3000.ms, delay: 3000.ms)
              //       .scaleXY(
              //           begin: 0, end: 1.5, duration: 3000.ms, delay: 3000.ms),
              // ),
            ),
            CustomBottomNavigationBarItem(
                icon: Icons.person_rounded,
                label: "Profile",
                isSelected: currentScreenName == "Profile",
                onTap: () {
                  onMenuSelected("Profile");
                }),
          ],
        ));
  }
}
