import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 0)
class Store {
  //user's authorization token which is used as a header while making requests
  @HiveField(0, defaultValue: "")
  String authToken;

  //determines if the onboarding screen should be displayed or not
  @HiveField(1, defaultValue: false)
  bool onboardingCompleted;

  //determines if the update profile modal should be displayed or not
  @HiveField(2, defaultValue: false)
  bool showUpdateProfilePopup;

  //user to store current user's username
  @HiveField(3, defaultValue: "")
  String username;

  //used to store current user's saved address
  @HiveField(4, defaultValue: [])
  List<dynamic> savedAddresses;

  //used to store current user's email
  @HiveField(5, defaultValue: "")
  String userEmail;

  //used to store user's preferred payment mode
  //0 stands for cash
  //check data/payment_mode.dart for mappings
  @HiveField(6, defaultValue: 0)
  int preferredPaymentMode;

  //used to determine if the firebase cloud messaging token has been stored in the backend
  @HiveField(7, defaultValue: false)
  bool fcmTokenStored;

  Store(
      {this.authToken = "",
      this.onboardingCompleted = false,
      this.showUpdateProfilePopup = false,
      this.username = "",
      this.savedAddresses = const [],
      this.userEmail = "",
      this.preferredPaymentMode = 0,
      this.fcmTokenStored = false});
}
