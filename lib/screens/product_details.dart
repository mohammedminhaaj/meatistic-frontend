import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/cart.dart';
import 'package:meatistic/models/product.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/screens/landing_page.dart';
import 'package:meatistic/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/widgets/quantity_count.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail(
      {super.key, required this.name, required this.productImage});

  final String name;
  final String productImage;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  Product product = Product.empty();
  ProductQuantity? productQuantity;
  final Box<Store> box = Hive.box<Store>("store");
  bool isLoading = true;
  bool processingCart = false;
  bool hasError = false;
  String errorMessage = "";
  final ValueNotifier<int> quantityCount = ValueNotifier(1);

  void modifyQuantityCount(Modifier modifier) {
    switch (modifier) {
      case Modifier.add:
        {
          quantityCount.value++;
        }
        break;
      case Modifier.subtract:
        {
          quantityCount.value--;
        }
        break;
    }
  }

  void _addToCart() {
    setState(() {
      processingCart = true;
    });
    ref
        .read(cartProvider.notifier)
        .addToCart(
            context: context,
            product: product,
            selectedQuantity: productQuantity!,
            quantityCount: quantityCount.value)
        .then((response) {
      if (response != null) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data["details"])));
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data["details"]),
            action: SnackBarAction(
                label: "View",
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const LandingPage(
                            redirectTo: "Cart",
                          )));
                }),
          ));
        }
      }
      setState(() {
        processingCart = false;
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something went wrong!")));
    });
  }

  @override
  void dispose() {
    quantityCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final url =
          Uri.https(baseUrl, "/api/product/get-product/${widget.name}/");
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String token = store.authToken;
      http.get(url, headers: getAuthorizationHeaders(token)).then((response) {
        final Map<dynamic, dynamic> data = json.decode(response.body);
        setState(() {
          isLoading = false;
          if (response.statusCode < 400) {
            if (hasError = true) {
              hasError = false;
            }
            product = Product.fromJson(data);
            if (product.availableQuantities.isNotEmpty) {
              final List<Cart> cartList = ref.read(cartProvider);
              try {
                final Cart productInCart = cartList.singleWhere(
                    (element) => element.product.name == product.name);
                final ProductQuantity selectedproductQuantity =
                    product.availableQuantities.singleWhere((element) =>
                        element.id == productInCart.selectedQuantity.id);
                productQuantity = selectedproductQuantity;
                quantityCount.value = productInCart.quantityCount;
              } on StateError {
                productQuantity = product.availableQuantities[0];
              }
            } else {
              productQuantity = null;
            }
          } else {
            hasError = true;
            product = Product.fromJson(data["product"]);
            errorMessage = data["details"];
          }
        });
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong!")));
      });
    }
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {
              isLoading = true;
            });
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .25,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            CachedNetworkImageProvider(widget.productImage))),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.3), // Start color
                          Colors.white, // End color with opacity
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 128,
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.grey,
                                      ),
                                      label: Text(
                                        product.vendor.displayName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      )),
                                  if (product.rating != null)
                                    TextButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber[500],
                                        ),
                                        label: Text(
                                          product.rating!.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      product.displayName,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        productQuantity != null
                                            ? "\u{20B9} ${productQuantity?.price.split(".")[0]}"
                                            : "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                      Text(
                                        productQuantity != null
                                            ? "\u{20B9} ${productQuantity?.originalPrice.split(".")[0]}"
                                            : "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              hasError
                                  ? SizedBox(
                                      height: 128,
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        errorMessage,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        product.availableQuantities.isEmpty
                                            ? Text(
                                                "We are currently out of stock. Apologies for the inconvenience.",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 20),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  DropdownButton(
                                                    alignment: Alignment.center,
                                                    enableFeedback: true,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                25)),
                                                    items: List.generate(
                                                        product
                                                            .availableQuantities
                                                            .length,
                                                        (index) =>
                                                            DropdownMenuItem(
                                                              value: product
                                                                  .availableQuantities[
                                                                      index]
                                                                  .id,
                                                              child: Text(product
                                                                  .availableQuantities[
                                                                      index]
                                                                  .quantity),
                                                            )),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        quantityCount.value = 1;
                                                        productQuantity = product
                                                            .availableQuantities
                                                            .singleWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    value);
                                                      });
                                                    },
                                                    value: productQuantity?.id,
                                                    iconSize: 30,
                                                    iconEnabledColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                  ),
                                                  ValueListenableBuilder(
                                                    valueListenable:
                                                        quantityCount,
                                                    builder: (context, value,
                                                        child) {
                                                      return QuantityCount(
                                                          spacing: 10,
                                                          fontSize: 20,
                                                          value: value,
                                                          onIncrement: () {
                                                            modifyQuantityCount(
                                                                Modifier.add);
                                                          },
                                                          onDecrement: () {
                                                            modifyQuantityCount(
                                                                Modifier
                                                                    .subtract);
                                                          });
                                                    },
                                                  )
                                                ],
                                              ),
                                        const SizedBox(height: 20),
                                        Text(
                                          product.description!,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          )
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .moveY(duration: 700.ms, begin: 20, end: 0),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: quantityCount,
                builder: (context, value, child) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Total Price",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            productQuantity == null
                                ? "NA"
                                : "\u{20B9}${double.parse(productQuantity!.price) * value}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        ],
                      ),
                    )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: isLoading ||
                              processingCart ||
                              product.availableQuantities.isEmpty ||
                              product.deletedAt != null ||
                              hasError
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary),
                  onPressed: isLoading ||
                          processingCart ||
                          product.availableQuantities.isEmpty ||
                          product.deletedAt != null ||
                          hasError
                      ? null
                      : _addToCart,
                  icon: processingCart
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          product.name != "" &&
                                  (product.availableQuantities.isEmpty ||
                                      product.deletedAt != null)
                              ? Icons.remove_shopping_cart_rounded
                              : Icons.add_shopping_cart_rounded,
                          size: 30,
                        ),
                  label: Text(
                    product.name != "" &&
                            (product.availableQuantities.isEmpty ||
                                product.deletedAt != null)
                        ? "Out of Stock"
                        : "Add to Cart",
                    style: const TextStyle(
                      fontSize: 18, // Adjust the text size
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
