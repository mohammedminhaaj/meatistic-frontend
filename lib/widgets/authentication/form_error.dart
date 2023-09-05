import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meatistic/widgets/error_message.dart';

class FormError extends StatelessWidget {
  const FormError({super.key, required this.errors});

  final List<dynamic> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: Column(
            children: List.generate(errors.length,
                (index) => ErrorMessage(errorText: errors[index])),
          ),
        )
            .animate()
            .fadeIn(duration: 100.ms)
            .moveY(duration: 100.ms, begin: -10, end: 0),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
