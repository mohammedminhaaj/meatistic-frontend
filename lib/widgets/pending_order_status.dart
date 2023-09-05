import 'package:flutter/material.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/screens/order_summary.dart';
import 'package:meatistic/widgets/elevated_container.dart';

class PendingOrderStatus extends StatelessWidget {
  const PendingOrderStatus({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.orderId),
                      Text(
                        "Order ${order.orderStatus}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                // Chip(
                //     side: BorderSide(color: Theme.of(context).colorScheme.primary),
                //     label: Column(
                //       children: [
                //         const Text("Delivery in"),
                //         Text(
                //           "33 mins",
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               color: Theme.of(context).colorScheme.primary),
                //         )
                //       ],
                //     ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            for (final cart in order.cart)
              Row(
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                        "${cart.quantityCount} x ${cart.product.displayName} (${cart.selectedQuantity.quantity})"),
                  )
                ],
              ),
            const Divider(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivering to",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  order.address,
                ),
                const Divider(
                  height: 20,
                )
              ],
            ),
            if (order.deliveryInstructions != null &&
                order.deliveryInstructions?.trim() != "")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delivery Instructions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    order.deliveryInstructions!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dotted,
                        decorationColor: Theme.of(context).colorScheme.primary),
                  ),
                  const Divider(
                    height: 20,
                  )
                ],
              ),
            Center(
              child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderSummary(order: order),
                    ));
                  },
                  icon: const Icon(Icons.arrow_right_rounded),
                  label: const Text("View order summary")),
            )
          ],
        ));
  }
}
