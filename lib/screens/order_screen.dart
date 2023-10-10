import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/providers/home_screen_builder_provider.dart';
import 'package:meatistic/providers/order_provider.dart';
import 'package:meatistic/screens/pending_order_screen.dart';
import 'package:meatistic/screens/previous_order_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/settings.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  bool isLoading = true;
  final Box<Store> box = Hive.box<Store>("store");
  WebSocketChannel? channel;

  @override
  void dispose() {
    currentScreen.dispose();
    channel?.sink.close();
    super.dispose();
  }

  final ValueNotifier<int> currentScreen = ValueNotifier(0);
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final AllOrders allOrders = ref.watch(orderProvider);
    if (isLoading) {
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      final Uri url = getUri("/api/order/get-orders/");
      http
          .get(url, headers: getAuthorizationHeaders(authToken))
          .then((response) {
        final Map<dynamic, dynamic> data = json.decode(response.body);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong")));
        } else {
          ref.read(orderProvider.notifier).setAllOrders(data);
          if (data["pending"].isEmpty) {
            ref
                .read(homeScreenBuilderProvider.notifier)
                .setPendingOrders(false);
          }
        }
        setState(() {
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
      });
    }

    if (allOrders.pendingOrders.isNotEmpty && !isLoading && channel == null) {
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      final Uri url =
          Uri.parse('${wsUrl}ws/order/get-updates/?token=$authToken');
      channel = IOWebSocketChannel.connect(url);
      channel!.stream.listen((event) {
        final Map<dynamic, dynamic> data = json.decode(event);
        ref
            .read(orderProvider.notifier)
            .updatePendingOrderStatus(data["order_id"], data["status"]);
      });
    } else if (allOrders.pendingOrders.isEmpty && channel != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(homeScreenBuilderProvider.notifier).setPendingOrders(false);
      });

      channel!.sink.close();
    }

    final Map<int, Widget> viewSelector = {
      0: PendingOrderScreen(
        orders: allOrders.pendingOrders,
      ),
      1: PreviousOrderScreen(
        orders: allOrders.previousOrders,
        usePadding: allOrders.pendingOrders.isNotEmpty,
      ),
    };

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : allOrders.pendingOrders.isEmpty
            ? viewSelector[1]!
                .animate()
                .fadeIn(duration: 700.ms)
                .moveY(duration: 700.ms, begin: -20, end: 0)
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView.builder(
                    controller: controller,
                    itemBuilder: (context, index) => viewSelector[index],
                    onPageChanged: (value) {
                      currentScreen.value = value;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: currentScreen,
                    builder: (context, currentIndex, child) {
                      return Positioned(
                        top: 10,
                        child: Material(
                          elevation: 5,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            width: 200,
                            height: 60,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedPositioned(
                                  height: 40,
                                  left: currentIndex == 0 ? 0 : 93,
                                  duration: const Duration(milliseconds: 100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    padding: const EdgeInsets.all(10),
                                    width: 85,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (currentIndex != 0) {
                                          controller.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Pending",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: currentIndex == 0
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (currentIndex != 1) {
                                          controller.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          "Previous",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: currentIndex == 1
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
                .animate()
                .fadeIn(duration: 700.ms)
                .moveY(duration: 700.ms, begin: -20, end: 0);
  }
}
