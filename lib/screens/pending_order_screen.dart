import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/screens/pending_order_details.dart';
import 'package:meatistic/widgets/order_card.dart';

class PendingOrderScreen extends ConsumerStatefulWidget {
  const PendingOrderScreen({super.key, required this.orders});

  final List<Order> orders;

  @override
  ConsumerState<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends ConsumerState<PendingOrderScreen> {
  final Box<Store> box = Hive.box<Store>("store");

  @override
  Widget build(BuildContext context) {
    return widget.orders.length > 1
        ? Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 10, right: 10, bottom: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.orders.length,
              itemBuilder: (context, index) => InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PendingOrderDetails(
                        orderId: widget.orders[index].orderId,
                        includeAppBar: true,
                      ),
                    ));
                  },
                  child: OrderCard(order: widget.orders[index])),
            ),
          )
        : PendingOrderDetails(orderId: widget.orders[0].orderId);
  }
}
