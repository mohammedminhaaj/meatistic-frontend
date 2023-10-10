import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/screens/landing_page.dart';
import 'package:meatistic/widgets/select_address_modal.dart';

class NoLocation extends ConsumerWidget {
  const NoLocation({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserLocation userLocation = ref.watch(userLocationProvider);

    if (userLocation.currentLocation != null ||
        userLocation.selectedLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LandingPage()));
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/no-location.svg",
              height: 250,
              width: 250,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(errorText),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return const SelectAddressModal();
                      });
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Add Address Manually"))
          ],
        ),
      ),
    );
  }
}
