import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:meatistic/models/home_screen_builder.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/providers/home_screen_builder_provider.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/screens/filter_product.dart';
import 'package:meatistic/screens/product_categories.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/utils/location_services.dart';
import 'package:meatistic/widgets/carousel.dart';
import 'package:meatistic/widgets/category_card.dart';
import 'package:meatistic/widgets/home_screen_section.dart';
import 'package:meatistic/screens/no_location.dart';
import 'package:meatistic/widgets/product_card.dart';
import 'package:meatistic/widgets/sort_menu.dart';
import 'package:meatistic/widgets/update_profile_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/widgets/vendor_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Box<Store> box = Hive.box<Store>("store");
  bool isLoading = false;

  List<String> _decodeCarouselData(List<dynamic> json) {
    return json.map((value) => value["banner"] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool homeScreenUpdated = ref.watch(
        homeScreenBuilderProvider.select((value) => value.homeScreenUpdated));
    final HomeScreenBuilder homeScreenData =
        ref.read(homeScreenBuilderProvider);
    final List<dynamic> allProducts = homeScreenData.allProducts;
    final List<dynamic> categories = homeScreenData.categories;
    final List<dynamic> nearbyVendors = homeScreenData.nearbyVendors;
    final List<dynamic> featuredProducts = homeScreenData.featuredProducts;
    final List<dynamic> topSelling = homeScreenData.topSelling;
    final List<dynamic> topRated = homeScreenData.topRated;
    final UserLocation userLocation = ref.watch(userLocationProvider);
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String token = store.authToken;
    final bool showUpdateProfilePopup = store.showUpdateProfilePopup;

    if (!homeScreenUpdated && token != "") {
      setState(() {
        isLoading = true;
      });
      if (userLocation.currentLocation == null) {
        getCurrentLocation().then((value) {
          if (!value["serviceEnabled"]) {
            //Redirect the user if the service is not enabled
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) => const NoLocation(
                    errorText:
                        "Looks like location service isn't available on your device.")));
          } else if (value["permissionGranted"] != PermissionStatus.granted) {
            //Redirect the user is the permissions are not provided
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) => const NoLocation(
                    errorText:
                        "Please provide location permission on this device")));
          } else {
            final url = Uri.https(baseUrl, "/api/common/get-home-screen/", {
              'lt': (userLocation.selectedLocation?.latitude ??
                      userLocation.currentLocation?.latitude ??
                      value["location"].latitude)
                  .toString(),
              'ln': (userLocation.selectedLocation?.longitude ??
                      userLocation.currentLocation?.longitude ??
                      value["location"].longitude)
                  .toString()
            });
            //get initial home screen data
            http
                .get(url, headers: getAuthorizationHeaders(token))
                .then((response) {
              //check if the response has any errors
              if (response.statusCode >= 400) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Something went wrong!")));
              } else {
                final data = json.decode(response.body);

                //Update home screen state
                ref.read(homeScreenBuilderProvider.notifier).updateHomeScreen(
                    true,
                    _decodeCarouselData(data["banner_images"]),
                    data["all_products"],
                    data["categories"],
                    data["nearby_vendors"],
                    data["featured_products"],
                    data["top_selling"],
                    data["top_rated"]);
                //Update cart list
                ref.read(cartProvider.notifier).generateCartList(data["cart"]);

                //get the address values by using the generated latitude and longitude
                getAddress(
                        value["location"].latitude, value["location"].longitude)
                    .then((response) {
                  //add current location
                  ref
                      .read(userLocationProvider.notifier)
                      .addUserCurrentLocation(
                        lt: value["location"].latitude,
                        ln: value["location"].longitude,
                        shortAddress: response["shortAddress"],
                        longAddress: response["longAddress"],
                      );
                  //Check if any of the saved locations are close to the current location
                  ref.read(userLocationProvider.notifier).setSelectedLocation(
                      getUserAddressWithinRadius(UserAddress(
                          latitude: value["location"].latitude,
                          longitude: value["location"].longitude)));
                });
                setState(() {
                  isLoading = false;
                });
              }
            }).onError((error, stackTrace) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Something went wrong!")));
            });
          }
        });
      } else {
        final url = Uri.https(baseUrl, "/api/common/get-home-screen/", {
          'lt': (userLocation.selectedLocation?.latitude ??
                  userLocation.currentLocation?.latitude)
              .toString(),
          'ln': (userLocation.selectedLocation?.longitude ??
                  userLocation.currentLocation?.longitude)
              .toString()
        });
        http.get(url, headers: getAuthorizationHeaders(token)).then((response) {
          if (response.statusCode >= 400) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Something went wrong!")));
          } else {
            final data = json.decode(response.body);
            ref.read(homeScreenBuilderProvider.notifier).updateHomeScreen(
                true,
                _decodeCarouselData(data["banner_images"]),
                data["all_products"],
                data["categories"],
                data["nearby_vendors"],
                data["featured_products"],
                data["top_selling"],
                data["top_rated"]);
            ref.read(cartProvider.notifier).generateCartList(data["cart"]);

            setState(() {
              isLoading = false;
            });
          }
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        });
      }
    }

    if (showUpdateProfilePopup) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return const UpdateProfileModal();
            });
        store.showUpdateProfilePopup = false;
        box.put("storeObj", store);
      });
    }
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          ref
              .read(homeScreenBuilderProvider.notifier)
              .setHomeScreenUpdated(false);
        });
      },
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: nearbyVendors.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/no-service.png"),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Vendors near your selected location are either closed or not available. Please come back later.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ]
                    : [
                        const Carousel(),
                        const SortMenu(),
                        HomeScreenSection(
                          header: "Categories",
                          onViewAll: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ProductCategories()));
                          },
                          child: SizedBox(
                            height: 120,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: categories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final Map<String, dynamic> currentCategory =
                                    categories[index];

                                return CategoryCard(
                                  image: currentCategory["image"],
                                  name: currentCategory["display_name"],
                                );
                              },
                            ),
                          ),
                        ),
                        HomeScreenSection(
                            header: "Nearby Vendors",
                            onViewAll: () {},
                            child: SizedBox(
                              height: 130,
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        width: 20,
                                      ),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: nearbyVendors.length,
                                  itemBuilder: (context, index) {
                                    final Map<String, dynamic> currentVendor =
                                        nearbyVendors[index];
                                    return VendorCard(
                                      index: index,
                                      name: currentVendor["display_name"],
                                      rating: currentVendor["rating"],
                                      distance: currentVendor["distance"],
                                    );
                                  }),
                            )),
                        if (featuredProducts.isNotEmpty)
                          HomeScreenSection(
                            header: "Featured",
                            onViewAll: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const FilterProduct(
                                        filterQuery: 'is_featured',
                                      )));
                            },
                            child: SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: featuredProducts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    final Map<String, dynamic> currentProduct =
                                        featuredProducts[index];

                                    return ProductCard(
                                        image: currentProduct["image"],
                                        name: currentProduct["name"],
                                        displayName:
                                            currentProduct["display_name"],
                                        quantity: currentProduct["quantity"],
                                        price: currentProduct["price"],
                                        rating: currentProduct["rating"],
                                        originalPrice:
                                            currentProduct["original_price"]);
                                  }),
                            ),
                          ),
                        if (topSelling.isNotEmpty)
                          HomeScreenSection(
                            header: "Top Selling",
                            onViewAll: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const FilterProduct(
                                        filterQuery: 'top_selling',
                                      )));
                            },
                            child: SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: topSelling.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    final Map<String, dynamic> currentProduct =
                                        topSelling[index];

                                    return ProductCard(
                                        image: currentProduct["image"],
                                        name: currentProduct["name"],
                                        displayName:
                                            currentProduct["display_name"],
                                        quantity: currentProduct["quantity"],
                                        price: currentProduct["price"],
                                        rating: currentProduct["rating"],
                                        originalPrice:
                                            currentProduct["original_price"]);
                                  }),
                            ),
                          ),
                        if (topRated.isNotEmpty)
                          HomeScreenSection(
                            header: "Top Rated",
                            onViewAll: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const FilterProduct(
                                        filterQuery: 'top_rated',
                                      )));
                            },
                            child: SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: topRated.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    final Map<String, dynamic> currentProduct =
                                        topRated[index];

                                    return ProductCard(
                                        image: currentProduct["image"],
                                        name: currentProduct["name"],
                                        displayName:
                                            currentProduct["display_name"],
                                        quantity: currentProduct["quantity"],
                                        price: currentProduct["price"],
                                        rating: currentProduct["rating"],
                                        originalPrice:
                                            currentProduct["original_price"]);
                                  }),
                            ),
                          ),
                        HomeScreenSection(
                          header: "All",
                          onViewAll: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const FilterProduct()));
                          },
                          child: SizedBox(
                            height: 220,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: allProducts.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  final Map<String, dynamic> currentProduct =
                                      allProducts[index];

                                  return ProductCard(
                                      image: currentProduct["image"],
                                      name: currentProduct["name"],
                                      displayName:
                                          currentProduct["display_name"],
                                      quantity: currentProduct["quantity"],
                                      price: currentProduct["price"],
                                      rating: currentProduct["rating"],
                                      originalPrice:
                                          currentProduct["original_price"]);
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Copyright \u00a9 ${DateTime.now().year} Meatistic",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
              )
                .animate()
                .fadeIn(duration: 700.ms)
                .moveY(duration: 700.ms, begin: -20, end: 0),
      ),
    );
  }
}
