import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/providers/coupon_provider.dart';
import 'package:meatistic/providers/home_screen_builder_provider.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/screens/login.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/profile_option.dart';
import 'package:meatistic/widgets/profile_option_container.dart';
import 'package:http/http.dart' as http;

class ProfileOptions extends ConsumerWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box<Store> box = Hive.box<Store>("store");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;

    void onClickLogout() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Icon(Icons.question_mark_rounded),
                content: const Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close_rounded),
                          label: const Text("No")),
                      ElevatedButton.icon(
                          onPressed: () {
                            ref
                                .read(homeScreenBuilderProvider.notifier)
                                .setHomeScreenUpdated(false);
                            ref.read(cartProvider.notifier).clearCart();
                            ref
                                .read(userLocationProvider.notifier)
                                .clearSelectedLocation();
                            ref.read(couponProvider.notifier).removeCoupon();
                            store.authToken = "";
                            store.preferredPaymentMode = 0;
                            store.fcmTokenStored = false;
                            box.put("storeObj", store);
                            final url =
                                Uri.https(baseUrl, "/api/user/auth/logout/");
                            http.post(
                              url,
                              headers: getAuthorizationHeaders(authToken),
                            );
                            Navigator.of(context)
                              ..pop()
                              ..pushReplacement(MaterialPageRoute(
                                  builder: (ctx) => const LoginScreen()));
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text("Yes")),
                    ],
                  )
                ],
              ));
    }

    return Column(
      children: [
        ProfileOptionContainer(header: "Account", children: [
          ProfileOption(
            label: "My Reviews",
            icon: Icons.reviews_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "Edit Profile",
            icon: Icons.edit_square,
            onTap: () {},
          ),
        ]),
        ProfileOptionContainer(header: "More", children: [
          ProfileOption(
            label: "App Settings",
            icon: Icons.settings_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "Support",
            icon: Icons.support_agent_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "About Us",
            icon: Icons.stars_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "Logout",
            icon: Icons.logout_rounded,
            onTap: onClickLogout,
            iconColor: Colors.red[400],
          ),
        ]),
      ],
    );
  }
}
