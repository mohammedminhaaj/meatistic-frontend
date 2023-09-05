import 'package:flutter/material.dart';
import 'package:meatistic/data/payment_mode.dart';
import 'package:meatistic/widgets/modal_header.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key, required this.paymentMode});

  final PaymentMode paymentMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalHeader(headerText: "Payment Mode"),
          const SizedBox(
            height: 20,
          ),
          RadioListTile(
            activeColor: Theme.of(context).colorScheme.primary,
            value: PaymentMode.cash,
            groupValue: paymentMode,
            title: Text(
              paymentModeString[PaymentMode.cash]!,
              style: const TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Cash on delivery"),
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
            dense: true,
            selected: paymentMode == PaymentMode.cash,
            secondary: const Icon(Icons.chevron_right_rounded),
          ),
          RadioListTile(
            activeColor: Theme.of(context).colorScheme.primary,
            value: PaymentMode.online,
            groupValue: paymentMode,
            title: Text(
              paymentModeString[PaymentMode.online]!,
              style: const TextStyle(fontSize: 17),
            ),
            subtitle: const Text(
                "Online payments are carried out by third party payment gateway."),
            onChanged: null,
            // onChanged: (value) {
            //   Navigator.of(context).pop(value);
            // },
            dense: true,
            selected: paymentMode == PaymentMode.online,
            secondary: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
