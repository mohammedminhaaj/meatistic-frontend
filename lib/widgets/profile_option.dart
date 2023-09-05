import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  const ProfileOption(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap,
      this.iconColor});

  final String label;
  final IconData icon;
  final void Function() onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withOpacity(0.5)),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(80))),
                  child: Icon(
                    icon,
                    size: 25,
                    color: iconColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded)
          ],
        ),
      ),
    );
  }
}
