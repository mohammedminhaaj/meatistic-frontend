import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/settings.dart';
import 'dart:convert';

import 'package:meatistic/widgets/product_card.dart';

bool areProductsSame(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  for (int i = 0; i < list1.length; i++) {
    if (!(list1[i]["name"] == list2[i]["name"])) {
      return false;
    }
  }

  return true;
}

class FilterProduct extends ConsumerStatefulWidget {
  const FilterProduct({super.key, this.filterQuery, this.autoFocus = false});

  final bool autoFocus;
  final String? filterQuery;

  @override
  ConsumerState<FilterProduct> createState() => _FilterProductState();
}

class _FilterProductState extends ConsumerState<FilterProduct> {
  final Box<Store> box = Hive.box<Store>("store");
  late final double? lt;
  late final double? ln;
  List<dynamic>? productData;
  late final List<dynamic> cachedProductData;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  Timer? _debounceTimer;
  String searchText = "";
  int page = 1;
  bool searchingProducts = false;
  bool extendingProducts = false;
  bool endOfList = false;

  void handleExtendProducts() {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !endOfList) {
      setState(() {
        extendingProducts = true;
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(handleExtendProducts);
    final UserLocation userLocation = ref.read(userLocationProvider);
    if (userLocation.selectedLocation != null) {
      lt = userLocation.selectedLocation!.latitude;
      ln = userLocation.selectedLocation!.longitude;
    } else if (userLocation.currentLocation != null) {
      lt = userLocation.currentLocation!.latitude;
      ln = userLocation.currentLocation!.longitude;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.removeListener(handleExtendProducts);
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (searchingProducts || extendingProducts || productData == null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        final Map<String, String> queryParams = {
          "page": page.toString(),
          "search_text": searchText,
          "lt": lt != null ? lt.toString() : "null",
          "ln": ln != null ? ln.toString() : "null",
          "filter_by": widget.filterQuery ?? "",
        };
        final Uri url =
            Uri.https(baseUrl, "/api/product/filter-products/", queryParams);
        final Store store = box.get("storeObj", defaultValue: Store())!;
        final String authToken = store.authToken;
        http
            .get(url, headers: getAuthorizationHeaders(authToken))
            .then((response) {
          final List<dynamic> data = json.decode(response.body);
          if (searchingProducts && !extendingProducts) {
            productData = data;
            setState(() {
              searchingProducts = false;
            });
          } else if (extendingProducts && !searchingProducts) {
            productData?.addAll(data);
            setState(() {
              extendingProducts = false;
              if (data.isEmpty) {
                endOfList = true;
              }
            });
          } else if (productData == null) {
            setState(() {
              productData = data;
              cachedProductData = data;
            });
          }
          _debounceTimer!.cancel();
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content: Text("Something went wrong while fetching products")));
          _debounceTimer!.cancel();
        });
      });
    }

    if (searchText.length < 3 &&
        productData != null &&
        !areProductsSame(productData!, cachedProductData) &&
        page == 1) {
      productData = [...cachedProductData];
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 5),
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  if (value.length >= 3) {
                    searchingProducts = true;
                  } else {
                    searchingProducts = false;
                  }

                  if (page != 1) {
                    page = 1;
                    endOfList = false;
                  }
                });
              },
              controller: _textEditingController,
              decoration: InputDecoration(
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
                            setState(() {
                              searchText = "";
                              if (page != 1) {
                                page = 1;
                                endOfList = false;
                              }
                              if (searchingProducts) {
                                searchingProducts = false;
                              }
                              if (extendingProducts) {
                                extendingProducts = false;
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
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              autofocus: widget.autoFocus,
            ),
          ),
          searchingProducts
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : productData == null ||
                      productData != null && productData!.isEmpty
                  ? Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            searchText.length >= 3
                                ? Image.asset("assets/images/search.png")
                                : const CircularProgressIndicator(),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              searchText.length >= 3
                                  ? "No results for '$searchText' found."
                                  : "Please wait while we load some products for you...",
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.only(bottom: 40),
                        controller: _scrollController,
                        mainAxisSpacing: 25,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        children: List.generate(productData!.length, (index) {
                          final Map<String, dynamic> currentProduct =
                              productData?[index];
                          return ProductCard(
                              image: currentProduct["image"],
                              name: currentProduct["name"],
                              displayName: currentProduct["display_name"],
                              quantity: currentProduct["quantity"],
                              price: currentProduct["price"],
                              rating: currentProduct["rating"],
                              originalPrice: currentProduct["original_price"]);
                        })
                            .animate(interval: 200.ms)
                            .fade(duration: 200.ms)
                            .scaleXY(duration: 200.ms),
                      ),
                    ),
        ]),
      ),
    );
  }
}
