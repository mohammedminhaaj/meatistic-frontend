import 'package:flutter/material.dart';
import 'package:meatistic/widgets/push_notification_setting.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [PushNotificationSetting()],
        ),
      ),
    );
  }
}
