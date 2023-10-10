import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/models/cart.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/cart_provider.dart';
import 'package:meatistic/widgets/select_address_modal.dart';

class DeliveryDetails extends StatelessWidget {
  const DeliveryDetails(
      {super.key,
      this.selectedAddress,
      required this.vendorErrors,
      required this.cartItems});

  final UserAddress? selectedAddress;
  final List<dynamic> vendorErrors;
  final List<Cart> cartItems;

  String parseVendorErrors(String forType) {
    final String vendor = cartItems[0].product.vendor.displayName;
    switch (forType) {
      case "CLOSED":
        {
          return "$vendor is not delivering at the moment.";
        }

      case "UNDELIVERABLE":
        {
          return "Items from $vendor can't be delivered to your selected location. Please remove the items or select a different location.";
        }

      default:
        {
          return "Something went wrong!";
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                selectedAddress == null
                    ? "Please select a delivery location."
                    : selectedAddress!.inputAddress == ""
                        ? selectedAddress!.longAddress!
                        : selectedAddress!.inputAddress,
                style: TextStyle(
                    color: selectedAddress == null ? Colors.red : Colors.black),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return const SelectAddressModal();
                      });
                },
                child: Text(selectedAddress == null ? "Select" : "Change"))
          ],
        ),
        for (final error in vendorErrors)
          if (selectedAddress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: Colors.red[300],
                          )),
                          const TextSpan(text: " "),
                          TextSpan(text: parseVendorErrors(error))
                        ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              return TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .deleteCartAll();
                                  },
                                  child: const Text("Remove Items"));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
      ],
    );
  }
}
