import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/cart.dart';
import 'package:meatistic/models/product.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Modifier {
  add,
  subtract,
}

class CartNotifier extends StateNotifier<List<Cart>> {
  CartNotifier() : super([]);

  final Box<Store> box = Hive.box<Store>("store");

  void generateCartList(List<dynamic> json) {
    state = json
        .map((cartItem) => Cart(
            product: Product.fromJson(cartItem["product"]),
            quantityCount: cartItem["quantity_count"],
            selectedQuantity:
                ProductQuantity.fromJson(cartItem["product_quantity"])))
        .toList();
  }

  void clearCart() {
    state = [];
  }

  Future<http.Response?> addToCart(
      {required BuildContext context,
      required Product product,
      required ProductQuantity selectedQuantity,
      required int quantityCount}) {
    //Check if the item is already present with same name and quantity
    if (state.any((element) =>
        element.product.name == product.name &&
        element.selectedQuantity.id == selectedQuantity.id &&
        element.quantityCount == quantityCount)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item already exixts in your cart.")));
      return Future(() => null);
    }

    // Check if the item is from a different vendor
    if (state.any((element) =>
        element.product.vendor.displayName != product.vendor.displayName)) {
      final String currentVendorName = state[0].product.vendor.displayName;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
                "Items from '$currentVendorName' are already present in your cart. Please remove them first and then add again."),
            action: SnackBarAction(label: "Remove", onPressed: deleteCartAll)));
      return Future(() => null);
    }

    late final Uri url;
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;

    if (state.any((element) => element.product.name == product.name)) {
      //check if the item exists. If so, modify the quantity
      state = [
        ...state.where((element) => element.product.name != product.name),
        Cart(
            product: product,
            selectedQuantity: selectedQuantity,
            quantityCount: quantityCount)
      ];
      url = getUri("/api/cart/edit-cart/${product.name}/");
    } else {
      //add the item if it does not exists
      state = [
        ...state,
        Cart(
            product: product,
            selectedQuantity: selectedQuantity,
            quantityCount: quantityCount)
      ];
      url = getUri("/api/cart/add-cart/");
    }
    return http.post(url,
        headers: getAuthorizationHeaders(authToken),
        body: json.encode({
          "product_quantity_id": selectedQuantity.id,
          "quantity_count": quantityCount,
        }));
  }

  void deleteCart(
      {required Product product, required ProductQuantity selectedQuantity}) {
    state = [
      ...state.where((element) =>
          element.product.name != product.name &&
          element.selectedQuantity.id != selectedQuantity.id)
    ];

    final url = getUri("/api/cart/delete-cart/");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;
    http.delete(url,
        headers: getAuthorizationHeaders(authToken),
        body: json.encode({
          "product_quantity_id": selectedQuantity.id,
        }));
  }

  void deleteCartAll() {
    clearCart();
    final url = getUri("/api/cart/delete-cart/all/");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;
    http.delete(
      url,
      headers: getAuthorizationHeaders(authToken),
    );
  }

  void modifyQuantityCount(Modifier modifier, String productName) {
    final List<Cart> cartList = state;
    final Cart cartItem =
        cartList.singleWhere((element) => element.product.name == productName);

    if (modifier == Modifier.add) {
      cartItem.quantityCount++;
    } else {
      cartItem.quantityCount--;
    }

    state = [...cartList];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Cart>>((ref) => CartNotifier());
