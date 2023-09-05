import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  const RatingBar({super.key, this.initialRating, this.onSelect});

  final int? initialRating;
  final void Function(int)? onSelect;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late int selectedRating;

  @override
  void initState() {
    selectedRating = widget.initialRating ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(
          width: 5,
        ),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedRating = index + 1;
              });
              if (widget.onSelect != null) {
                widget.onSelect!(selectedRating);
              }
            },
            child: Icon(
              selectedRating <= index
                  ? Icons.star_border_rounded
                  : Icons.star_rounded,
              color: Colors.amber[500],
              size: 30,
            )),
      ),
    );
  }
}
