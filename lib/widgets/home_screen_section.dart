import 'package:flutter/material.dart';

class HomeScreenSection extends StatelessWidget {
  const HomeScreenSection({
    super.key,
    required this.header,
    required this.onViewAll,
    required this.child,
  });

  final String header;
  final Function() onViewAll;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header,
                style: const TextStyle(fontSize: 30),
              ),
              TextButton(onPressed: onViewAll, child: const Text("View All"))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }
}
