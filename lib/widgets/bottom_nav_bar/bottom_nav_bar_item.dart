import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  const CustomBottomNavigationBarItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.isSelected,
      this.onTap,
      this.useStack = false,
      this.layer});

  final IconData icon;
  final String label;
  final bool isSelected;
  final void Function()? onTap;
  final bool useStack;
  final Widget? layer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25))
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (useStack)
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  Icon(
                    icon,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  )
                      .animate(target: isSelected ? 1 : 0)
                      .scaleXY(end: 0.8)
                      .tint(color: Colors.white),
                  if (layer != null)
                    layer!.animate(target: isSelected ? 1 : 0).scaleXY(end: 0.8)
                ],
              )
            else
              Icon(
                icon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              )
                  .animate(target: isSelected ? 1 : 0)
                  .scaleXY(end: 0.7)
                  .tint(color: Colors.white),
            Visibility(
              visible: useStack && layer != null,
              child: const SizedBox(
                width: 5,
              ),
            ),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              )
          ],
        ),
      )
          .animate(target: isSelected ? 1 : 0)
          .shimmer()
          .scaleXY(begin: 0.9, end: 1),
    );
  }
}
