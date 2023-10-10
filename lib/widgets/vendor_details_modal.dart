import 'package:flutter/material.dart';
import 'package:meatistic/models/vendor.dart';
import 'package:meatistic/settings.dart';
import 'package:meatistic/widgets/modal_header.dart';
import 'package:meatistic/widgets/review_modal.dart';
import 'package:url_launcher/url_launcher.dart';

final Map<String, Color?> vendorStatusIcon = {
  "Open": Colors.green,
  "Busy": Colors.red,
  "Closed": Colors.grey,
};

class VendorDetailsModal extends StatelessWidget {
  const VendorDetailsModal({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final Uri mapUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/staticmap?center=${vendor.latitude},${vendor.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7C${vendor.latitude},${vendor.longitude}&key=$gmapApi");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModalHeader(headerText: "Vendor Details"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      vendor.displayName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: vendorStatusIcon[vendor.status]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("(${vendor.status})")
                  ],
                ),
              ),
              if (vendor.rating != null)
                TextButton.icon(
                    onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => ReviewModal(
                            getUrl: "/api/vendor/get-feedbacks/",
                            queryParam: {"vendor": vendor.displayName},
                          ),
                        ),
                    icon: const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    label: Text(
                      vendor.rating!,
                      style: const TextStyle(fontSize: 20),
                    ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Image.network(
            mapUrl.toString(),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  "Owner",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 4,
                  child: Text(
                    vendor.owner,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  "Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: Text(
                  vendor.address,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  "Contact",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () async {
                    final url = Uri(scheme: 'tel', path: vendor.contact);
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    }
                  },
                  child: Text(
                    vendor.contact,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 4,
                child: vendor.email != null
                    ? Text(
                        vendor.email!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    : const Text("-"),
              )
            ],
          )
        ],
      ),
    );
  }
}
