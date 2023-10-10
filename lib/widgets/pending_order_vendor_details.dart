import 'package:flutter/material.dart';
import 'package:meatistic/models/vendor.dart';
import 'package:meatistic/widgets/elevated_container.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingOrderVendorDetails extends StatelessWidget {
  const PendingOrderVendorDetails({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.all(10),
          tilePadding: const EdgeInsets.all(0),
          leading: Icon(
            Icons.person_pin,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text(
            "Vendor Details",
            style: TextStyle(fontSize: 17),
          ),
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendor.displayName,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            vendor.address,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w100),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () async {
                          final url = Uri(scheme: 'tel', path: vendor.contact);
                          if (await canLaunchUrl(url)) {
                            launchUrl(url);
                          }
                        },
                        icon: Icon(
                          Icons.phone_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
