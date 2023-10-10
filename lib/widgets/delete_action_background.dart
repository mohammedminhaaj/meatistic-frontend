import 'package:flutter/material.dart';

class DeleteActionBackground extends StatelessWidget {
  const DeleteActionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[300],
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.keyboard_double_arrow_left_rounded, color: Colors.white),
            SizedBox(
              width: 10,
            ),
            Text(
              "Swipe to delete",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.delete_forever_rounded, color: Colors.white)
          ],
        ),
      ),
    );
  }
}
