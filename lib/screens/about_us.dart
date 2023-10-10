import 'package:flutter/material.dart';
import 'package:meatistic/screens/privacy_policy.dart';
import 'package:meatistic/screens/return_policy.dart';
import 'package:meatistic/screens/shipping_terms.dart';
import 'package:meatistic/screens/terms_and_conditions.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("About Us"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                  "Meatistic is a unique service, dedicated to delivering top-quality fresh meat products directly to consumers' homes. In response to the growing demand for locally sourced and sustainably produced meats, Meatistic carefully selects its meat from trusted suppliers to ensure the highest standards of quality and freshness. Offering a diverse range of meat cuts and types, often with customizable orders, Meatistic simplifies the process for individuals and families to enjoy premium meats without the need to visit physical stores. Moreover, Meatistic places a strong emphasis on ethical and sustainable sourcing practices, attracting environmentally-conscious customers."),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          forceMaterialTransparency: true,
                          title: const Text("Terms and Conditions"),
                        ),
                        body: const TermsAndConditions(),
                      ),
                    ));
                  },
                  child: const Text("Terms & Conditions")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          forceMaterialTransparency: true,
                          title: const Text("Privacy Policy"),
                        ),
                        body: const PrivacyPolicy(),
                      ),
                    ));
                  },
                  child: const Text("Privacy Policy")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          forceMaterialTransparency: true,
                          title: const Text("Shipping Terms"),
                        ),
                        body: const ShippingTerms(),
                      ),
                    ));
                  },
                  child: const Text("Shipping Terms")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          forceMaterialTransparency: true,
                          title: const Text("Return & Refund Policy"),
                        ),
                        body: const ReturnPolicy(),
                      ),
                    ));
                  },
                  child: const Text("Return & Refund Policy")),
            ],
          )),
    );
  }
}
