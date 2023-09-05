enum CouponType { fixed, percentage, freeShipping }

final Map<String, CouponType> couponTypeMapping = {
  "Fixed Amount": CouponType.fixed,
  "Free Shipping": CouponType.freeShipping,
  "Percentage": CouponType.percentage
};

class Coupon {
  Coupon(
      {required this.code,
      required this.description,
      required this.couponType,
      required this.validFrom,
      this.discountAmount,
      this.discountPercentage,
      this.maxDiscountAmount,
      this.minOrderAmount,
      this.validUntil});

  final String code;
  final String description;
  final CouponType couponType;
  final double? discountPercentage;
  final double? discountAmount;
  final double? maxDiscountAmount;
  final double? minOrderAmount;
  final DateTime validFrom;
  final DateTime? validUntil;
  String? errorText;

  bool hasErrors(double total) {
    final DateTime currentDateTimeUtc = DateTime.now().toUtc();
    if (!(validFrom.isBefore(currentDateTimeUtc) &&
        (validUntil == null ||
            (validUntil != null && validUntil!.isAfter(currentDateTimeUtc))))) {
      errorText = "The coupon has expired";
      return true;
    }

    if (minOrderAmount != null && total < minOrderAmount!) {
      errorText =
          "Add items worth \u{20B9}${minOrderAmount! - total} more to avail this discount";
      return true;
    }
    return false;
  }

  double getCalculatedDiscount(
      double total, double subTotal, double deliveryCharge) {
    final bool minimumOrderAmount =
        minOrderAmount != null && total < minOrderAmount!;
    switch (couponType) {
      case CouponType.fixed:
        {
          if (discountAmount == null || minimumOrderAmount) {
            return 0.0;
          }
          return discountAmount!;
        }

      case CouponType.percentage:
        {
          if (discountPercentage == null || minimumOrderAmount) {
            return 0.0;
          }
          final double discountAmount =
              subTotal * (discountPercentage! / 100.0);
          if (maxDiscountAmount != null) {
            return discountAmount <= maxDiscountAmount!
                ? discountAmount
                : maxDiscountAmount!;
          } else {
            return discountAmount;
          }
        }

      case CouponType.freeShipping:
        {
          if (minimumOrderAmount) {
            return 0.0;
          }
          return deliveryCharge;
        }
    }
  }

  factory Coupon.fromJson(Map<dynamic, dynamic> json) => Coupon(
      code: json["code"],
      description: json["description"],
      couponType: couponTypeMapping[json["coupon_type"]]!,
      validFrom: DateTime.parse(json["valid_from"]),
      discountPercentage: json["discount_percentage"] != null
          ? double.parse(json["discount_percentage"])
          : null,
      discountAmount: json["discount_amount"] != null
          ? double.parse(json["discount_amount"])
          : null,
      maxDiscountAmount: json["max_discount_amount"] != null
          ? double.parse(json["max_discount_amount"])
          : null,
      minOrderAmount: json["min_order_amount"] != null
          ? double.parse(json["min_order_amount"])
          : null,
      validUntil: json["valid_until"] != null
          ? DateTime.parse(json["discount_percentage"])
          : null);
}
