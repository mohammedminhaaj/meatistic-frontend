import 'package:flutter/material.dart';

class ReturnPolicy extends StatelessWidget {
  const ReturnPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Return and Refund Policy for Meatistic",
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
            "1. Satisfaction Guarantee",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "At Meatistic, we are committed to providing you with the highest quality meat products. If you are not satisfied with your purchase for any reason, please review our return and refund policy below."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2. Returns",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.1. Eligibility",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "To be eligible for a return, your item must be unused and in the same condition that you received it. It must also be in the original packaging."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.2. Request Process",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "The returned products are subject to verification and quality checks by the sellers selling on Meatistic in order to determine the legitimacy of the complaint or return. To initiate a return, please contact our customer service team within 1 hour of receiving your order. Provide your order number and a description of the issue."),
          SizedBox(
            height: 10,
          ),
          Text(
            "2.3. Approval",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Once your return request is approved, we will provide you with instructions on how to return the item. Please do not return any product before receiving confirmation from us."),
          SizedBox(
            height: 10,
          ),
          Text(
            "3. Refunds",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.1. Refund Process",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Upon receiving and inspecting your returned item, we will notify you of the approval or rejection of your refund. If approved, your refund will be processed, and a credit will be automatically applied to your original payment method within 3 working days."),
          SizedBox(
            height: 10,
          ),
          Text(
            "No refund due to non-deliverability will be applicable to orders placed with Cash on Delivery options. Refund of Cash on Delivery orders returned by customer may subject to levy of a charge which will be deducted from customer refund amount.",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "3.2. Partial Refunds",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "In certain cases, partial refunds may be granted. This includes situations where only part of the order is returned or if the item is not in its original condition"),
          SizedBox(
            height: 10,
          ),
          Text(
            "4. Exchanges",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "We do not offer exchanges at this time. If you wish to exchange a product, please follow the return process, and then place a new order for the desired item."),
          SizedBox(
            height: 10,
          ),
          Text(
            "5. Food Safety",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "5.1. Perishable Items",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "Due to the perishable nature of our products, we cannot accept returns on items that have been opened, thawed, or used unless there is a quality issue."),
          SizedBox(
            height: 10,
          ),
          Text(
            "5.2. Quality Issues",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "If you believe that you have received a product with quality issues, please contact us immediately with details and photographs at support@meatistic.com")
        ],
      ),
    );
  }
}
