import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/data/color.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/providers/order_provider.dart';
import 'package:meatistic/screens/order_feedback.dart';
import 'package:meatistic/widgets/elevated_container.dart';

class OrderCard extends ConsumerStatefulWidget {
  const OrderCard({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<OrderCard> {
  bool isDateWithin7Days(DateTime date) {
    final currentDate = DateTime.now();
    final difference = currentDate.difference(date).inDays;

    return difference <= 7;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedContainer(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.order.orderId,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    widget.order.orderStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                  side: BorderSide.none,
                  backgroundColor: statusColor[widget.order.orderStatus],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (final cart in widget.order.cart)
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                        "${cart.quantityCount} x ${cart.product.displayName} (${cart.selectedQuantity.quantity})"),
                  ),
                ],
              ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.order.getLocalCreatedAt,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "\u{20B9} ${widget.order.total}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
            if (widget.order.orderStatus == "Delivered" &&
                isDateWithin7Days(DateTime.parse(widget.order.createdAt)))
              Row(
                children: [
                  Expanded(
                      child: widget.order.feedbackCompleted
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Feedback completed",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )
                                ],
                              ),
                            )
                          : TextButton.icon(
                              onPressed: () async {
                                final String? feedbackCompletedMessage =
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                  builder: (context) =>
                                      OrderFeedback(order: widget.order),
                                ));
                                if (feedbackCompletedMessage != null) {
                                  Future.microtask(() {
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(SnackBar(
                                          content:
                                              Text(feedbackCompletedMessage)));
                                  });
                                  ref
                                      .read(orderProvider.notifier)
                                      .markFeedbackCompleted(
                                          widget.order.orderId);

                                  setState(() {
                                    widget.order.feedbackCompleted = true;
                                  });
                                }
                              },
                              icon: const Icon(Icons.comment_rounded),
                              label: const Text("Give Feedback"))),
                ],
              )
          ],
        ),
      ),
    );
  }
}
