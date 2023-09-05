import 'package:flutter/material.dart';
import 'package:meatistic/data/color.dart';

class VendorCard extends StatelessWidget {
  const VendorCard(
      {super.key,
      required this.index,
      required this.name,
      required this.distance,
      this.rating});

  final int index;
  final String name;
  final double? rating;
  final int distance;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 220,
      maxHeight: 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: vendorCardColor[index % 7]!),
                borderRadius: const BorderRadius.all(Radius.circular(25))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("<${distance}Km"),
                    if (rating != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "$rating",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
