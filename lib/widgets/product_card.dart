import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/models/product.dart';
import 'package:meatistic/models/vendor.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/screens/landing_page.dart';
import 'package:meatistic/screens/product_details.dart';
import 'package:meatistic/settings.dart';
import 'dart:convert';

class ProductCardAddToCartButton extends ConsumerStatefulWidget {
  const ProductCardAddToCartButton(
      {super.key, required this.product, required this.productQuantity});

  final Product product;
  final ProductQuantity productQuantity;

  @override
  ConsumerState<ProductCardAddToCartButton> createState() =>
      _ProductCardAddToCartButtonState();
}

class _ProductCardAddToCartButtonState
    extends ConsumerState<ProductCardAddToCartButton> {
  bool processingCart = false;

  void _addToCart() {
    setState(() {
      processingCart = true;
    });
    ref
        .read(cartProvider.notifier)
        .addToCart(
            context: context,
            product: widget.product,
            selectedQuantity: widget.productQuantity,
            quantityCount: 1)
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
      setState(() {
        processingCart = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something went wrong!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
        onPressed: processingCart ? null : _addToCart,
        style: IconButton.styleFrom(
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(35)))),
        icon: processingCart
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              )
            : const Icon(Icons.add_shopping_cart_rounded));
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key,
      required this.image,
      required this.name,
      required this.displayName,
      required this.quantityId,
      required this.quantity,
      required this.price,
      required this.originalPrice,
      required this.vendor,
      this.rating});

  final String image;
  final String name;
  final String displayName;
  final int quantityId;
  final String quantity;
  final double price;
  final double originalPrice;
  final double? rating;
  final String vendor;

  @override
  Widget build(BuildContext context) {
    final String productImage = getUri(image).toString();
    final Product product = Product(
        image: image,
        name: name,
        displayName: displayName,
        vendor: Vendor.withName(vendor),
        availableQuantities: []);
    final ProductQuantity selectedQuantity = ProductQuantity(
        id: quantityId,
        quantity: quantity,
        price: price.toString(),
        originalPrice: originalPrice.toString());
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) =>
                ProductDetail(name: name, productImage: productImage)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: SizedBox(
            width: 220,
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(productImage)),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      vendor,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (rating != null)
                              Container(
                                padding: const EdgeInsets.only(
                                    right: 8, left: 2, top: 2, bottom: 2),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    Text(rating!.toStringAsFixed(1)),
                                  ],
                                ),
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          quantity,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              displayName,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\u{20B9}${price.toInt()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "\u{20B9}${originalPrice.toInt()}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              ),
                            ),
                            ProductCardAddToCartButton(
                                product: product,
                                productQuantity: selectedQuantity)
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
