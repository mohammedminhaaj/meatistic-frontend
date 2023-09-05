import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/order.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/elevated_container.dart';
import 'package:meatistic/widgets/feedback_section.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderFeedback extends StatefulWidget {
  const OrderFeedback({super.key, required this.order});

  final Order order;

  @override
  State<OrderFeedback> createState() => _OrderFeedbackState();
}

class _OrderFeedbackState extends State<OrderFeedback> {
  final Set<String> vendorNames = {};
  late final ValueNotifier<Map<String, dynamic>> feedback;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final Box<Store> box = Hive.box<Store>("store");

  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (final cart in widget.order.cart) {
      vendorNames.add(cart.product.vendor.displayName);
    }
    feedback = ValueNotifier<Map<String, dynamic>>({
      "order": widget.order.orderId,
      "item_feedbacks": {},
      "vendor_feedbacks": {}
    });
  }

  void addFeedback(String key, String itemName,
      {int? rating, String? comment}) {
    if (feedback.value[key].containsKey(itemName)) {
      final Map<String, dynamic> itemToUpdate = feedback.value[key][itemName];
      if (rating != null) {
        itemToUpdate["rating"] = rating;
      }
      if (comment != null) {
        itemToUpdate["comment"] = comment;
      }
    } else {
      feedback.value[key][itemName] = {"rating": rating, "comment": comment};
    }
  }

  void addItemFeedback(String itemName, {int? rating, String? comment}) {
    addFeedback("item_feedbacks", itemName, rating: rating, comment: comment);
  }

  void addVendorFeedback(String itemName, {int? rating, String? comment}) {
    addFeedback("vendor_feedbacks", itemName, rating: rating, comment: comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order.orderId),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          ElevatedContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rate Items",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0; i < widget.order.cart.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.cart[i].product.displayName,
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FeedbackSection(
                      addFeedback: addItemFeedback,
                      feedbackFor: widget.order.cart[i].product.name,
                    ),
                    if (i != widget.order.cart.length - 1)
                      const Divider(
                        height: 20,
                      )
                  ],
                )
            ],
          )),
          const SizedBox(
            height: 20,
          ),
          ElevatedContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rate Vendors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0; i < vendorNames.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendorNames.elementAt(i),
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FeedbackSection(
                      addFeedback: addVendorFeedback,
                      feedbackFor: vendorNames.elementAt(i),
                    ),
                    if (i != vendorNames.length - 1)
                      const Divider(
                        height: 20,
                      )
                  ],
                )
            ],
          )),
        ]),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: feedback,
        builder: (context, feedbackValue, child) => ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, loadingValue, child) => TextButton(
            onPressed: loadingValue
                ? null
                : () {
                    if (feedbackValue["item_feedbacks"].isEmpty &&
                        feedbackValue["vendor_feedbacks"].isEmpty) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(const SnackBar(
                            content: Text(
                                "Please rate atleast one section before submitting")));
                      return;
                    }
                    final Uri url =
                        Uri.https(baseUrl, "/api/order/add-order-feedback/");
                    final Store store =
                        box.get("storeObj", defaultValue: Store())!;
                    final String authToken = store.authToken;
                    isLoading.value = true;
                    http
                        .post(url,
                            body: json.encode(feedbackValue),
                            headers: getAuthorizationHeaders(authToken))
                        .then((response) {
                      isLoading.value = false;
                      final Map<dynamic, dynamic> data =
                          json.decode(response.body);
                      if (response.statusCode >= 400) {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                              SnackBar(content: Text(data["details"])));
                      } else {
                        Navigator.of(context).pop(data["details"]);
                      }
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(const SnackBar(
                            content: Text("Something went wrong")));
                    });
                  },
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(20),
                shape: const ContinuousRectangleBorder(),
                foregroundColor: Colors.white,
                backgroundColor: loadingValue
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary),
            child: loadingValue
                ? const SizedBox(
                    height: 16, width: 16, child: CircularProgressIndicator())
                : const Text(
                    "Submit",
                    style: TextStyle(fontSize: 17),
                  ),
          ),
        ),
      ),
    );
  }
}
