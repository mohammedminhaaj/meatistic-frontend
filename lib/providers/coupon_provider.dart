import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/models/coupon.dart';

class CouponNotifier extends StateNotifier<Coupon?> {
  CouponNotifier() : super(null);

  void setFromJson(Map<dynamic, dynamic> json) {
    state = Coupon.fromJson(json);
  }

  void removeCoupon() {
    state = null;
  }
}

final couponProvider =
    StateNotifierProvider<CouponNotifier, Coupon?>((ref) => CouponNotifier());
