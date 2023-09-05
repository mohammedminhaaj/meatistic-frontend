import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:meatistic/models/coupon.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/providers/coupon_provider.dart';
import 'dart:convert';

import 'package:meatistic/settings.dart';

class OfferSection extends ConsumerStatefulWidget {
  const OfferSection({
    super.key,
    this.appliedCoupon,
    required this.total,
  });

  final Coupon? appliedCoupon;
  final double total;

  @override
  ConsumerState<OfferSection> createState() => _OfferSectionState();
}

class _OfferSectionState extends ConsumerState<OfferSection> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  bool isLoading = false;
  final Box<Store> box = Hive.box("store");

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onApply() {
    setState(() {
      _errorText = null;
    });
    if (_controller.text.isEmpty) {
      setState(() {
        _errorText = "This field cannot be empty";
      });
      return;
    }
    setState(() {
      isLoading = true;
    });

    final Uri url = Uri.https(baseUrl, "/api/cart/verify-coupon/");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String authToken = store.authToken;
    http
        .post(url,
            headers: getAuthorizationHeaders(authToken),
            body: json.encode({"coupon": _controller.text}))
        .then((response) {
      setState(() {
        isLoading = false;
      });

      final Map<dynamic, dynamic> data = json.decode(response.body);
      if (response.statusCode >= 400) {
        setState(() {
          _errorText = data["details"];
        });
      } else {
        _controller.clear();
        ref.read(couponProvider.notifier).setFromJson(data);
      }
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(
            content:
                Text("Something went wrong while processing coupon data")));
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool couponHasErrors = widget.appliedCoupon != null &&
        widget.appliedCoupon!.hasErrors(widget.total);
    return widget.appliedCoupon != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color:
                        couponHasErrors ? Colors.red[300] : Colors.green[400],
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                                couponHasErrors
                                    ? Icons.error_rounded
                                    : Icons.check_circle_rounded,
                                color: Colors.white),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.appliedCoupon!.code,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    widget.appliedCoupon!.description,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            ref.read(couponProvider.notifier).removeCoupon();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ))
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                couponHasErrors
                    ? widget.appliedCoupon!.errorText!
                    : "Coupon applied!",
                style: TextStyle(
                    color: couponHasErrors ? Colors.red : Colors.green[700]),
              )
            ],
          )
        : TextField(
            style: TextStyle(
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 17),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
              setState(() {
                _errorText = null;
              });
            },
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _errorText = null;
              });
            },
            decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                hintText: "Enter coupon code...",
                hintStyle: const TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
                errorText: _errorText,
                suffixIcon: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: const ContinuousRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    onPressed: isLoading ? null : onApply,
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Apply"),
                  ),
                )),
          );
  }
}
