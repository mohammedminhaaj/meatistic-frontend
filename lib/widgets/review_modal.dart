import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/modal_header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewModal extends StatefulWidget {
  const ReviewModal(
      {super.key, required this.getUrl, required this.queryParam});

  final String getUrl;
  final Map<String, String> queryParam;

  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  late final ScrollController _scrollController;
  bool reviewsLoading = true;
  bool reviewsExtending = false;
  final Box<Store> box = Hive.box<Store>("store");
  List<OrderFeedback> orderFeedbacks = [];
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
      final url = getUri(
          widget.getUrl, {...widget.queryParam, "page": page.toString()});
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String token = store.authToken;
      http.get(url, headers: getAuthorizationHeaders(token)).then((response) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
              orderFeedbacks = data
                  .map<OrderFeedback>((json) => OrderFeedback.fromJson(json))
                  .toList();
            } else if (reviewsExtending) {
              reviewsExtending = false;
              if (data.isEmpty) {
                endOfList = true;
              } else {
                orderFeedbacks.addAll(data
                    .map<OrderFeedback>((json) => OrderFeedback.fromJson(json))
                    .toList());
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalHeader(headerText: "Reviews"),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: reviewsLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Loading reviews...")
                    ],
                  )
                : orderFeedbacks.isEmpty
                    ? const Center(
                        child: Text("No reviews posted yet"),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => index <
                                orderFeedbacks.length
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            orderFeedbacks[index].username,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          "${orderFeedbacks[index].createdAt} ago",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        5,
                                        (listIndex) => Icon(
                                              listIndex <
                                                      orderFeedbacks[index]
                                                          .rating
                                                  ? Icons.star_rounded
                                                  : Icons.star_outline_rounded,
                                              color: Colors.amber,
                                            )),
                                  ),
                                  if (orderFeedbacks[index].comment != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        orderFeedbacks[index].comment!,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                ],
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: endOfList
                                      ? Text(
                                          "No more reviews to display",
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        )
                                      : SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: reviewsExtending
                                              ? const CircularProgressIndicator()
                                              : null),
                                ),
                              ),
                        separatorBuilder: (context, separatorIndex) =>
                            separatorIndex == orderFeedbacks.length - 1
                                ? const SizedBox.shrink()
                                : const Divider(
                                    height: 40,
                                  ),
                        itemCount: orderFeedbacks.length + 1),
          )
        ],
      ),
    );
  }
}
