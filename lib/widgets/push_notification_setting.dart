import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:meatistic/models/store.dart';
import 'dart:convert';

import 'package:meatistic/settings.dart';

class PushNotificationSetting extends StatefulWidget {
  const PushNotificationSetting({super.key});

  @override
  State<PushNotificationSetting> createState() =>
      _PushNotificationSettingState();
}

class _PushNotificationSettingState extends State<PushNotificationSetting> {
  bool pushNotification = false;
  bool settingPushNotification = true;
  final Map<String, String> queryParam = {};
  final Box<Store> box = Hive.box<Store>("store");
  final fcm = FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
    return await fcm.getToken();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (settingPushNotification) {
      final Uri url =
          getUri("/api/common/get-push-notification-setting/", queryParam);
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      getFcmToken().then((fcmToken) {
        http
            .post(url,
                headers: getAuthorizationHeaders(authToken),
                body: json.encode({
                  "registration_id": fcmToken,
                  "platform": Platform.isAndroid
                      ? "android"
                      : Platform.isIOS
                          ? "ios"
                          : "web"
                }))
            .then((response) {
          final Map<dynamic, dynamic> data = json.decode(response.body);
          if (response.statusCode >= 400) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(data["details"])));
          } else {
            setState(() {
              if (data.containsKey("current_status")) {
                pushNotification = data["current_status"];
              }
              settingPushNotification = false;
            });
          }
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content: Text(
                    "Something went wrong while fetching push notification status")));
        });
      });
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Push Notifications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Receive order updates, promotions, offers, etc.",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        settingPushNotification
            ? const SizedBox(
                height: 32, width: 32, child: CircularProgressIndicator())
            : Switch(
                value: pushNotification,
                onChanged: (value) {
                  setState(() {
                    settingPushNotification = true;
                    queryParam.addAll({"set": value.toString()});
                  });
                },
              ),
      ],
    );
  }
}
