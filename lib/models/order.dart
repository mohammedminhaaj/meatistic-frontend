import 'package:meatistic/models/cart.dart';
import 'package:meatistic/models/product.dart';
import 'package:meatistic/utils/datetime.dart';

class Order {
  final String orderId;
  String orderStatus;
  final String paymentMode;
  final double amount;
  final double deliveryCharge;
  final double? discount;
  final double total;
  final String address;
  final String createdAt;
  final List<Cart> cart;
  final String? deliveryInstructions;
  final String latitude;
  final String longitude;
  bool feedbackCompleted;

  Order(
      {required this.orderId,
      required this.orderStatus,
      required this.paymentMode,
      required this.amount,
      required this.deliveryCharge,
      this.discount,
      required this.total,
      required this.address,
      this.deliveryInstructions,
      required this.cart,
      required this.createdAt,
      required this.latitude,
      required this.longitude,
      required this.feedbackCompleted});

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
        orderId: json["order_id"],
        orderStatus: json["order_status"],
        paymentMode: json["payment_mode"],
        amount: double.parse(json["amount"]),
        deliveryCharge: double.parse(json["delivery_charge"]),
        discount:
            json["discount"] == null ? null : double.parse(json["discount"]),
        total: json["total"],
        address: json["address"],
        createdAt: json["created_at"],
        latitude: json["latitude"],
        deliveryInstructions: json["delivery_instructions"],
        longitude: json["longitude"],
        feedbackCompleted: json["feedback_completed"],
        cart: json["cart"]
            .map<Cart>((cartItem) => Cart(
                product: Product.fromJson(cartItem["product"]),
                selectedQuantity:
                    ProductQuantity.fromJson(cartItem["product_quantity"]),
                quantityCount: cartItem["quantity_count"],
                orderPrice: cartItem["order_price"]))
            .toList());
  }

  String get getLocalCreatedAt {
    final DateTime parsedDateTime = DateTime.parse(createdAt);

    final DateTime localDateTime = parsedDateTime.toLocal();

    return formatDate(localDateTime);
  }

  bool equals(Order order) => orderId == order.orderId;
}

class AllOrders {
  const AllOrders(
      {this.pendingOrders = const [], this.previousOrders = const []});

  final List<Order> pendingOrders;
  final List<Order> previousOrders;

  factory AllOrders.fromJson(Map<dynamic, dynamic> json) {
    final List<Order> pendingOrders = json["pending"]
        .map<Order>((element) => Order.fromJson(element))
        .toList();
    final List<Order> previousOrders = json["previous"]
        .map<Order>((element) => Order.fromJson(element))
        .toList();
    return AllOrders(
        pendingOrders: pendingOrders, previousOrders: previousOrders);
  }

  AllOrders copyWith(
      {List<Order>? previousOrders, List<Order>? pendingOrders}) {
    return AllOrders(
      previousOrders: previousOrders ?? this.previousOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
    );
  }
}
