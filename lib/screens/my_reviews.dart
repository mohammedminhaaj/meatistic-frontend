import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/utils/datetime.dart';
import 'package:meatistic/widgets/delete_action_background.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  late final ScrollController _scrollController;
  bool reviewsLoading = true;
  bool reviewsExtending = false;
  final Box<Store> box = Hive.box<Store>("store");
  Map<dynamic, dynamic> orderFeedbacks = {};
  int page = 1;
  bool endOfList = false;

  void handleExtendReviews() {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !endOfList) {
      setState(() {
        reviewsExtending = true;
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(handleExtendReviews);
  }

  @override
  void dispose() {
    _scrollController.removeListener(handleExtendReviews);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reviewsLoading || reviewsExtending) {
      final url =
          getUri("/api/order/list-order-feedback/", {"page": page.toString()});
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String token = store.authToken;
      http.get(url, headers: getAuthorizationHeaders(token)).then((response) {
        final Map<dynamic, dynamic> data = json.decode(response.body);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content:
                    Text("Something went wrong while requesting reviews")));
        } else {
          setState(() {
            if (reviewsLoading) {
              reviewsLoading = false;
              orderFeedbacks = {...data};
            } else if (reviewsExtending) {
              reviewsExtending = false;
              if (data.isEmpty) {
                endOfList = true;
              } else {
                orderFeedbacks.addAll(data);
              }
            }
          });
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(
              content: Text("Something went wrong while fetching reviews")));
      });
    }

    final List<dynamic> orderIds = orderFeedbacks.keys.toList();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: reviewsLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading your reviews...")
                ],
              ),
            )
          : orderFeedbacks.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/images/empty.svg",
                        height: 250,
                        width: 250,
                      ),
                      const Text("You have not posted any reviews yet."),
                    ],
                  ),
                )
              : ListView.separated(
                  cacheExtent: 0,
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) => index < orderFeedbacks.length
                      ? Dismissible(
                          key: UniqueKey(),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete review?"),
                                content: const Text(
                                    "Are you sure you wish to delete this review?"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Delete")),
                                ],
                              ),
                            );
                          },
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              orderFeedbacks.removeWhere(
                                  (key, value) => key == orderIds[index]);
                            });
                            final url = getUri(
                              "/api/order/delete-order-feedback/",
                            );
                            final Store store =
                                box.get("storeObj", defaultValue: Store())!;
                            final String token = store.authToken;
                            http.delete(url,
                                headers: getAuthorizationHeaders(token),
                                body:
                                    json.encode({"orderId": orderIds[index]}));
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(const SnackBar(
                                content: Text("Review deleted successfully!"),
                              ));
                          },
                          background: const DeleteActionBackground(),
                          child: Material(
                            elevation: 5,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orderIds[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Text(
                                    "Placed on ${formatDate(DateTime.parse(orderFeedbacks[orderIds[index]]['created_at']))}",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  for (final key
                                      in orderFeedbacks[orderIds[index]]
                                              ['feedbacks']
                                          .keys)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  key,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5,
                                                    left: 5),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(orderFeedbacks[
                                                                    orderIds[
                                                                        index]]
                                                                ['feedbacks']
                                                            [key]["rating"]
                                                        .toString()),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          if (orderFeedbacks[orderIds[index]]
                                                      ['feedbacks'][key]
                                                  ["comment"] !=
                                              null)
                                            Text(
                                              orderFeedbacks[orderIds[index]]
                                                  ['feedbacks'][key]["comment"],
                                              style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .dashed,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                            )
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: endOfList
                                ? Text(
                                    "No more reviews to display",
                                    style: TextStyle(color: Colors.grey[500]),
                                  )
                                : SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: reviewsExtending
                                        ? const CircularProgressIndicator()
                                        : null),
                          ),
                        ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: orderIds.length + 1),
    );
  }
}
