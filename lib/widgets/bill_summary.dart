import 'package:flutter/material.dart';

class BillSummary extends StatelessWidget {
  const BillSummary(
      {super.key,
      required this.subTotalPrice,
      required this.deliveryCharge,
      required this.discountAmount,
      required this.total});

  final double subTotalPrice;
  final double deliveryCharge;
  final double discountAmount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sub-Total",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "\u{20B9} $subTotalPrice",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Delivery",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "\u{20B9} $deliveryCharge",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        if (discountAmount != 0.0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Discount",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "- \u{20B9} $discountAmount",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "\u{20B9} ${total - discountAmount}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
