import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/cart.dart';
import 'package:meatistic/models/coupon.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/providers/coupon_provider.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/bill_summary.dart';
import 'package:meatistic/widgets/cart_item.dart';
import 'package:meatistic/widgets/cart_section.dart';
import 'package:meatistic/widgets/checkout_overlay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/widgets/delivery_details.dart';
import 'package:meatistic/widgets/delivery_instructions.dart';
import 'package:meatistic/widgets/offer_section.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool isLoading = true;
  final Box<Store> box = Hive.box<Store>("store");
  Map<dynamic, dynamic> vendorErrors = {};
  double deliveryCharge = 0.0;
  final ScrollController _scrollController = ScrollController();
  String? deliveryInstructions;

  @override
  Widget build(BuildContext context) {
    final List<Cart> cartItems = ref.watch(cartProvider).reversed.toList();
    final UserLocation userLocation = ref.watch(userLocationProvider);
    final Coupon? appliedCoupon = ref.watch(couponProvider);
    ref.listen(
      userLocationProvider,
      (previous, next) {
        setState(() {
          isLoading = true;
        });
      },
    );
    double subTotalPrice = cartItems.fold(0.0,
        (previousValue, element) => previousValue + element.getCalculatedPrice);
    double total = subTotalPrice + deliveryCharge;
    double discountAmount = 0.0;
    if (appliedCoupon != null) {
      discountAmount = appliedCoupon.getCalculatedDiscount(
          total, subTotalPrice, deliveryCharge);
    }
    if (isLoading) {
      final Uri url = Uri.https(baseUrl, "/api/cart/get-cart/", {
        'lt': (userLocation.selectedLocation?.latitude ??
                userLocation.currentLocation?.latitude)
            .toString(),
        'ln': (userLocation.selectedLocation?.longitude ??
                userLocation.currentLocation?.longitude)
            .toString()
      });
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      http
          .get(url, headers: getAuthorizationHeaders(authToken))
          .then((response) {
        final Map<dynamic, dynamic> data = json.decode(response.body);
        ref.read(cartProvider.notifier).generateCartList(data["cart"]);
        setState(() {
          vendorErrors = data["vendor_errors"];
          deliveryCharge = data["delivery_charge"];
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
      });
    }

    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          setState(() {
            isLoading = true;
          });
        });
      },
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/empty-cart.png"),
                    const Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              : Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 60),
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              CartSection(
                                  header: "Delivery",
                                  child: DeliveryDetails(
                                    vendorErrors: vendorErrors,
                                    selectedAddress:
                                        userLocation.selectedLocation,
                                    cartItems: cartItems,
                                  )),
                              CartSection(
                                  header: "My Items",
                                  child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return CartItem(
                                          cart: cartItems[index],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          height: 20,
                                        );
                                      },
                                      itemCount: cartItems.length)),
                              CartSection(
                                  child: Column(
                                children: [
                                  InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.add_circle_outline_rounded,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text(
                                              "Add more items",
                                              style: TextStyle(fontSize: 15),
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
                                  const Divider(
                                    height: 20,
                                  ),
                                  InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    onTap: () async {
                                      final String? instructions =
                                          await showModalBottomSheet(
                                              isScrollControlled: true,
                                              useSafeArea: true,
                                              context: context,
                                              builder: (context) {
                                                return DeliveryInstructions(
                                                  instructions:
                                                      deliveryInstructions,
                                                );
                                              });
                                      if (instructions != null) {
                                        setState(() {
                                          deliveryInstructions = instructions;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.note_alt_outlined,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Add delivery instructions",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Visibility(
                                                  visible:
                                                      deliveryInstructions !=
                                                          null,
                                                  child: const SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                Visibility(
                                                    visible:
                                                        deliveryInstructions !=
                                                            null,
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: Text(
                                                        deliveryInstructions ??
                                                            "",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .dashed),
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ))
                                              ],
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
                                ],
                              )),
                              CartSection(
                                  header: "Offers",
                                  child: OfferSection(
                                    appliedCoupon: appliedCoupon,
                                    total: total,
                                  )),
                              CartSection(
                                  header: "Bill Summary",
                                  child: BillSummary(
                                    subTotalPrice: subTotalPrice,
                                    deliveryCharge: deliveryCharge,
                                    total: total,
                                    discountAmount: discountAmount,
                                  )),
                              const CartSection(
                                  header: "Cancellation Policy",
                                  child: Text(
                                      "Orders once placed cannot be cancelled and are non-refundable")),
                            ],
                          ),
                        )),
                    CheckoutOverlay(
                      deliveryInstructions: deliveryInstructions,
                      total: total - discountAmount,
                      couponCode: appliedCoupon != null &&
                              !appliedCoupon.hasErrors(total)
                          ? appliedCoupon.code
                          : null,
                      scrollController: _scrollController,
                      hasErrors: userLocation.selectedLocation == null ||
                          (vendorErrors.containsKey("CLOSED") &&
                              cartItems.any((element) => vendorErrors["CLOSED"]
                                  .contains(
                                      element.product.vendor.displayName))) ||
                          (vendorErrors.containsKey("UNDELIVERABLE") &&
                              cartItems.any((element) =>
                                  vendorErrors["UNDELIVERABLE"].contains(
                                      element.product.vendor.displayName))),
                    )
                  ],
                )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .moveY(duration: 700.ms, begin: -20, end: 0),
    );
  }
}
