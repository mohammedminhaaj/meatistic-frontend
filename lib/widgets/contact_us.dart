import 'package:flutter/material.dart';
import 'package:meatistic/widgets/modal_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const ModalHeader(headerText: "Contact Us"),
        const Text(
          "Stuck Somewhere? Need help with something? Don't worry, we got you covered.",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Contact Number",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () async {
            final url = Uri(scheme: 'tel', path: "8861164741");
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            }
          },
          child: Text(
            "8861164741",
            style: TextStyle(
                fontSize: 25, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Email",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "support@meatistic.com",
          style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
