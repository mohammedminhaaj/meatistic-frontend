import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/widgets/profile_screen_options.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Material(
                elevation: 5,
                borderRadius: const BorderRadius.all(Radius.circular(60)),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      "assets/images/user.svg",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Hello,", style: TextStyle(fontSize: 25)),
                    ValueListenableBuilder<Box>(
                      valueListenable: Hive.box<Store>("store").listenable(),
                      builder: (context, value, child) {
                        final Store store =
                            value.get("storeObj", defaultValue: Store());
                        return Text(
                          store.username,
                          style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.primary),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          const ProfileOptions(),
        ],
      )
          .animate()
          .fadeIn(duration: 700.ms)
          .moveY(duration: 700.ms, begin: -20, end: 0),
    );
  }
}
