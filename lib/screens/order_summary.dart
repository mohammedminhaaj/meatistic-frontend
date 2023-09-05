import 'package:flutter/material.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/screens/product_details.dart';
import 'package:meatistic/settings.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.orderId,
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              "Your Order",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (final cart in order.cart)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        onTap: () {
                          final String url =
                              Uri.https(baseUrl, cart.product.image!)
                                  .toString();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetail(
                                name: cart.product.name, productImage: url),
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.product.displayName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "${cart.quantityCount} x \u{20B9} ${cart.orderPrice}")
                          ],
                        ),
                      ),
                    ),
                    Text("\u{20B9} ${cart.getOrderPrice}")
                  ],
                ),
              ),
            const Divider(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Item total"),
                    Text("\u{20B9} ${order.amount}")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery charge"),
                    Text("\u{20B9} ${order.deliveryCharge}")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (order.discount != null && order.discount! != 0.0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Discount"),
                      Text("- \u{20B9} ${order.discount}")
                    ],
                  ),
                Visibility(
                  visible: order.discount != null && order.discount! != 0.0,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Grand Total",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text("\u{20B9} ${order.total}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
              ],
            ),
            Divider(
              height: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("PAYMENT",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order.paymentMode),
            const SizedBox(
              height: 20,
            ),
            const Text("DATE", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order.getLocalCreatedAt),
            const SizedBox(
              height: 20,
            ),
            const Text("DELIVER TO",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order.address),
          ],
        ),
      ),
    );
  }
}
