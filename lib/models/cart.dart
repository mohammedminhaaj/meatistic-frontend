import 'package:meatistic/models/product.dart';

class Cart {
  Cart(
      {required this.product,
      required this.selectedQuantity,
      this.quantityCount = 1,
      this.orderPrice});

  final Product product;
  final ProductQuantity selectedQuantity;
  int quantityCount;
  final String? orderPrice;

  double get getCalculatedPrice {
    return double.parse(selectedQuantity.price) * quantityCount;
  }

  double get getOrderPrice {
    return orderPrice != null ? double.parse(orderPrice!) * quantityCount : 0.0;
  }
}
