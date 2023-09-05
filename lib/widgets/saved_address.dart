import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/home_screen_builder_provider.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/add_address.dart';
import 'package:http/http.dart' as http;

class SavedAddress extends ConsumerWidget {
  const SavedAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onClickEdit(List<UserAddress> savedAddresses, int index) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddAddress(
          id: savedAddresses[index].id,
          lt: savedAddresses[index].latitude,
          ln: savedAddresses[index].longitude,
          building: savedAddresses[index].building,
          locality: savedAddresses[index].locality,
          landmark: savedAddresses[index].landmark,
        ),
      ));
    }

    void onClickDelete(List<UserAddress> savedAddresses, int index) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Icon(Icons.question_mark_rounded),
                content: const Text(
                  "Are you sure you want to delete this saved address?",
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
                            Navigator.of(context).pop();
                            final Box<Store> box = Hive.box<Store>("store");
                            final Store store =
                                box.get("storeObj", defaultValue: Store())!;
                            final authToken = store.authToken;
                            final Uri url = Uri.https(baseUrl,
                                "/api/user/delete-user-location/${savedAddresses[index].id}/");
                            store.savedAddresses.removeWhere((element) =>
                                element["id"] == savedAddresses[index].id);
                            box.put("storeObj", store);
                            UserAddress? selectedLocation = ref.read(
                                userLocationProvider
                                    .select((value) => value.selectedLocation));
                            if (selectedLocation != null &&
                                savedAddresses[index].id ==
                                    selectedLocation.id) {
                              ref
                                  .read(userLocationProvider.notifier)
                                  .clearSelectedLocation();
                              ref
                                  .read(homeScreenBuilderProvider.notifier)
                                  .setHomeScreenUpdated(false);
                            }
                            http.delete(url,
                                headers: getAuthorizationHeaders(authToken));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Saved Address deleted successfully!")));
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text("Yes")),
                    ],
                  )
                ],
              ));
    }

    void onTapSavedAddress(List<UserAddress> savedAddresses, int index) {
      Navigator.of(context).pop();
      final UserAddress? currentLocation = ref
          .read(userLocationProvider.select((value) => value.currentLocation));
      if (currentLocation == null) {
        ref.read(userLocationProvider.notifier).setBothLocations(
              id: savedAddresses[index].id,
              lt: savedAddresses[index].latitude,
              ln: savedAddresses[index].longitude,
              shortAddress: savedAddresses[index].shortAddress,
              longAddress: savedAddresses[index].longAddress,
              building: savedAddresses[index].building,
              locality: savedAddresses[index].locality,
              landmark: savedAddresses[index].landmark,
            );
      } else {
        ref.read(userLocationProvider.notifier).addUserSelectedLocation(
              id: savedAddresses[index].id,
              lt: savedAddresses[index].latitude,
              ln: savedAddresses[index].longitude,
              shortAddress: savedAddresses[index].shortAddress,
              longAddress: savedAddresses[index].longAddress,
              building: savedAddresses[index].building,
              locality: savedAddresses[index].locality,
              landmark: savedAddresses[index].landmark,
            );
      }

      ref.read(homeScreenBuilderProvider.notifier).setHomeScreenUpdated(false);
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Saved Addresses",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ValueListenableBuilder<Box<Store>>(
                valueListenable: Hive.box<Store>("store").listenable(),
                builder: (context, box, widget) {
                  final Store store =
                      box.get("storeObj", defaultValue: Store())!;
                  final List<dynamic> addresses = store.savedAddresses;
                  final List<UserAddress> savedAddresses =
                      addresses.map((address) {
                    return UserAddress(
                      id: address["id"],
                      latitude: double.parse(address["latitude"]),
                      longitude: double.parse(address["longitude"]),
                      shortAddress: address["short_address"],
                      longAddress: address["long_address"],
                      building: address["building"],
                      locality: address["locality"],
                      landmark: address["landmark"],
                    );
                  }).toList();
                  return savedAddresses.isEmpty
                      ? Align(
                          child: Column(children: [
                            Image.asset(
                              "assets/images/empty.png",
                              colorBlendMode: BlendMode.multiply,
                              height: 250,
                              width: 250,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Nothing to show here.")
                          ]),
                        )
                      : Scrollbar(
                          child: ListView.separated(
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: savedAddresses.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                      onTap: () {
                                        onTapSavedAddress(
                                            savedAddresses, index);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(savedAddresses[index]
                                                .inputAddress),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onPressed: () {
                                            onClickEdit(savedAddresses, index);
                                          },
                                          icon: const Icon(Icons
                                              .edit_location_alt_outlined)),
                                      IconButton(
                                          color: Colors.red[400],
                                          onPressed: () {
                                            onClickDelete(
                                                savedAddresses, index);
                                          },
                                          icon: const Icon(
                                              Icons.delete_outline_rounded))
                                    ],
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              height: 20,
                            ),
                          ),
                        );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
