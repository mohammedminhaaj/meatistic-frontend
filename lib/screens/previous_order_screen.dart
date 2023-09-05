import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/screens/order_summary.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/order_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreviousOrderScreen extends StatefulWidget {
  const PreviousOrderScreen(
      {super.key, required this.orders, this.usePadding = false});

  final List<Order> orders;
  final bool usePadding;

  @override
  State<PreviousOrderScreen> createState() => _PreviousOrderScreenState();
}

class _PreviousOrderScreenState extends State<PreviousOrderScreen> {
  final Box<Store> box = Hive.box<Store>("store");
  late List<Order> cachedOrders;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  String searchText = "";
  int page = 1;
  bool searchingOrders = false;
  bool extendingOrders = false;
  bool endOfList = false;
  Timer? _debounceTimer;

  bool areOrdersSame(List<Order> list1, List<Order> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (!list1[i].equals(list2[i])) {
        return false;
      }
    }

    return true;
  }

  void handleExtendOrder() {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !endOfList) {
      setState(() {
        extendingOrders = true;
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(handleExtendOrder);
    cachedOrders = [...widget.orders];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(handleExtendOrder);
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (searchingOrders || extendingOrders) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        final Map<String, String> queryParams = {
          "page": page.toString(),
          "search_text": searchText
        };
        final Uri url =
            Uri.https(baseUrl, "/api/order/get-previous-orders/", queryParams);
        final Store store = box.get("storeObj", defaultValue: Store())!;
        final String authToken = store.authToken;
        http
            .get(url, headers: getAuthorizationHeaders(authToken))
            .then((response) {
          final List<dynamic> data = json.decode(response.body);
          if (searchingOrders && !extendingOrders) {
            cachedOrders = data.map<Order>((e) => Order.fromJson(e)).toList();
            setState(() {
              searchingOrders = false;
            });
          } else if (extendingOrders && !searchingOrders) {
            cachedOrders = [
              ...cachedOrders,
              ...data.map<Order>((e) => Order.fromJson(e)).toList()
            ];
            setState(() {
              extendingOrders = false;
              if (data.isEmpty) {
                endOfList = true;
              }
            });
          }
          _debounceTimer!.cancel();
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content: Text("Something went wrong while fetching orders")));
          _debounceTimer!.cancel();
        });
      });
    }

    if (searchText.length < 3 &&
        !areOrdersSame(cachedOrders, widget.orders) &&
        page == 1) {
      cachedOrders = [...widget.orders];
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    }

    return widget.orders.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/no-data.png"),
              const Text(
                "Nothing to show here",
                style: TextStyle(fontSize: 20),
              )
            ],
          )
        : Padding(
            padding: EdgeInsets.only(
                top: widget.usePadding ? 90 : 10,
                left: 10,
                right: 10,
                bottom: 10),
            child: Column(children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    if (value.length >= 3) {
                      searchingOrders = true;
                    } else {
                      searchingOrders = false;
                    }

                    if (page != 1) {
                      page = 1;
                      endOfList = false;
                    }
                  });
                },
                controller: _controller,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    hintText: "Search orders...",
                    suffixIcon: searchText.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _controller.clear();
                              setState(() {
                                searchText = "";
                                if (page != 1) {
                                  page = 1;
                                  endOfList = false;
                                }
                                if (searchingOrders) {
                                  searchingOrders = false;
                                }
                                if (extendingOrders) {
                                  extendingOrders = false;
                                }
                              });
                            },
                            child: const Icon(Icons.close_rounded),
                          )
                        : null,
                    suffixIconColor: Theme.of(context).colorScheme.primary,
                    prefixIcon: const Icon(Icons.search_rounded),
                    prefixIconColor: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: searchingOrders
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : cachedOrders.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child:
                                      Image.asset("assets/images/no-data.png")),
                              Text(
                                "No results for '$searchText' found",
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: cachedOrders.length + 1,
                            itemBuilder: (context, index) {
                              return index < cachedOrders.length
                                  ? InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => OrderSummary(
                                            order: cachedOrders[index],
                                          ),
                                        ));
                                      },
                                      child:
                                          OrderCard(order: cachedOrders[index]))
                                  : Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: endOfList
                                            ? Text(
                                                "No more orders to display",
                                                style: TextStyle(
                                                    color: Colors.grey[500]),
                                              )
                                            : SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: extendingOrders
                                                    ? const CircularProgressIndicator()
                                                    : null),
                                      ),
                                    );
                            },
                          ),
              ),
            ]),
          );
  }
}
