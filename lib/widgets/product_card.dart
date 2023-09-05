import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meatistic/screens/product_details.dart';
import 'package:meatistic/settings.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {super.key,
      required this.image,
      required this.name,
      required this.displayName,
      required this.quantity,
      required this.price,
      required this.originalPrice,
      this.rating});

  final String image;
  final String name;
  final String displayName;
  final String quantity;
  final double price;
  final double originalPrice;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final String productImage = Uri.https(baseUrl, image).toString();
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) =>
                ProductDetail(name: name, productImage: productImage)));
      },
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Material(
              elevation: 5,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(productImage)),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                constraints:
                    const BoxConstraints(maxWidth: 150, maxHeight: 150),
              ),
            ),
            if (rating != null)
              Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    elevation: 5,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 2, right: 7, top: 2, bottom: 2),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Row(children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber[500],
                          size: 20,
                        ),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ]),
                    ),
                  )),
            Positioned(
              bottom: -60,
              child: Material(
                elevation: 5,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  constraints:
                      const BoxConstraints(maxWidth: 170, maxHeight: 85),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              quantity,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: "\u{20B9}${originalPrice.toInt()}",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              TextSpan(
                                text: "  \u{20B9}${price.toInt()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ], style: const TextStyle(color: Colors.black))),
                          ],
                        )
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
