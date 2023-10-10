import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/cart.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/screens/product_details.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/delete_action_background.dart';
import 'package:meatistic/widgets/quantity_count.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem extends ConsumerWidget {
  const CartItem({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = getUri(cart.product.image!).toString();
    final ValueNotifier<bool> quantityCountChanged = ValueNotifier(false);
    final Box<Store> box = Hive.box<Store>("store");
    final url =
        getUri("/api/cart/edit-cart/quantity-count/${cart.product.name}/");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;

    return Dismissible(
        onDismissed: (DismissDirection direction) {
          ref.read(cartProvider.notifier).deleteCart(
              product: cart.product, selectedQuantity: cart.selectedQuantity);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Item removed from your cart!"),
          ));
        },
        direction: DismissDirection.endToStart,
        background: const DeleteActionBackground(),
        key: UniqueKey(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              onTap: () {
                final url = getUri(cart.product.image!).toString();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProductDetail(
                        name: cart.product.name, productImage: url)));
              },
              child: Row(
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                imageUrl,
                              ))),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width * .30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.product.displayName,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 14,
                            ),
                            Expanded(
                              child: Text(
                                cart.product.vendor.displayName,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.line_weight_rounded,
                              color: Colors.grey,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              cart.selectedQuantity.quantity,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "\u{20B9}${cart.getCalculatedPrice}",
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ValueListenableBuilder(
                valueListenable: quantityCountChanged,
                builder: (context, value, child) {
                  return value
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator())
                      : QuantityCount(
                          minValue: 0,
                          iconSize: 15,
                          size: 30,
                          fontSize: 17,
                          value: cart.quantityCount,
                          onIncrement: () {
                            final int quantityCount = cart.quantityCount;
                            quantityCountChanged.value = true;
                            http
                                .post(url,
                                    headers: getAuthorizationHeaders(authToken),
                                    body: json.encode(
                                        {"quantity_count": quantityCount + 1}))
                                .then((response) {
                              quantityCountChanged.value = false;
                              final Map<dynamic, dynamic> data =
                                  json.decode(response.body);
                              if (response.statusCode >= 400) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(data["details"]),
                                ));
                              } else {
                                ref
                                    .read(cartProvider.notifier)
                                    .modifyQuantityCount(
                                        Modifier.add, cart.product.name);
                              }
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Something went wrong!"),
                              ));
                            });
                          },
                          onDecrement: () {
                            final int quantityCount = cart.quantityCount;
                            quantityCountChanged.value = true;
                            if ((quantityCount - 1) <= 0) {
                              ref.read(cartProvider.notifier).deleteCart(
                                  product: cart.product,
                                  selectedQuantity: cart.selectedQuantity);
                            } else {
                              http
                                  .post(url,
                                      headers:
                                          getAuthorizationHeaders(authToken),
                                      body: json.encode({
                                        "quantity_count": quantityCount - 1
                                      }))
                                  .then((response) {
                                quantityCountChanged.value = false;
                                final Map<dynamic, dynamic> data =
                                    json.decode(response.body);
                                if (response.statusCode >= 400) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(data["details"]),
                                  ));
                                } else {
                                  ref
                                      .read(cartProvider.notifier)
                                      .modifyQuantityCount(
                                          Modifier.subtract, cart.product.name);
                                }
                              }).onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Something went wrong!"),
                                ));
                              });
                            }
                          });
                },
              ),
            ),
          ],
        ));
  }
}
