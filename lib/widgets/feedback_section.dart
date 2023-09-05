import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meatistic/widgets/rating_bar.dart';

class FeedbackSection extends StatefulWidget {
  const FeedbackSection(
      {super.key, required this.addFeedback, required this.feedbackFor});

  final void Function(String, {int? rating, String? comment}) addFeedback;
  final String feedbackFor;

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  final ValueNotifier<int> rating = ValueNotifier<int>(0);

  @override
  void dispose() {
    rating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar(
          onSelect: (value) {
            widget.addFeedback(widget.feedbackFor, rating: value);
            rating.value = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, value, child) {
            return value != 0
                ? child!
                    .animate(target: value != 0 ? 1 : 0)
                    .fadeIn(duration: 600.ms)
                    .slideY(duration: 300.ms)
                : const SizedBox.shrink();
          },
          child: TextField(
            onChanged: (value) {
              widget.addFeedback(widget.feedbackFor, comment: value);
            },
            maxLength: 150,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            maxLines: 3,
            decoration: const InputDecoration(
                hintText: "Write here...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),
        ),
      ],
    );
  }
}
