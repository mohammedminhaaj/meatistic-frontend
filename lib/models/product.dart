import 'package:meatistic/models/vendor.dart';

class ProductQuantity {
  ProductQuantity(
      {required this.id,
      required this.quantity,
      required this.price,
      required this.originalPrice});
  final int id;
  final String quantity;
  final String price;
  final String originalPrice;

  factory ProductQuantity.fromJson(Map<dynamic, dynamic> json) {
    return ProductQuantity(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"],
        originalPrice: json["original_price"]);
  }
}

class Product {
  Product(
      {this.image,
      required this.name,
      required this.displayName,
      required this.vendor,
      this.description,
      required List<dynamic> availableQuantities,
      this.deletedAt,
      this.rating})
      : availableQuantities = availableQuantities
            .map((item) => ProductQuantity.fromJson(item))
            .toList();

  final String? image;
  final String name;
  final String displayName;
  final Vendor vendor;
  final String? description;
  final List<ProductQuantity> availableQuantities;
  final String? deletedAt;
  final double? rating;

  factory Product.empty() {
    return Product(
        name: "",
        displayName: "",
        vendor: Vendor.empty(),
        availableQuantities: []);
  }

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
        name: json["name"] ?? "",
        image: json["image"],
        displayName: json["display_name"] ?? "",
        vendor: json["vendor"] != null
            ? Vendor.fromJson(json["vendor"])
            : Vendor.empty(),
        availableQuantities: json["product_quantity"] ?? [],
        deletedAt: json["deleted_at"],
        rating: json["rating"],
        description: json["description"]);
  }
}
