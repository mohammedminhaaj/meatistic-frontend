import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Terms and Conditions of Meatistic",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Last Updated: 07-10-2023"),
          SizedBox(
            height: 10,
          ),
          Text(
              'Bee Smart International is the licensed owner of the brand Meatistic. Please read the terms of this Term of Service Agreement ("Website") carefully. By using the website – www.meatistic.com ("Website"), or the Meatistic mobile application on iOS or Android devices including phones, tablets or any other electronic devise ("Meatistic App"), or the mobile site, www.meatistic.com ("Mobile site"), whereas the Website, the Meatistic App and the Mobile site are together referred to as (the "Platform"), or purchasing products from the Platform you agree to be bound by all of the terms and conditions of this Agreement.'),
          SizedBox(
            height: 10,
          ),
          Text(
              'This Agreement governs your use of this Platform, use of the trade name – Bee Smart International ("Business Name"), the offer of products for purchase on this Platform, and/or your purchase of products available on this Platform.'),
          SizedBox(
            height: 10,
          ),
          Text(
            "1. Acceptance of Terms",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              'By accessing or using Meatistic (the "Application") and its services, you agree to comply with and be bound by these Terms and Conditions. If you do not agree with these terms, please do not use the app.'),
          SizedBox(
            height: 10,
          ),
          Text(
            "2. Ordering and Payment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.1. Order Placement",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Orders placed through the Website / App are subject to acceptance from Meatistic.com. We reserve the right to refuse any order for any reason."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.2. Payment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Payment for orders is processed through secure payment gateways. You agree to provide accurate payment information and ensure sufficient funds for successful payment."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.3. Pricing",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Product prices, taxes, and shipping fees are clearly displayed on the Website. Prices are subject to change without notice."),
          SizedBox(
            height: 10,
          ),
          Text(
            "3. Shipping and Delivery",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.1. Shipping",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We offer shipping to locations within our specified delivery areas. Shipping fees and delivery times are outlined on the Website."),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.2. Delivery",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "It is your responsibility to provide accurate shipping information. We are not liable for delivery delays or issues arising from inaccurate shipping details."),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.3. Inspection",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Upon receiving your order, inspect the products for accuracy and quality. Contact us immediately for any discrepancies or quality concerns."),
          SizedBox(
            height: 10,
          ),
          Text(
            "4. Product Quality and Returns",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "4.1. Quality Assurance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We take utmost care to provide high-quality meat products. If you are not satisfied with your order, please contact us immediately for resolution."),
          SizedBox(
            height: 10,
          ),
          Text(
            "4.2. Returns",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We accept returns of products in accordance with our Return Policy, which can be found on the Website."),
          SizedBox(
            height: 10,
          ),
          Text(
            "5. Privacy and Data Security",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Your use of the Website / App is also governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information."),
          SizedBox(
            height: 10,
          ),
          Text(
            "6. Intellectual Property",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "The content, logos, and trademarks on the Website/ App are owned by Meatistic and are protected by copyright and trademark laws. You may not use our intellectual property without our written consent."),
          SizedBox(
            height: 10,
          ),
          Text(
            "7. Liability and Disclaimers",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "7.1. Disclaimer",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We do not guarantee the accuracy, completeness, or suitability of information provided on the Website/ App. Products may vary slightly from images displayed."),
          SizedBox(
            height: 10,
          ),
          Text(
            "7.2. Liability",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Meatistic is not liable for any direct, indirect, incidental, consequential, or punitive damages arising from your use of the Website / App or any products purchased."),
          SizedBox(
            height: 10,
          ),
          Text(
            "8. Governing Law and Jurisdiction",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "These Terms and Conditions are governed by and construed in accordance with the law. Any disputes shall be subject to the exclusive jurisdiction of the courts of Bengaluru."),
          SizedBox(
            height: 10,
          ),
          Text(
            "9. Changes to Terms",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We reserve the right to update or modify these Terms and Conditions at any time. It is your responsibility to review them periodically."),
          SizedBox(
            height: 10,
          ),
          Text(
            "10. Contact Information",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "If you have questions or concerns about these Terms and Conditions, please contact us at support@meatistic.com.")
        ],
      ),
    );
  }
}
