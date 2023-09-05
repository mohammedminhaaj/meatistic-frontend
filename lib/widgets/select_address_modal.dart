import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/widgets/add_address.dart';
import 'package:meatistic/widgets/modal_header.dart';
import 'package:meatistic/widgets/saved_address.dart';
import 'package:meatistic/widgets/use_current_location.dart';

class SelectAddressModal extends StatelessWidget {
  const SelectAddressModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModalHeader(headerText: "Select Location"),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const UseCurrentLocation()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pin_drop_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Use my current location",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final UserAddress? currentLocation = ref.read(
                                userLocationProvider
                                    .select((value) => value.currentLocation));
                            return Text(
                              currentLocation != null &&
                                      currentLocation.shortAddress != null
                                  ? currentLocation.shortAddress!
                                  : "Location was not detected",
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                )
              ],
            ),
          ),
          const Divider(
            height: 20,
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddAddress()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Add Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SavedAddress()
        ],
      ),
    );
  }
}
