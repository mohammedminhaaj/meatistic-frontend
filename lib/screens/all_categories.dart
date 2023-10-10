import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/screens/filter_product.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/category_card.dart';

bool areCategoriesSame(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  for (int i = 0; i < list1.length; i++) {
    if (!(list1[i]["display_name"] == list2[i]["display_name"])) {
      return false;
    }
  }

  return true;
}

class AllCategories extends ConsumerStatefulWidget {
  const AllCategories({super.key});

  @override
  ConsumerState<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends ConsumerState<AllCategories> {
  final Box<Store> box = Hive.box<Store>("store");
  late final double? lt;
  late final double? ln;
  String searchText = "";
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;
  bool isLoading = true;
  List<dynamic> categories = [];
  late final List<dynamic> cachedCategories;

  List<dynamic> _filterCategories(String key) => cachedCategories
      .where((element) => element["display_name"]
          .toString()
          .toLowerCase()
          .contains(key.toLowerCase()))
      .toList();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    final UserLocation userLocation = ref.read(userLocationProvider);
    if (userLocation.selectedLocation != null) {
      lt = userLocation.selectedLocation!.latitude;
      ln = userLocation.selectedLocation!.longitude;
    } else if (userLocation.currentLocation != null) {
      lt = userLocation.currentLocation!.latitude;
      ln = userLocation.currentLocation!.longitude;
    } else {
      lt = null;
      ln = null;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final Map<String, String> queryParams = {
        "lt": lt != null ? lt.toString() : "null",
        "ln": ln != null ? ln.toString() : "null",
      };
      final Uri url = getUri("/api/product/get-categories/", queryParams);
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      http
          .get(url, headers: getAuthorizationHeaders(authToken))
          .then((response) {
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content:
                    Text("Something went wrong while fetching categories")));
        } else {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            isLoading = false;
            categories = [...data];
            cachedCategories = [...data];
          });
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(
              content: Text("Something went wrong after fetching categories")));
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, right: 20, left: 5),
              child: Column(
                children: [
                  const Text(
                    "Categories",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        if (value.length >= 3) {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(0.0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                          categories = _filterCategories(value);
                        } else {
                          if (!areCategoriesSame(
                              categories, cachedCategories)) {
                            categories = [...cachedCategories];
                          }
                        }
                      });
                    },
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "What are you looking for?",
                        icon: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        suffixIcon: searchText.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _textEditingController.clear();
                                  if (_scrollController.hasClients) {
                                    _scrollController.animateTo(0.0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                  setState(() {
                                    searchText = "";
                                    if (!areCategoriesSame(
                                        categories, cachedCategories)) {
                                      categories = [...cachedCategories];
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            : null,
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Theme.of(context).colorScheme.primary),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : categories.isEmpty && searchText.length >= 3
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/search.svg",
                              height: 250,
                              width: 250,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("No results found for '$searchText'")
                          ],
                        ),
                      )
                    : categories.isEmpty
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/empty.svg",
                                  height: 250,
                                  width: 250,
                                ),
                                const Text("No nearby vendors available")
                              ],
                            ),
                          )
                        : Expanded(
                            child: GridView.count(
                              padding: const EdgeInsets.all(10),
                              controller: _scrollController,
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 25,
                              physics: const BouncingScrollPhysics(),
                              childAspectRatio: 1,
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children:
                                  List.generate(categories.length, (index) {
                                final Map<String, dynamic> currentCategory =
                                    categories[index];
                                return InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FilterProduct(
                                                    category: currentCategory[
                                                        "display_name"],
                                                    header: currentCategory[
                                                        "display_name"],
                                                  )));
                                    },
                                    child: CategoryCard(
                                      image: currentCategory["image"],
                                      name: currentCategory["display_name"],
                                    ));
                              })
                                      .animate(interval: 200.ms)
                                      .fade(duration: 200.ms)
                                      .scaleXY(duration: 200.ms),
                            ),
                          )
          ],
        ),
      ),
    );
  }
}
