import 'package:flutter/material.dart';

class ShippingTerms extends StatelessWidget {
  const ShippingTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shipping Policy for Meatistic",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Last Updated: 05-09-2023"),
          SizedBox(
            height: 10,
          ),
          Text(
            "1. Shipping Zones",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We currently offer shipping to RT Nagar, Frazer Town, HBR Layout, Kalyan Nagar in Bengaluru. Please note that delivery areas and shipping options may vary. Check our website/ App for the most up-to-date information on delivery areas and options."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2. Order Processing Time",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.1. Processing Time",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Orders placed before 6:00 PM every day will typically be processed on the same day. Orders placed after the cutoff time will be processed on the next day."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.2. Freshness Guarantee",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We take pride in delivering the freshest meat possible. Your order will be processed, packaged, and shipped from the meat stores with the utmost care to maintain freshness."),
          SizedBox(
            height: 10,
          ),
          Text(
            "3. Shipping Methods and Fees",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.1. Shipping Methods",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "The delivery of the ordered products from the seller to you will be made by the internal Meatistic delivery executive or logistics service providers assigned by Meatistic."),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.2. Shipping Fees",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Shipping fees are based on the order weight, and the delivery location. Shipping fees will be calculated and displayed during the checkout process."),
          SizedBox(
            height: 10,
          ),
          Text(
            "4. Delivery Timeframes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "4.1. Estimated Delivery",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "The estimated delivery time will depend on your location and availability of our Meatistic delivery executive or logistics service providers assigned by Meatistic. The Meatistic logistics team may take additional time to pack and dispatch certain products. Delivery timeframes are just estimates and are not guaranteed delivery timeframes and should not be relied upon as such. Deliveries to certain locations may take longer than expected due to accessibility of the location and serviceability by the logistics service provider. Estimated delivery times will be provided at the time of checkout."),
          SizedBox(
            height: 10,
          ),
          Text(
            "4.2. Delays",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We are not responsible for delays caused by unforeseen circumstances, such as extreme weather conditions or carrier-related issues. We will make every effort to communicate any potential delays to you."),
          SizedBox(
            height: 10,
          ),
          Text(
            "5. Shipping Restrictions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "5.1. Age Restriction",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "By placing an order, you confirm that you are of legal age to purchase meat products in your jurisdiction."),
          SizedBox(
            height: 10,
          ),
          Text(
            "5.2. Delivery Address",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "It is your responsibility to provide an accurate and complete delivery address. We are not liable for misdirected or delayed shipments due to inaccurate address information. Due to nature of the product and to ensure premium quality to all our customers, we humbly request to be available at your location at the time of delivery or assign a representative to collect meat and related items on your behalf."),
          SizedBox(
            height: 10,
          ),
          Text(
            "The logistics service provider assigned by Meatistic will make a maximum of three [3] attempts to deliver your order within the same day. In case you are not reachable, available or do not accept delivery of products in these attempts Meatistic reserves the right to cancel the order at its discretion. You may be informed of such cancellation by email or SMS at the email address or mobile number provided to Meatistic. You agree not to hold Meatistic liable for any cancellation.",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "6. Delivery Confirmation",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "6.1 Tracking",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Once your order is placed, an order number will be generated. You can use this number to track the status of your delivery inside the application."),
          SizedBox(
            height: 10,
          ),
          Text(
            "If you wish to change the selected product or the delivery time, please contact the support, so we can handle your request. However, all requests are subject to availability of delivery slots.",
          ),
        ],
      ),
    );
  }
}
