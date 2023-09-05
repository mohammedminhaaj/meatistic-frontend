import 'package:flutter/material.dart';
import 'package:meatistic/widgets/update_profile_modal_form.dart';

class UpdateProfileModal extends StatelessWidget {
  const UpdateProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hmm, looks like you haven't updated your profile information yet.",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Would you like to update it now?",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            UpdateProfileModalForm(),
          ],
        ),
      ),
    );
  }
}
